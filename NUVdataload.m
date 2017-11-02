h=waitbar(0,'Loading up data. Please wait.....'); %Progress bar

[~,~,dat]=xlsread('Universeclose.csv');
name=dat(1,2:end);
namecount=size(name,2);
close=NUVimportfile('Universeclose.csv',namecount,name);
waitbar(0.25);
open=NUVimportfile('Universeopen.csv',namecount,name);
waitbar(0.5);
low=NUVimportfile('Universelow.csv',namecount,name);
waitbar(0.75);
high=NUVimportfile('Universehigh.csv',namecount,name);

time=close.Date;
time=exceltomatdate(time,'dd/mm/yyyy');
cl=double(table2dataset(close(:,2:end)));
op=double(table2dataset(open(:,2:end)));
lo=double(table2dataset(low(:,2:end)));
hi=double(table2dataset(high(:,2:end)));

cl(cl==-5000)=NaN;
op(op==-5000)=NaN;
lo(lo==-5000)=NaN;
hi(hi==-5000)=NaN;
% Market Index
SPY=xlsread('SPY_MarketIndex.csv');
mi.cl=SPY(:,2);
mi.op=SPY(:,3);

waitbar(1,'Data are saved');
save NUV.mat cl op lo hi mi name time

msgbox('Data update completed')