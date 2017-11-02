%% Generate the data.mat with open price @0945 
% replace open price by 09:45 price
NUVpath='C:\Users\Langyu\Desktop\Dropbox\GU\1.Investment\Data\NewUniverse\';
Intradaypath='C:\Users\Langyu\Desktop\Dropbox\GU\1.Investment\Data\EODData\MatlabFormat\15mins\';

load(strcat(NUVpath, 'NUV.mat'));
load(strcat(Intradaypath, 'NUV945.mat'));

intratime=NUV945.datestamp;
[~,pos]=ismember(datenum(intratime{1},'dd-mm-yyyy'),datenum(time,'dd/mm/yyyy'));
enddate=pos+length(intratime)-1;

if enddate>size(cl,1)
    dategap=enddate-size(cl,1);
    O=NUV945.O; O=O(1:end-dategap,:);
    op=vertcat(op(1:pos-1,:),O); op(op==0)=NaN;
    enddate=enddate-dategap;
else
    op=vertcat(op(1:pos-1,:),NUV945.O); op(op==0)=NaN;
end

lo=lo(1:enddate,:);
cl=cl(1:enddate,:);
hi=hi(1:enddate,:);
time=time(1:enddate,:);
