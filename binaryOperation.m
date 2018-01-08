%datar is windowIndex list result of experimental result 1,6,11
%datag is Index list result
%totalLen is totalLength of the csi data
function [seq,listr,listg] = binaryOperation(datar,datag,windowSize,totalLen,threshold)

%change the timestamp of ground truth into zero and one sequence.
listr = zeros(1,totalLen);
listg = zeros(1,totalLen);
seq = zeros(1,size(datar,2));
jj = 1;
for ii = 1:windowSize:totalLen
    if datar(1,jj) < threshold
        listr(1,ii:ii+windowSize-1) = 1;
        seq(jj) = 1;
    end
    jj=jj+1;
    if jj > size(datar,2)
        break;
    end
end
len = size(datag,1);
for i=1:len
    listg(datag(i,1):datag(i,2))=1;
end
%1,6,11,16

