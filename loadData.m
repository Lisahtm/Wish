% src=importdata('origin.txt');
src = importdata('data/origin1.txt');
timestamp=importdata('data/timestamp1.txt');

srcS2 = importdata('data/origin2.txt');
timestampS2=importdata('data/timestamp2.txt');
disp('load data successfully');
% snr = importdata('0_snr_data.txt');

%smaller
[m,n] = size(src);
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

% [seq,originSeq,originFilter,ground_truth,xx,yy,res] = wish(src,timestamp,0.9559);
try
    [seq0,originSeq0,originFilter0,ground_truth0,xx0,yy0,res0] = wish(src,timestamp,0.8700); 
catch ErrorInfo
    disp(ErrorInfo);  
    disp(ErrorInfo.identifier);  
    disp(ErrorInfo.message);  
    disp(ErrorInfo.stack);  
    disp(ErrorInfo.cause);  
end
if 0

%filter average
try
    src1 = medfilt2(src);
    [seq1,originSeq1,originFilter1,ground_truth1,xx1,yy1,res1] = wish(src1,timestamp,0.8700); 
catch ErrorInfo
    disp(ErrorInfo);  
    disp(ErrorInfo.identifier);  
    disp(ErrorInfo.message);  
    disp(ErrorInfo.stack);  
    disp(ErrorInfo.cause);  
end
%filter average
try
    windowSize = 10;
    a=10;
    y1=filter(ones(1,a/2+1)/windowSize,1,src);
    y2=filter(ones(1,a/2+1)/windowSize,1,fliplr(src));
    src2=y1+fliplr(y2)-(1/a)*src;
    [seq2,originSeq2,originFilter2,ground_truth2,xx2,yy2,res2] = wish(src2,timestamp,0.8700); 
catch ErrorInfo
    disp(ErrorInfo);  
    disp(ErrorInfo.identifier);  
    disp(ErrorInfo.message);  
    disp(ErrorInfo.stack);  
    disp(ErrorInfo.cause);  
end

try
    [seq3,originSeq3,originFilter3,ground_truth3,xx3,yy3,res3] = wish(srcS2,timestampS2,0.8700); 
catch ErrorInfo
    disp(ErrorInfo);  
    disp(ErrorInfo.identifier);  
    disp(ErrorInfo.message);  
    disp(ErrorInfo.stack);  
    disp(ErrorInfo.cause);  
end

interval = 0.001;
range = 0.84:interval:0.93;
thresLine = zeros(1,length(range));
thresOrigin = zeros(length(range),7);
index = 1;
%%%%%%%%%
sample_rate = 20;
slide_time = 0.1;
window_time = 1;
zeroMax = 11;
oneMax = 11;
window_length = floor(sample_rate * window_time);
slide_length = floor(slide_time * sample_rate);
seq = xx.*exp(-0.1*yy);
[ttt,seq,ground_truth] = binaryOperation(seq,timestamp,slide_length,size(src,1),ii);
%%%%%%%%%
for ii = range
    [seq,originSeq,originFilter,ground_truth,xx,yy,res] = wish(src,timestamp,ii); 
    
%     seq1 = filterOperation(seq,zeroMax,oneMax,ii);
%     res = mdtp(seq1,ground_truth,ii);
    
    thresOrigin(index,:) = [ii,res];
    thresLine(1,index) = res(1)*2+res(2)*2+res(3) +res(4)-res(5)*0.5-res(6)*0.5;
    index = index+1;
end

csi = abs(csi);
% [wishResult,originSeq,tt,ff]= wish(csi,timestamp);
if 0

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
end
plot(abs(feature(1,:)),'r-')% 
hold on;
plot(ground_truth);
hold on;
plot(tt.*exp(-0.1*ff));
hold on;
plot(originSeq,'k-');
hold on;
plot(tt,'y--');
hold on;
plot(ff,'g--');
% tt.*exp(-0.1*ff)