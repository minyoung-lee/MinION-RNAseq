#! /bin/bash

# Align to Reference genome
mkdir result_bwa_RST2
~/bwa/bwa mem -x ont2d fasta_BB_RST2/BbuRST2.180215.fasta  ./fastq/U2T_RST2.fastq > ./result_bwa_RST2/RST2.sam


# Alignment stats
cd result_bwa_RST2
samtools view -Sb RST2.sam > tmp.bam
samtools sort tmp.bam > RST2.bam
rm tmp.bam
samtools flagstat RST2.bam > flagstat_RST2.txt
samtools index RST2.bam
samtools idxstats RST2.bam > idxstats_RST2.txt


# reads mapped to RST2 in a bam file
grep -P "chr|lp|cp" <(samtools view RST2.bam) > readsMapped2RST2.txt

cut -f3 readsMapped2RST2.txt > RNAME.txt
cut -f4 readsMapped2RST2.txt > POS.txt
cut -f5 readsMapped2RST2.txt > MAPQ.txt
cut -f6 readsMapped2RST2.txt > CIGAR.txt
