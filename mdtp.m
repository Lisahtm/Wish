function res = mdtp(datar,datag)
% datar is binary sequence of csi data
%datag is binary sequence of ground truth
len = length(datar);

rightNum = 0;
rightTotal = 0;
for ii = 1:len
    if(datag(1,ii)==1)
        if datar(1,ii)==datag(1,ii)
            rightNum=rightNum+1;
        end
        rightTotal=rightTotal+1;
    end
end

res = rightNum/rightTotal;
