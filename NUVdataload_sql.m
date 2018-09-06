
load('nuv.mat');

sz=size(name,2);
lastdate=time(end);
lastdate=datenum(lastdate,'dd/mm/yyyy');
endpt=size(cl,1);
%% Load data from SQL
conn=databaseconnection2serverny;

%% create issuereporting
issuereport=struct;
k=1;

%% main
for i=294:sz
    dat=getstockmysqldata(conn,name{i});
    if size(dat,1)~=1
        if ~strcmp(name{1},'AAPL')
            error('CHECK NUV.mat, the first stock has to be AAPL')
        end
        dat_time=dat(:,1); %date
        datt=datenum(dat_time,'yyyy-mm-dd');
        dat_price=cell2mat(dat(:,2:end)); %Open Close High Low
        [id,ic]=ismember(lastdate,datt);



        if id==1
            ix=ic+1:size(dat_time,1);
            if i==1
                new_date=cellfun(@(x) datestr(datenum(x,'yyyy-mm-dd'),'dd/mm/yyyy'),dat_time(ix),'UniformOutput', false);
                time=vertcat(time,new_date);
                date_len=length(ix); %used to check the data consistent for the remaining stocks
                new_op=nan(size(ix,2),size(cl,2));
                new_cl=nan(size(ix,2),size(cl,2));
                new_hi=nan(size(ix,2),size(cl,2));
                new_lo=nan(size(ix,2),size(cl,2));
            end

            if length(ix)==date_len
                new_op(:,i)=dat_price(ix,1);
                new_cl(:,i)=dat_price(ix,2);
                new_hi(:,i)=dat_price(ix,3);
                new_lo(:,i)=dat_price(ix,4);
            else
                msg{k}=strcat('DateLengthNotMatch_',name{i});
                ix(k)=i;
                k=k+1;
            end
        else    
            msg{k}=strcat('DateNotFound_',name{i});
            ix(k)=i; 
            k=k+1;
        end
    else
            msg{k}=strcat('NoDataInSQL_',name{i});
            ix(k)=i;
            k=k+1;
    end
    if ismember(i,[100:100:size(op,2)])
        save temp.mat new_cl new_op new_lo new_hi name time
    end
    i
end

%% aggregate data
issuereport.msg=msg;
issuereport.ix=ix;

op=vertcat(op,new_op);
cl=vertcat(cl,new_cl);
hi=vertcat(hi,new_hi);
lo=vertcat(lo,new_lo);

save NUV.mat cl op lo hi mi name time

msgbox('Data update completed')