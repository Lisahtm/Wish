function res = mdtp(datar,datag,threshold)
% datar is binary sequence of csi data
%datag is binary sequence of ground truth
len = length(datar);
format long g;
%MDTP,MDTN
num0 = 0;
num0Total = 0;
num1 = 0;
num1Total = 0;
fout = fopen('data/log.txt','a+');
foutThres = fopen('data/thres.txt','a+');
%1£¬0 overlap rate
for ii = 1:len
    if(datag(1,ii)==1)
        if datar(1,ii)==1
            num1=num1+1;
        end
        num1Total = num1Total + 1;
    else
        if datar(1,ii) == 0
            num0 = num0+1;
        end
        num0Total = num0Total + 1;
    end
end

mdtp = num1/num1Total;
mdtn = num0/num0Total;
%ME-TP
eventTotal = 0;
detectTotal = 0;
eventGDetail = cell(1,400);
eventRDetail = cell(1,400);
%tag the start point and end point of ground truth
for ii = 1:length(datag)
    if ii>1 && datag(1,ii)==1 && datag(1,ii-1)==0
        eventTotal = eventTotal+1;
        eventGDetail{eventTotal}{1} = ii;
    end
    if ii>1 && datag(1,ii)==0 && datag(1,ii-1)==1
        eventGDetail{eventTotal}{2} = ii-1;
    end    
end
for ii = 1:length(datar)
    if  ii>1 && datar(1,ii)==1 && datar(1,ii-1)==0
        detectTotal = detectTotal+1;
        eventRDetail{detectTotal}{1} = ii;
    end
    if  ii>1 && datar(1,ii)==0 && datar(1,ii-1)==1
        if detectTotal > 0
         eventRDetail{detectTotal}{2} = ii-1;
        end
    end        
end

if(detectTotal>0 && length(eventRDetail{detectTotal})<2)
    eventRDetail{detectTotal}{2} = length(datar);
end

if(length(eventGDetail{eventTotal})<2)
    eventGDetail{eventTotal}{2} = length(datag);
end
    
fprintf('threshold:%f\n',threshold);
fprintf(fout,'threshold:%f\n',threshold);
fprintf(foutThres,'%f\n',threshold);
falseAlarm = 0;
detectedEvent = 0;
mbe = 0;
mee = 0;
isdetected = zeros(1,eventTotal);
for ii = 1:detectTotal
    for jj = 1:eventTotal
        if abs(eventRDetail{ii}{1}-eventGDetail{jj}{1})<60 
           if abs(eventRDetail{ii}{2}-eventGDetail{jj}{2})<60
               if isdetected(1,jj)==0
                detectedEvent = detectedEvent+1;
                isdetected(1,jj) = 1;
                mbe = mbe + (eventRDetail{ii}{1}-eventGDetail{jj}{1});
                mee = mee + (eventRDetail{ii}{2}-eventGDetail{jj}{2});
                 fprintf(fout,'[success]:[%d][%d] g-%d with r-%d\n',eventRDetail{ii}{1}-eventGDetail{jj}{1},eventRDetail{ii}{2}-eventGDetail{jj}{2},jj,ii);
                break;
               end
           else
               fprintf(fout,'[error]:end error[%d][%d]:g-%d with r-%d\n',eventRDetail{ii}{1}-eventGDetail{jj}{1},eventRDetail{ii}{2}-eventGDetail{jj}{2},jj,ii);
           end
        else
            if abs(eventRDetail{ii}{2}-eventGDetail{jj}{2})<100
                fprintf(fout,'[error]:start error[%d][%d] g-%d with r-%d\n',eventRDetail{ii}{1}-eventGDetail{jj}{1},eventRDetail{ii}{1}-eventGDetail{jj}{1},jj,ii);
            end
            if  eventGDetail{jj}{1} - eventRDetail{ii}{1} >100
                falseAlarm = falseAlarm+1;
                fprintf(fout,'[error]:false alarm [%d][%d] g-%d with r-%d\n',eventRDetail{ii}{1}-eventGDetail{jj}{1},eventRDetail{ii}{2}-eventGDetail{jj}{2},jj,ii);
                break;
            end
        end
    end
end
mbe = mbe/detectedEvent;
mee = mee/detectedEvent;
metp = detectedEvent/eventTotal;
fprintf('\nmdtp:%.2f%%,mdtn:%.2f%%,rate:%.2f%%\n',mdtp*100,mdtn*100,detectedEvent/eventTotal*100);
fprintf('detectedEvent:%d,eventTotal:%d,detectTotal:%d,rate:%.2f\n',detectedEvent,eventTotal,detectTotal,detectedEvent/eventTotal);
fprintf('false alarm:%d,metp:%.2f%%,mbe:%.2fs,mee:%.2fs\n',falseAlarm,metp*100,mbe/20,mee/20);
res=[metp,falseAlarm,mdtp,mdtn,mbe,mee];

fprintf(foutThres,'%.2f %d %.2f %.2f %.2f %.2f\n',metp,falseAlarm,mdtp,mdtn,mbe,mee);

fclose(fout);
fclose(foutThres);
