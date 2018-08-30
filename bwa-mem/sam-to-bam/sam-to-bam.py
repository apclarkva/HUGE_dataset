from subprocess import call
call("echo hello",shell=True)

from concurrent.futures import ThreadPoolExecutor

#open and read the text file with all the srr accession numbers. Save it to a variable called srr_data.
text_file = open("../../srr-data.txt", "r")
srr_data = text_file.read().split('\n')
print(srr_data)
text_file.close

#this just wraps a small shell script that runs bwa
def run_sam_to_bam(srr_number):
    call("./sam-to-bam.sh %s" % str(srr_number), shell=True) 
    pass

#this limits to 30 threads I'm pretty sure this will scale to cores
with ThreadPoolExecutor(max_workers=20) as executor:
    for srr_number in srr_data:
        future = executor.submit(run_sam_to_bam, srr_number)

    print(future.result())