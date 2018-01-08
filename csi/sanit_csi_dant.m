function cfr = sanit_csi_dant(fn, nitems)
    k = [-28:2:-2,-1,1:2:27,28];
    n = size(k,2);
    cfr1 = csi_get_csi(fn,1);
    cfr2 = csi_get_csi(fn,2);
    cfr = (cfr1.*conj(cfr2)).';
    
    if nitems >= size(cfr,2)
        nitems = size(cfr,2);
    else
        cfr = cfr(:,1:nitems);
    end
    
    arg = angle(cfr);
    figure;
    plot(arg,'-*');
    
    temp = zeros(n,size(arg,2));
    temp(1,:) = arg(1,:);
    
    for j = 1:size(arg,2)
        base = 0;
        for i = 2:n
            if arg(i,j) - arg(i-1,j) > pi
                base = base + 1;
            elseif arg(i,j) - arg(i-1,j) < -pi
                base = base - 1;
            end
            temp(i,j) = arg(i,j) - 2 * pi * base;
        end
    end
    
    offset = mean(temp,1);
    for i = 1:size(temp,2)
        temp(:,i) = temp(:,i) - ones(n,1).*offset(i);
    end
    
    cfr = abs(cfr).*exp(1j*temp);
    cfr = arg;
%     trarg = angle(exp(1j*temp(1:n,:)));
    
%     figure;
%     [ACF, lags, bounds] = autocorr(trarg(1,:),800);
%     stem(ACF, 'o');
end