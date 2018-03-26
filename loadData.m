% src=importdata('origin.txt');
src1 = importdata('data/origin1.txt');
timestamp1=importdata('data/timestamp1.txt');

src2 = importdata('data/origin2.txt');
timestamp2=importdata('data/timestamp2.txt');
disp('load data successfully');
flog = fopen('data/thres.txt','a+');
% snr = importdata('0_snr_data.txt');

%smaller
[m,n] = size(src1);
csi = zeros(m,90);

refreshNum = 30;
% [csi, timestamp] = csi_get_all('Static-1-R1.dat');
% [m, n] = size(csi);

ind = [-28:2:-2,-1,1:2:27,28];
% for i=1:m
%     col = 1;
%     for k = 0:2:4
%         for j = 1:refreshNum
%             csi(i,col) = src(i,k*refreshNum+j) + 1j * src(i,(k+1)*refreshNum+j);
% %             csi(i,col) = src(i,k*refreshNum+j)*src(i,k*refreshNum+j) + src(i,(k+1)*refreshNum+j) * src(i,(k+1)*refreshNum+j);
% %             csi(i,col) = sqrt(csi(i,col));
%             col = col+1;
%         end
%     end 
%     for k = 1:3
%         temp_phase = unwrap(angle(csi(i,(k-1)*30+(1:30))));
%         slope = (temp_phase(end) - temp_phase(1)) / (ind(end)-ind(1));
%         intercept = mean(temp_phase);
%         temp_phase = temp_phase - slope * ind - intercept;
%         csi(i,(k-1)*30+(1:30)) = abs(csi(i,(k-1)*30+(1:30))) .* exp(1j * temp_phase);
%     end
% end

[seq,originSeq,originFilter,ground_truth,mm,yy90,res] = wish(src1,timestamp1,0.8700,0);

if 0 
%calculate threshold tsuyo
interval = 1;
range = 0:interval:0;
thresLine1 = zeros(1,length(range));
thresOriginAuto1 = zeros(length(range),7);
index = 1;
%%%%%%%%%
sample_rate = 20;
slide_time = 0.1;
window_time = 1;
zeroMax = 11;
oneMax = 11;
window_length = floor(sample_rate * window_time);
slide_length = floor(slide_time * sample_rate);
seq = xx2.*exp(-0.1*yy2);
for ii=range
    [ttt,seq1,ground_truth] = binaryOperation(seq,timestamp2,slide_length,size(src2,1),0.87);
    seq1 = filterOperation(seq1,zeroMax,oneMax,0.87,1,ii);
    res = mdtp(seq1,ground_truth,ii);
    thresOriginAuto1(index,:) = [ii,res];
    index=index+1;
end


try
    fprintf(flog,'auto,data2\n');   
    wish(src2,timestamp2,0.8700,1);
catch ErrorInfo
    disp(ErrorInfo);  
    disp(ErrorInfo.identifier);  
    disp(ErrorInfo.message);  
    disp(ErrorInfo.stack);  
    disp(ErrorInfo.cause);  
end

%medfit
for ii = 1:7
    try
        fprintf('[start medfit1]seq %d',ii);  
        fprintf(flog,'medfit1,data2,windowSize=%ii\n',ii);   
        srcT = medfilt1(src2,ii);
        wish(srcT,timestamp2,0.8700,0);
    catch ErrorInfo
        disp(ErrorInfo);  
        disp(ErrorInfo.identifier);  
        disp(ErrorInfo.message);  
        disp(ErrorInfo.stack);  
        disp(ErrorInfo.cause);  
    end
end

%data2 average
for ii = 1:20
    try
        fprintf('[start average]seq %d',ii);
        fprintf(flog,'filter average,data2,windowSize=%d\n',ii);
        windowSize = ii;
        a=ii;
        y1=filter(ones(1,a/2+1)/windowSize,1,src2);
        y2=filter(ones(1,a/2+1)/windowSize,1,fliplr(src2));
        srcT=y1+fliplr(y2)-(1/a)*src2;    
        wish(srcT,timestamp2,0.8700,0);
        disp('[end]seq %d',ii);
    catch ErrorInfo
        disp(ErrorInfo);  
        disp(ErrorInfo.identifier);  
        disp(ErrorInfo.message);  
        disp(ErrorInfo.stack);  
        disp(ErrorInfo.cause);  
    end
end


%*************************************************%

% if 0


%data2
try
    disp('[start]seq 3');
     fprintf(flog,'filter average,data2,windowSize=5\n');
    windowSize = 6;
    a=5;
    y1=filter(ones(1,a/2+1)/windowSize,1,srcS2);
    y2=filter(ones(1,a/2+1)/windowSize,1,fliplr(srcS2));
    src2=y1+fliplr(y2)-(1/a)*srcS2;    
    [seq3,originSeq3,originFilter3,ground_truth3,xx3,yy3,res3] = wish(src2,timestampS2,0.8700,0);
    disp('[end]seq 3');
