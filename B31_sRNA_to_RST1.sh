#! /bin/bash

# extract sequences from B31 sRNA coordinates and make a fasta file
>B31_sRNA.fa
while read line
do

echo $line
id=`echo $line | cut -d ' ' -f1`
chr=`echo $line | cut -d ' ' -f3`
start=`echo $line | cut -d ' ' -f4`
end=`echo $line | cut -d ' ' -f5`
len=`expr $end - $start + 1`
pos=`expr $start - 1`

fname=`echo "./fasta_BB_B31/Borreliella_burgdorferi_B31/Borreliella_burgdorferi_B31_$chr".fa`
fa=`cat $fname | sed '1,1d' | tr -d "\n" `
seq=`echo ${fa:$pos:$len}`
echo -e ">$id" >> B31_sRNA.fa
echo -e "$seq" >> B31_sRNA.fa

done < B31_sRNA_coordinate.txt 


# formatting the RST1 genome as a functional database for BLAST
makeblastdb -in ./fasta_BB_RST1/BbuRST1.180205.fasta -out BbuRST1.180205 -parse_seqids -dbtype nucl


# blast sRNAs to RST1
blastn -query B31_sRNA.fa -db ~/blastdb/BbuRST1.180205 -task blastn -dust no -outfmt "7 qseqid sseqid sstrand sstart send qlen length pident ppos evalue bitscore" -max_target_seqs 2 > blastn_result.txt


# parsing 100% pident results
sed '/^#/d' blastn_result.txt > tmp
sed -n '/100\.00/p' tmp > blastn_result_100ident.txt
rm tmp

