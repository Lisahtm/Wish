%TIME
%ATTENA 1
%ATTENA 2
%ATTENA 3

%OUT:
%1*90



presec = 18*3600+30*60;
times = 0;
sample_rate = 20;
if 1 
fid = fopen('data/originWithTime.txt');
fout = fopen('data/origin1.txt','w');
%store the current average value
shortseq=cell(100,1);
shortIndex = 1;
src = [];
globalIndex = 1;
addTotal = 0;

while ~feof(fid)
    ttime = fgetl(fid);
    tt = regexp(ttime,':','split');
    tsec = str2num(char(tt(1)))*3600+str2num(char(tt(2)))*60+str2num(char(tt(3)));
    if tsec == presec
        times=times+1;
    else
        if tsec-presec ~=1
            fprintf('pre:%d,after:%d,after=%s\n',presec,tsec,ttime);
        end
        if times ~= 20 || tsec-presec ~=1
%             fprintf('short error:%s-%d\n',ttime,times);
            shortseq{shortIndex} = {globalIndex,(tsec-presec)*20-times};
            shortIndex = shortIndex+1;
            addTotal=addTotal+20-times;
        end
        times = 1;
        presec = tsec;
    end
    if times > 20
        fprintf('long erro:%s:%d\n',ttime,times);
    end
    %time
    tline1 = fgetl(fid);
   
    tline2 = fgetl(fid);

    tline3 = fgetl(fid);    
    src = [src;str2num(tline1),str2num(tline2),str2num(tline3)];
    globalIndex = globalIndex+1;
end
fprintf('start to deal with new matrix\n');
newsrc=[];
%deal with src 
tt = 1;
for iter = 1:shortIndex-1    
   tseq = shortseq{iter}{1};
   ttime = shortseq{iter}{2};
   tstart = tseq-5;
   tend = tseq+5;
   if tstart < 1 
        tstart=1;
   end
   if tend > length(src)
        tend = length(src);
   end
   r = mean(src(tstart:tend,:))+rand(1,90);
   fprintf('add:%d,repeatTime:%d\n',length(newsrc),ttime);
   newsrc=[newsrc;src(tt:tseq,:);repmat(r,ttime,1)];
   tt=tseq+1;
end
 newsrc=[newsrc;src(tt:length(src),:)];
 [m,n] = size(newsrc);
 format long g;
 for ii = 1:m
     for jj = 1:n
         fprintf(fout,'%.4f ',newsrc(ii,jj));
     end
     fprintf(fout,'\n');
 end

fclose(fid);
fclose(fout);
end

%about timestamp
%S START_TIME
%E END_TIME
% fid = fopen('data/recordFilebase2.txt');
% fout = fopen('data/timestamp2.txt','w');
% while ~feof(fid)
%     tline = fgetl(fid);
%     tline = tline(3:length(tline));
%     tt = regexp(tline,':','split');
%     rs = (str2num(char(tt(1)))*3600+str2num(char(tt(2)))*60+str2num(char(tt(3))))*sample_rate+floor(str2num(char(tt(4)))*sample_rate);
%     rs = rs-presec*sample_rate;
%     fprintf(fout,'%d',rs);
%     
%     tline = fgetl(fid);
%     tline = tline(3:length(tline));
%     tt = regexp(tline,':','split');
%     rs = (str2num(char(tt(1)))*3600+str2num(char(tt(2)))*60+str2num(char(tt(3))))*sample_rate+floor(str2num(char(tt(4)))*sample_rate);
%     rs = rs-presec*sample_rate;
%     
%     fprintf(fout,' %d\n',rs); 
% end
% fclose(fid);
% fclose(fout);