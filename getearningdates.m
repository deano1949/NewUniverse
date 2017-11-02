function [time, logic]=getearningdates()

%% Description: Get earning dates 
erndat=readtable('NewUniverse.xlsm','Sheet','Backuplist and earning dates','Range','D2:ACQ74');
ernname=fieldnames(erndat); %stock names in earning table

load NUV.mat
earndateloc=zeros(size(cl));
for i=503:length(name)
   stckname=name{i};
   try
    earndate=erndat.(stckname); %earning date
    earndate=datenum(cell2mat(earndate),'dd/mm/yyyy');
    earndate_plus1=busdate(earndate,1);
    [ix,id]=ismember(datenum(time,'dd/mm/yyyy'),[earndate;earndate_plus1]);
   catch
       ix=zeros(size(time)); %mark earning dates on time table
   end
   earndateloc(:,i)=ix;
end

save('NUV.mat','earndateloc','-append');