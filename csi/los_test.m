function los_test
    file_list = {'./Wu/11.dat', './Wu/12.dat', './Wu/31.dat', ...
        './Wu/211.dat', './Wu/216.dat', './Wu/213.dat','./Wu/214.dat', './Wu/32.dat', './Wu/210.dat', './Wu/200.dat', './Wu/201.dat'};
    first = 1;
    last =  size(file_list,2);
    varx = zeros(30,last-first+1);
    for j = 1:last-first+1
        fn = char(file_list(first+j-1));
        nitems = 3000;
        feature = angle(sanit_csi_dant(fn, nitems));
        
        for i = 1:30
            varx(i,j) = min(var(feature(i,:)), var(angle(exp(1j * (feature(i,:)+pi)))));
        end
    end
    figure;
%     bar(mean(varx));
    bar(varx);
    legend(char(file_list(1)),char(file_list(2)),char(file_list(3)),char(file_list(4)), ...
    char(file_list(5)),char(file_list(6)),char(file_list(7)),char(file_list(8)), ...
    char(file_list(9)), char(file_list(10)), char(file_list(11)));
end