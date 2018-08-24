from subprocess import call
call("echo hello",shell=True)

from concurrent.futures import ThreadPoolExecutor

#open and read the text file with all the srr accession numbers. Save it to a variable called srr_data.
text_file = open("srr-data.txt", "r")
srr_data = text_file.read().split('\n')
text_file.close

#this just wraps a small shell script that does the downloading
def download(srr_number):
    call("./download-fastq-file.sh %s" % str(srr_number), shell=True) 
    pass

#this limits to 30 threads I'm pretty sure this will scale to cores
with ThreadPoolExecutor(max_workers=16) as executor:
    for srr_number in srr_data:
        future = executor.submit(download, srr_number)

    print(future.result())
