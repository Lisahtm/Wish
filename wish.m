%parameter csi is a matrix, timestamp is ground truth
%result:
%xx is time correlation result
%yy is frequency correlation result
%seq is the result of CSI length
function [seq,originSeq,xx,yy] = wish(csi,timestamp)
totalLen = size(csi,1);
threshold = 0.9;
attena_num = 90;
sample_rate = 10;
window_time = 2;
slide_time = 0.5;
zeroMax = 6;
oneMax = 6;
window_length = floor(sample_rate * window_time);
slide_length = floor(slide_time * sample_rate);
%
window_index = 1:slide_length:size(csi,1)-window_length+1;%把结尾去掉（最后一个数
seq = zeros(1,length(window_index));
xx = zeros(1,length(window_index));
yy = zeros(1,length(window_index));

seqIndex = 1;
% Feature
for ii = 1:length(window_index)
    corr_mtx = ones(1,window_length*(window_length-1)/2);
    corr_ctx = ones(1,attena_num*(attena_num-1)/2);
    corr_mindex = 1;
    corr_cindex = 1;
    csitmp = csi(ii:(ii+window_length-1),:);%算频率自相关使用
    ss = window_index(ii);%窗口起始位置
    %时间自相关
    for jj = 0:window_length-1
        for kk = jj+1:window_length-1
            temp_corr = corrcoef(csi(ss+jj,:), csi(ss+kk,:));
            corr_mtx(corr_mindex) = temp_corr(1,2);
            corr_mindex = corr_mindex+1;
        end
    end
    %频率自相关
    for jj = 1:2:attena_num
        for kk = jj+1:attena_num
            temp_corr = corrcoef(csitmp(:,jj), csitmp(:,kk));
            corr_ctx(corr_cindex) = temp_corr(1,2);
            corr_cindex = corr_cindex+1;
        end
    end    
    %公式计算
%     t*exp(-0.1*f)
    t = median(corr_mtx);
    f = median(corr_ctx);
    xx(1,seqIndex) = t;
    yy(1,seqIndex) = f;
    seq(1,seqIndex) = t*exp(-0.1*f);
    seqIndex = seqIndex+1;
end

% plot(seq,'r--');
% hold on;
%originSeq will not be changed, seq will be changed to the same size of original
%csi data
[originSeq,seq,ground_truth] = binaryOperation(seq,timestamp,slide_length,totalLen,threshold);
seq = filterOperation(seq,zeroMax,oneMax);
res = mdtp(seq,ground_truth);
% plot(originSeq,'b-');
% hold on;
disp('accuracy result:');
disp(res);
% plot(ground_truth);
% hold on;
% plot(seq,'k-');
end
