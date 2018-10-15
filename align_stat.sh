#! /bin/bash

# Align to Reference genome
mkdir result_bwa_RST2
~/bwa/bwa mem -x ont2d fasta_BB_RST2/BbuRST2.180215.fasta  ./fastq/U2T_RST2.fastq > ./result_bwa_RST2/U2T_RST2.sam


# Alignment stats
cd result_bwa_RST2
samtools view -Sb U2T_RST2.sam > tmp.bam
samtools sort tmp.bam > U2T_RST2.bam
rm tmp.bam
samtools flagstat U2T_RST2.bam > flagstat_RST2.txt
samtools index U2T_RST2.bam
samtools idxstats U2T_RST2.bam > idxstats_RST2.txt
