

function [geneID,readcount]=minionReadCount(mapq,mapping,delimiter)
% each row corresponds to each read
% mapq: MAPQ
% mapping: mapped geneIDs (multiple geneIDs; sep=';')
% delimiter: delimiter


mapping=cellstrtrimend(mapping,delimiter);
x=cellarraysplit(mapping,delimiter,'s');
nmax=1;
for i=1:length(x)
    nmax=max([length(x{i}),nmax]);
end

xmat=cell(length(x),nmax);
for i=1:length(x)
    y=x{i};
    xmat(i,1:length(y))=y';
end
xmat(iscellempty(xmat))={'NA'};

xunique=unique(xmat(:));
geneID=setdiff(xunique,{'NA'});
geneID=setdiff(xunique,{'N/A'});

disp(strcat('no. genes = ', num2str(length(geneID))));

readcount=nan(length(geneID),4);
xmat5=xmat(mapq>=5,:);
xmat10=xmat(mapq>=10,:);
xmat20=xmat(mapq>=20,:);
for i=1:length(geneID)    
    if mod(i,100)==0
        disp([i,length(geneID)]);
    end
    
    readcount(i,1)=length(strfindidx(geneID{i},xmat(:)));
    
    readcount(i,2)=length(strfindidx(geneID{i},xmat5(:)));
    readcount(i,3)=length(strfindidx(geneID{i},xmat10(:)));
    readcount(i,4)=length(strfindidx(geneID{i},xmat20(:)));    
end

header{1}='Index';
header{2}='Gene';
header{3}='MAPQ0';
header{4}='MAPQ5';
header{5}='MAPQ10';
header{6}='MAPQ20';
index=num2cell([1:length(geneID)]');
data=[index,geneID,num2cell(readcount)];
data=[header;data];
cell2txt('minionReadCount.txt',data,'\t');


    
    