catch ErrorInfo
    disp(ErrorInfo);  
    disp(ErrorInfo.identifier);  
    disp(ErrorInfo.message);  
    disp(ErrorInfo.stack);  
    disp(ErrorInfo.cause);  
end

%auto data2
try
    disp('[start]seq 4');
     fprintf(flog,'origin,data2,auto filter\n');
    [seq4,originSeq4,originFilter4,ground_truth4,xx4,yy4,res4] = wish(srcS2,timestampS2,0.8700,1); 
    disp('[end]seq 4');
catch ErrorInfo
    disp(ErrorInfo);  
    disp(ErrorInfo.identifier);  
    disp(ErrorInfo.message);  
    disp(ErrorInfo.stack);  
    disp(ErrorInfo.cause);  
end
%auto data1
try
    disp('[start]seq 5');
     fprintf(flog,'origin,data1,auto filter\n');
    [seq5,originSeq5,originFilter5,ground_truth5,xx5,yy5,res5] = wish(src,timestamp,0.8700,1); 
    disp('[end]seq 5');
catch ErrorInfo
    disp(ErrorInfo);  
    disp(ErrorInfo.identifier);  
    disp(ErrorInfo.message);  
    disp(ErrorInfo.stack);  
    disp(ErrorInfo.cause);  
end

fclose(flog);

%calculate threshold tsuyo
interval = 0.001;
range = 0.8:interval:0.95;
thresLine1 = zeros(1,length(range));
thresOrigin1 = zeros(length(range),7);
index = 1;
%%%%%%%%%
sample_rate = 20;
slide_time = 0.1;
window_time = 1;
zeroMax = 11;
oneMax = 11;
window_length = floor(sample_rate * window_time);
slide_length = floor(slide_time * sample_rate);
seq = xx5.*exp(-0.1*yy5);
[ttt,seq,ground_truth] = binaryOperation(seq,timestamp1,slide_length,size(src2,1),0.87);
%%%%%%%%%
for ii = range
%     [seq,originSeq,originFilter,ground_truth,xx,yy,res] = wish(src,timestamp,ii); 
    
    seq1 = filterOperation(seq,zeroMax,oneMax,ii,0);
    res = mdtp(seq1,ground_truth,ii);
    
    thresOrigin1(index,:) = [ii,res];
    thresLine1(1,index) = res(1)*2+res(2)*2+res(3) +res(4)-res(5)*0.5-res(6)*0.5;
    index = index+1;
end


csi = abs(csi);
% [wishResult,originSeq,tt,ff]= wish(csi,timestamp);


window_time = 2;
slide_time = 0.5;
window_length = floor(sample_rate * window_time);
slide_length = floor(slide_time * sample_rate);
%
window_index = 1:slide_length:size(csi,1)-window_length+1;%把结尾去掉（�?���?���?ground_truth = zeros(1, length(window_index));

% Ground truth
jj = 1;
flag = 0;
for ii = 1:length(window_index)
    if (window_index(ii) >= timestamp(jj,1) && window_index(ii) < timestamp(jj,2)) || ... %窗口的开始在运动的时间窗之内
        (window_index(ii) + window_length - 1 >= timestamp(jj,1) && window_index(ii) + window_length - 1 <= timestamp(jj,2))
        %上面，窗口的结尾在运动时间窗之内
        ground_truth(ii) = 1;
        flag = 0;
    elseif window_index(ii) >= timestamp(jj,2)
        while(jj <= length(timestamp)&&window_index(ii) >= timestamp(jj,2))
             jj = jj + 1;
        end
        if jj > length(timestamp)
               break;
        end
    end    
end

% Feature
nfeature = 5;
feature = zeros(nfeature,length(window_index));
for ii = 1:length(window_index)
    corr_mtx = ones(window_length, window_length);
    ss = window_index(ii);%窗口起始位置
    for jj = 0:window_length-1
        for kk = jj+1:window_length-1
            temp_corr = corrcoef(csi(ss+jj,:), csi(ss+kk,:));
            corr_mtx(jj+1,kk+1) = temp_corr(1,2);
            corr_mtx(kk+1,jj+1) = temp_corr(1,2);
        end
    end
    d = eig(corr_mtx);
    d = sort(d, 'descend');
    feature(1:nfeature,ii) = d(1:nfeature);
end
feature(1,:) = feature(1,:) / window_length;
end
% 
% svmtrain
% svmclassify
% 
% plot(abs(feature(1,:)),'r-')% 
% hold on;
% plot(ground_truth);
% hold on;
% plot(tt.*exp(-0.1*ff));
% hold on;
% plot(originSeq,'k-');
% hold on;
% plot(tt,'y--');
% hold on;
% plot(ff,'g--');
% tt.*exp(-0.1*ff)