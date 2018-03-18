try
    b(1,1);
    a = cell(1,3);
    a{2}{1}=5;
    length(a{2})
    if isempty(a{2}{2}) 
        disp('aa') 
    else disp('b') 
    end
end
disp('sa');