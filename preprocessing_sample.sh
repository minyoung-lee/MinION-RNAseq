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
cat RST2.fastq | awk '{if( (NR-2)%4==0){print length($1)}}' > RL
cat RL | awk '{sum+=$1}END{print sum}'


# read length distribution
## 1. find the longest read in each fastq file
longest=0
sort -h RL  | uniq -c > sorted
x=`tail -n 1 sorted | tr -s ' ' | cut -d " " -f3`
x_longest=($x)
if [ ${x_longest} -gt ${longest} ];then
longest=${x_longest}
fi
echo $longest

## 2. Prepare stat_readlength file
for ((i=0;i<= ${longest} ;i++));do echo $i >> RL0_longest;done

## 3. count read length distribution
x=`cat sorted | tr -s ' ' | cut -d " " -f3` 
readLength=($x)
y=`cat sorted | tr -s ' ' | cut -d " " -f2`
readCount=($y)
N=`wc -l sorted | cut -d " " -f1`
for ((i=0; i<=N; i++));
do
C[${readLength[i]}]="${readCount[i]}"
done
C[${readLength[0]}]="${readCount[0]}"

cat sorted | tr -s ' ' | cut -d " " -f3 > readLength
diff readLength RL0_longest | grep ">" | cut -d " " -f2 > i_nan.txt

for i in `cat ./i_nan.txt`
do
C[i]="NaN"
done

echo -e ${C[*]} > tmp
tr -s ' '  '\n'< tmp > RL_count
paste RL0_longest RL_count > stat_readLength.txt
rm RL sorted readLength i_nan.txt RL0_longest RL_count


# fastq conversion
sed -e s/U/T/g RST2.fastq > U2T_RST2.fastq
