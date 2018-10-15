#! /bin/bash

# merge fastq files
find -name '*.fastq' | sort > list_fastq.txt

>RST2.fastq
for input in `cat ./list_fastq.txt`
do
echo $input
cat $input >> RST2.fastq
done


# quality check
NanoPlot -t 2 --fastq RST2.fastq --plots hex dot -o ./nanoplot/RST2
NanoPlot -t 2 --fastq_rich RST2.fastq --plots hex dot -o ./nanoplot/RST2_fastqrich_log --loglength


# total number of reads
a=`wc -l RST2.fastq | cut -d" " -f1`
expr $a / 4


# total number of bases
cat RST1.fastq | awk '{if( (NR-2)%4==0){print length($1)}}' > RL
cat RL | awk '{sum+=$1}END{print sum}'
rm RL
