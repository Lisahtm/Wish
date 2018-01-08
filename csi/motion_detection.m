function motion_detection
    source_list = {'USRP', 'NIC_AMP', 'NIC_PHASE_DIFF'};
    source = source_list(1);
    
    if strcmp(source, source_list(1))
        fn = './mywifi/8xxx.dat';
%         fn = '../8xxx.dat';
        nitems = 3000;
        feature = sanit_csi_usrp(fn,nitems);
    elseif strcmp(source, source_list(2))
        fn = './Wu/212.dat';
%         fn = './detection/los_detect_2.dat';
        nitems = 3000;
        feature = sanit_csi_nic(fn,1,nitems);
    else
%         fn = './Wu/31.dat';
        fn = './detection/los_detect_2.dat';
        nitems = 3000;
        feature = exp(1j * angle(sanit_csi_dant(fn,nitems)));
    end
    
    window_size =20;
    feature_norm = zeros(1,size(feature, 2));
    for i = 1:size(feature, 2)
        feature_norm(i) = norm(feature(:,i));
    end
    result = zeros(2, size(feature, 2) - window_size + 1);
    for i = 1:size(result,2)
        corr = zeros(window_size);
        for j = 0:window_size - 1
            for k = 0:window_size - 1
                corr(j+1,k+1) = (feature(:,i+k)' * feature(:,i+j)) ...
                    / (feature_norm(i+k) * feature_norm(i+j));
                corr(k+1,j+1) = (feature(:,i+j)' * feature(:,i+k)) ...
                    / (feature_norm(i+k) * feature_norm(i+j));
            end
        end
        result(:,i) = eigs(corr,2);
    end
    figure;
%     plot(result(1,:),result(2,:),'*');
    plot(result(2,1:1:end),'*');
end