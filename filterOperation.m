function seq = filterOperation(seq,zeroMax,oneMax)
%start filtering
currentZeroNum = 0;
currentOneNum = 0;
m = length(seq);
%init
if seq(1,1)==0 
    currentZeroNum=1;
else
    currentOneNum=1;
end
%calculate
for i = 2:m
    if seq(i)==0 
        currentZeroNum=currentZeroNum+1;
        if seq(i-1)==1 && currentOneNum < oneMax
            seq(i-currentOneNum:i-1)=0;   
            currentZeroNum=currentZeroNum+currentOneNum;
            currentOneNum=0;
        end
    else
        currentOneNum=currentOneNum+1;
        if seq(i-1)==0 && currentZeroNum < zeroMax
            seq(i-currentZeroNum:i-1)=1;      
            currentOneNum=currentZeroNum+currentOneNum;
            currentZeroNum=0;
        end        
    end
end
%0 0 0 1 1 0 0 1 1 1