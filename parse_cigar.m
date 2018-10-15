
function [s,c, scoremat]=parse_cigar(cigarstr)
% cigarstr:
% '2S22M1D30M1D5M1D2M1D2M1D4M1I2M1D6M1D2M1D6M3D15M1I23M1I12M1D7M4I4M1D6M1D6M2I27M3I5M1I7M1D13M1I17M2I4M1I1M1I21M1D22M1D3M1I32M4I35M3D8M1D23M3I20M1D20M1D20M1I9M7I1M1I2M2I5M1I4M3I15M1D2M1I4M1D23M3I1M9I15M1I8M6I1M4I18M1D21M1D10M3I18M3I8M3I16M1D8M2I6M1I8M1D8M5I7M3I15M1D3M3I4M2I2M2I2M1I11M1D13M2D2M1D26M3I5M1D11M4I6M2I7M1I4M1D15M3I1M2I3M1I2M1I8M3D18M1D7M1D3M1D12M4I21M3I24M2I9M2I4M4I27M5I23M1D6M1D14M1I16M1D2M1D4M2I10M2I22M1D5M2I8M24I17M1D6M1I6M2D17M2D13M1D17M1D15M2D49M1I3M1I25M1D31M1I12M2D4M2D6M3D4M1D7M1D15M1D4M1D5M3D15M1D61M1I50M5D15M2D13M1D11M1D26M2D16M3D6M2D1M4D13M1I31M2I26M1D7M1I57M2D7M1I5M1D31M2D5M2D9M2D17M1D9M3D14M1I15M53S'
% M: match
% D: deletion
% I: insertion
% S: soft clipping
% H: hard clipping
% % N: gap
% % P: padding
% % =: sequence match
% % X: sequence mismatch


n=nan(length(cigarstr),1);
for i=1:length(cigarstr)
    tmp=str2num(cigarstr(i));
    tf(i,1)=~isempty(tmp);
    if tf(i)==1
        n(i)=tmp;
    end    
end


ind=find(tf==0);
s=cell(sum(tf==0),1);
c=nan(length(s),1);
for i=1:length(s)
    
    if i==1
        idx=[1,ind(1)-1];
    else
        idx=[ind(i-1)+1,ind(i)-1];
    end
    
    if idx(1)==idx(2)
        a=str2num(cigarstr(idx(1)));
        c(i)=a;
    else
        a=str2num(cigarstr(idx));
        c(i)=a;
    end
    
    s{i}=cigarstr(ind(i));
    
end

scoremat{1,1}='M';
scoremat{2,1}='D';
scoremat{3,1}='I';
scoremat{4,1}='S';
scoremat{5,1}='H';

scoremat{1,2}=sum(c(strmatch('M',s,'exact')));
scoremat{2,2}=sum(c(strmatch('D',s,'exact')));
scoremat{3,2}=sum(c(strmatch('I',s,'exact')));
scoremat{4,2}=sum(c(strmatch('S',s,'exact')));
scoremat{5,2}=sum(c(strmatch('H',s,'exact')));



