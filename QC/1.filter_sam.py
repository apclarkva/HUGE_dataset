#!/usr/bin/env python

import re, sys
import argparse
from string import maketrans
from argparse import RawDescriptionHelpFormatter


description=""" This script will filter SAM files based on percent identity """

parser=argparse.ArgumentParser(description=description, formatter_class=RawDescriptionHelpFormatter)
parser.add_argument("--in", "-i", dest="fn", action='store', required=True, help="SAM file [Required]", metavar="SAM_FILE")
parser.add_argument("--pctid", "-p", dest="pctid", type=float, default=90, action='store', required=True, help="Percent Identity cut off [Required]. The default is 90", metavar="PERCENT_ID")
parser.add_argument("--minlen", "-m", dest="minlen", action='store', required=False, help="Minimum alignment length [Optional]")
args=parser.parse_args()


# read command line arguments
#fn = sys.argv[1] #Input SAM file
#pctid = float(sys.argv[2]) #Percent identity
#minlen = int(sys.argv[3]) #Minimum length?

MINPCT = 100.
pctid=args.pctid

def decode_cigar(cigar):
    res = []
    hbeg = 0 #The beginning of trimming
    alnlen = 0 #The length of the alignment, only the bases associated with M
    hend = 0 #Any trimming at the end
    tlen = 0 #total length
    tabs = re.split('([a-zA-Z])', cigar)[:-1]
    for i in range(len(tabs)/2):
        ci = int(tabs[i*2])
        li = tabs[i*2 + 1]
        if any( [li == 'H', li == 'S'] ):
            if i == 0:
                hbeg += ci
            else:
                hend += ci
        if li == 'M':
            alnlen += ci
        if li != 'H' and li != 'D' and li != 'S':
            tlen += ci
    return [hbeg, alnlen, hend, tlen]



def reverse_complement(seq):
    return seq.translate(maketrans('ACGTacgtNn', 'TGCAtgcaNn'))[::-1]


# initialize variables
cquery = ''
cseq = ''
cqual = ''
cflag = 1
cstrand = ''

# parse file
for line in open(args.fn):

    # print header
    if line.startswith('@'): 
        print line.rstrip()
        continue

    # get fields
    sline = line.rstrip().split('\t')
    query = sline[0]
    code = bin(int(sline[1]))[2:].zfill(12) #This line interprets the bitflag
    strand = int(code[-5])
    ref = sline[2]
    cigar = sline[5]
    cigar = re.sub('H','S',cigar) #Changes S to H in the CIGAR string
    sline[5] = cigar
    seq = sline[9]
    qual = sline[10]

    # skip empty hits
    if ref == '*' or cigar == '*':
        continue

    # make sure read is mapped
    if int(code[-3]) == 1: #a bit in the 3 position from the end means unmapped
        print 'ERROR 0'
        quit()

    # calculate edit distance, total length
    [hbeg, alnlen, hend, tlen] = decode_cigar(cigar)
    mismatch = int(re.search('[NX]M:i:(\d+)', line).group(1)) #Pulls edit distance info from NM tag
    #tlen = sum(map(int, re.split('[a-zA-Z]+', cigar)[:-1]))
    match = alnlen - mismatch

    # handle empty seq, qual fields
    if (seq == '*' or qual == '*') and (cquery != query):
        print 'ERROR 1'
        quit()

    # update current seq, qual
    if cquery != query:
        if seq == '*' or qual == '*':
            print 'ERROR 2'
            quit()
        cquery = query
        cseq = seq
        cqual = qual
        cstrand = strand
        cflag = 1

        # IS THERE EVER HARDCLIPPING IN THE FIRST HIT???
        if 'H' in cigar:
            print "AHH"
            quit()

    # filter by percent identity
    if 1.*match/tlen < 1.*pctid/100.: #This allows for decimal points
        continue

    if pctid < MINPCT:
        MINPCT = pctid #If pctid is less than 100.0%, change MINPCT to pctid

    # set the seq/qual columns

    # *** ALWAYS **** SET THE SEQ/QUAL COLUMNS
    if strand == cstrand:
        sline[9] = cseq
        sline[10] = cqual
    else:
        sline[9] = reverse_complement(cseq)
        sline[10] = reverse_complement(cseq)

    #if cflag == 1:
    #    if cquery == query:
    #        #sline[9] = cseq[hbeg:-hend]
    #        #sline[10] = cqual[hbeg:-hend]
    #        sline[9] = cseq
    #        sline[10] = cqual
    #        cflag = -1
    #    else:
    #        print 'ERROR 3'
    #        quit()

    # ensure that the cigar matches the sequence
    if tlen != (len(cseq) - hbeg - hend):
        print '\n\n'
        print cigar
        print '\n\n'
        print line.rstrip()
        print 'ERROR 4'
        print hbeg, hend, len(cseq)
        print cseq
        quit()

    # finally, print quality filtered line
    print '\t'.join(sline)


print MINPCT
