function cfr = sanit_csi_nic(fn, ant, nitems)
    k = [-28:2:-2,-1,1:2:27,28];
    n = size(k,2);
    cfr = csi_get_csi(fn,ant).';
    if nitems <= size(cfr,2) && nitems > 0
        cfr = cfr(:,1:nitems);
    end
     
%     figure;
%     [ACF, lags, bounds] = autocorr(abs(cfr(1,:)),800);
%     stem(ACF, 'o');

    arg = angle(cfr);
    
    temp = zeros(size(arg));        
    for j = 1:size(arg,2)
        for l = 1:10
            clear = true;
            temp(1,j) = arg(1,j);

            base = 0;
            for i = 2:n
                if arg(i,j) - arg(i-1,j) > pi
                    base = base + 1;
                    clear = false;
                elseif arg(i,j) - arg(i-1,j) < -pi
                    base = base - 1;
                    clear = false;
                end
                temp(i,j) = arg(i,j) - 2 * pi * base;
            end
            
            if clear == true
                break;
            else
                slope = (temp(n,j)-temp(1,j))./(k(n)-k(1));
                offset = mean(temp(:,j));
                temp(:,j) = temp(:,j) - slope.*k' - ones(n,1).*offset;
            end

            temp(:,j) = angle(exp(1j*temp(:,j)));
            
            arg(:,j) = temp(:,j);
        end
    end

    
%     trarg = angle(exp(1j*temp(1:end,:)));
    cfr = abs(cfr).*exp(1j * temp);
end