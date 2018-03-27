%beta is the xishu of autoupgrade
function seq = filterOperation(seq,zeroMax,oneMax,threshold,isAuto,beta)
%start filtering
currentZeroNum = 0;
currentOneNum = 0;
m = length(seq);
originSeq = seq;
%init
seq(1,1) = binary(seq(1,1),threshold);
if seq(1,1)==0 
    currentZeroNum=1;
else
    currentOneNum=1;
end
%calculate
short1Len = 0;
for i = 2:m
    seq(i) = binary(seq(i),threshold);
    if seq(i)==0 
        currentZeroNum=currentZeroNum+1;
        %10
        if seq(i-1)==1 
            if currentOneNum < oneMax
                short1Len = currentOneNum;
            end
            currentOneNum=0;
            
        end
    else
        currentOneNum=currentOneNum+1;
        % 01 %threadhold change point
        if seq(i-1)==0           
            if currentZeroNum < zeroMax
                %%% this area we turn all the 0 -> 1,it means we need to
                %%% change the threshold;
                %todo    
                if isAuto == 1
                    a = beta*currentZeroNum;
                    if a>1
                        a =1;
                    end
                    threshold = (1-a)*threshold+a*mean(originSeq(i-currentZeroNum:i-1));
%                     disp(threshold);
                end
                seq(i-currentZeroNum:i-1)=1;      
                currentOneNum=currentZeroNum+currentOneNum;
            else
                %if there is short 1 case and later 0 num is long enough
                %,chagne all short 1 to 0
                if short1Len > 0
                    seq(i-currentZeroNum-short1Len:i-currentZeroNum-1) = 0;
                    short1Len = 0;
                end
            end
            currentZeroNum=0;
        end        
    end
end
%0 0 0 1 1 0 0 1 1 1