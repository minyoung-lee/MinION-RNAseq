
close all;
clear;clc
addpath('D:\matlab_myfunction');

cd D:\Minion_Borellia_RST1_2018_07_11\result_bwa_RST1

%% compute alignment length (reference span) from SAM CIGAR string
cigar=readtext('cigar.txt','\t');
x=nan(length(cigar),5);
for i=1:length(cigar)
    
    if mod(i,100)==0
        disp([i,length(cigar)]);
    end
    
    cigarstr=cigar{i};
    [~,~, scoremat]=parse_cigar(cigarstr);
    x(i,:)=cell2num(scoremat(:,2))';
    
end
dlmwrite('cigar_parsed.txt',x,'\t');


%% annotate alignment
chr=readtext('RNAME.txt','\t');
pos=load('POS.txt');
rl=load('ReferenceSpan.txt');
gff=readtext('D:\Minion_Borellia_RST1\BbuRST1\annotation_RST1_gene.txt','\t');

annot=annotateGenomeAlignment(chr,pos,rl,gff);
cell2txt('read2gff.txt',annot(:,1),'\t');


%% read count
mapq=load('MAPQ.txt');
mapping=readtext('read2gff.txt','\t');
delimiter=';';

tf=iscellempty(mapping);
mapping(tf)={';'};

[geneID,readcount]=minionReadCount(mapq,mapping,delimiter);