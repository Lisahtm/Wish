function cfr = sanit_csi_usrp(fn, nitem)
    fin = fopen(fn, 'r');
    cfr = fread(fin,[2,64*nitem],'float32');
    
    nitem = floor(size(cfr,2) / 64);
    cfr = cfr(:,1:64*nitem);
    cfr = cfr(1,:) + cfr(2,:) * 1j;
    cfr = reshape(cfr, 64, nitem);
    
    k = [-26:-1,1:26];
    n = size(k,2);

    cfr = cfr(k+33,:);

%     figure;
%     [ACF, lags, bounds] = autocorr(abs(cfr(1,:)),800);
%     stem(ACF, 'o');
    
    arg = angle(cfr);
    
    temp = zeros(size(arg));        
    for j = 1:size(arg,2)
        for l = 1:10
            temp(1,j) = arg(1,j);

            base = 0;
            for i = 2:n
                if arg(i,j) - arg(i-1,j) > pi
                    base = base + 1;
                elseif arg(i,j) - arg(i-1,j) < -pi
                    base = base - 1;
                end
                temp(i,j) = arg(i,j) - 2 * pi * base;
            end
            
            slope = (temp(n,j)-temp(1,j))./(k(n)-k(1));
            offset = mean(temp(:,j));                
            temp(:,j) = temp(:,j) - slope.*k' - ones(n,1).*offset;

            temp(:,j) = angle(exp(1j*temp(:,j)));
            
            arg(:,j) = temp(:,j);
        end
    end
    
%     trarg = angle(exp(1j*temp(1:n,:)));
    cfr = abs(cfr).*exp(1j * temp);
end