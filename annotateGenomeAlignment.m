
function annotation=annotateGenomeAlignment(chr,pos,rl,gff)

gene_start=cell2num(gff(:,4));
gene_end=cell2num(gff(:,5));

n=length(chr);
annotation=cell(n,2);
no=nan(n,1);
for i=1:n
    if mod(i,1000)==0
        disp([i,n]);
    end
    
    ind_seqname=strmatch(chr{i},gff(:,1),'exact');
    ind_5=find(pos(i)<=gene_end);
    ind_3=find(pos(i)+rl(i)-1>=gene_start);
    ind=intersect(ind_seqname,intersect(ind_5,ind_3));
    no(i)=length(ind);
    if ~isempty(ind)
%         annotation(i,:)=gff(ind(1),:);

annot=unique(gff(ind,9));
% annot2=unique(gff(ind,11));

str='';
% str2='';
% for j=1:length(ind)
%     str=strcat(str,gff{ind(j),9},';');
%     str2=strcat(str2,gff{ind(j),11},';');
% end

for j=1:length(annot)
    str=strcat(str,annot{j},';');
%     str2=strcat(str2,annot2{j},';');
end

annotation(i,1)={str};
% annotation(i,2)={str2};

    end

end