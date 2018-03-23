%parameter csi is a matrix, timestamp is ground truth
%result:
%xx is time correlation result
%yy is frequency correlation result
%seq is the result of CSI length
function [seq,originSeq,originFilter,ground_truth,xx,yy,res] = wish(csi,timestamp,threshold,isAuto)
totalLen = size(csi,1);
attena_num = 90;
sample_rate = 20;
window_time = 1;
slide_time = 0.1;
zeroMax = 11;
oneMax = 11;
window_length = floor(sample_rate * window_time);
slide_length = floor(slide_time * sample_rate);
%
window_index = 1:slide_length:size(csi,1)-window_length+1;
seq = zeros(1,length(window_index));
xx = zeros(1,length(window_index));
yy = zeros(1,length(window_index));

seqIndex = 1;
% Feature
disp('start to calculate correlation');
for ii = 1:length(window_index)
    corr_mtx = zeros(1,window_length*(window_length-1)/2);
%     corr_ctx = zeros(1,attena_num*(attena_num-1)/2);
    corr_ctx = zeros(1,attena_num*(attena_num+1)/6);
    corr_mindex = 1;
    corr_cindex = 1;
    csitmp = csi(ii:(ii+window_length-1),:);
    ss = window_index(ii);
    for jj = 0:window_length-1
        for kk = jj+1:window_length-1
            temp_corr = corrcoef(csi(ss+jj,:), csi(ss+kk,:));
            corr_mtx(corr_mindex) = abs(temp_corr(1,2));
            corr_mindex = corr_mindex+1;
        end
    end
    for jj = 1:3:attena_num
        for kk = jj+1:attena_num
            temp_corr = corrcoef(csitmp(:,jj), csitmp(:,kk));
            corr_ctx(corr_cindex) = abs(temp_corr(1,2));
            corr_cindex = corr_cindex+1;
        end
    end    
    t = median(corr_mtx);
    f = median(corr_ctx);
    if isnan(f)
        f = 0.5;
    end
    xx(1,seqIndex) = t;
    yy(1,seqIndex) = f;
    seq(1,seqIndex) = t*exp(-0.1*f);
    seqIndex = seqIndex+1;
    if mod(ii,50)==0
        fprintf('.');
    end
end
fprintf('start to deal with data');
% plot(seq,'r--');
% hold on;
%originSeq will not be changed, seq will be changed to the same size of original
%csi data
originSeq = seq;
[ttt,seq,ground_truth] = binaryOperation(seq,timestamp,slide_length,totalLen,threshold);
originFilter = seq;
seq = filterOperation(seq,zeroMax,oneMax,threshold,isAuto,0.002);
res = mdtp(seq,ground_truth,threshold);
% plot(originSeq,'b-');
% hold on;
% disp('accuracy result:');
% disp(res);
% plot(ground_truth);
% hold on;
% plot(seq,'k-');
end
