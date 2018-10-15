#! /bin/bash

# Create Reference Index
~/bwa/bwa index -a bwtsw BbuRST2.180215.fasta


# convert gbk to gff
bp_genbank2gff3.pl BbuRST2.180215.gbk


# make gff without fasta sequences
a=`grep -n "FASTA" BbuRST2.180215.gbk.gff | cut -d":" -f1`
a=`expr $a - 1`
sed -n '1,'"$a"'p' BbuRST2.180215.gbk.gff > BbuRST2.180215.gbk_nofasta.gff


# modify gff RNAME to match with fasta file
grep ">" BbuRST2.180215.fasta | cut -d" " -f1 | sort | sed 's/>//g' > RNAME_fasta
cut -f1 BbuRST2.180215.gbk_nofasta.gff | sort | uniq > RNAME_gff
paste RNAME_gff RNAME_fasta

>BbuRST2.180215.gbk_nofasta_RNAMEchanged.gff
while IFS= read -r lineA && IFS= read -r lineB <&3; do
 
echo "$lineA"; echo "$lineB"

grep $lineA BbuRST2.180215.gbk_nofasta.gff > tmp 
sed -i "s/$lineA/$lineB/g" tmp
cat tmp >> BbuRST2.180215.gbk_nofasta_RNAMEchanged.gff
rm tmp

done <RNAME_gff 3<RNAME_fasta
