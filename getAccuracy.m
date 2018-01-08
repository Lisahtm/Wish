function res = getAccuracy(oldSeq,newSeq)
%compare the accuracy
res = 0;
len = length(oldSeq);
num = 0;
for i=1:len
    if oldSeq(i) == newSeq(i)
        num = num+1;
    end
end
res = num/len;