function ret = wu_get_csi(dirs)

files = dir([dirs, '*.dat']);
 
for a = 1:length(files)
    
    filename = strcat(dirs, files(a).name);

    
    %csi_trace = read_bf_file(strcat('csi_nlos_5',num2str(i),'.dat'));
    csi_trace = read_bf_file(filename);

    cfr_a_array = zeros(length(csi_trace),30); % Amplitude of CFR for all packets
    cfr_p_array = zeros(length(csi_trace),30); % Phase of CFR for all packets
    %cir_a_array = zeros(length(csi_trace),nfft); % Amplitude of CIR for uall packets
    %cir_p_array = zeros(length(csi_trace),nfft); % Phase of CIR for all packets
    cfr_array = zeros(length(csi_trace), 30);

    for k = 1:length(csi_trace)        
        csi_entry = csi_trace{k}; % for the k_{th} packet
        csi_entry.csi = csi_entry.csi(1, :, :);
        %if isempty(csi_entry) || size(csi_entry.csi, 1) ~= 1
        %    continue;
        %end
        
        csi_all = squeeze(get_scaled_csi(csi_entry)).'; % estimate channel matrix Hexp-figu
        csi = csi_all(:,1); % select CSI for one antenna pair

    %     mitigate random phase shift
    %     csi_a = abs(csi); % amplitude of CSI
    %     csi_p = angle(csi); % phase of CSI
    %     csi_a_array(k,:)= csi_a;
    %     sanitization from spot localization
    %     a = (csi_p(30)-csi_p(1))/2/pi/30;
    %     b = mean(csi_p);
    %     for f = 1:30
    %         csi(f) = csi_a(f).*exp(1i*(csi_p(f)-a*f-b));
    %     end

        cfr = csi;
        cfr_a_array(k,:) = abs(cfr);
        cfr_p_array(k,:) = angle(cfr);
        cfr_array(k,:) = cfr;
    end
    cfr_an1 = cfr_array;

    cfr_array = zeros(length(csi_trace), 30);
    for k = 1:length(csi_trace)
        csi_entry = csi_trace{k}; % for the k_{th} packet
        
        if isempty(csi_entry) || size(csi_entry.csi, 1) ~= 1
            continue;
        end
        
        csi_all = squeeze(get_scaled_csi(csi_entry)).'; % estimate channel matrix Hexp-figu
        csi = csi_all(:,2); % select CSI for one antenna pair


        cfr = csi;
        cfr_a_array(k,:) = abs(cfr);
        cfr_p_array(k,:) = angle(cfr);
        cfr_array(k,:) = cfr;
    end

    cfr_an2 = cfr_array;

    cfr_array = zeros(length(csi_trace), 30);
    for k = 1:length(csi_trace)
        csi_entry = csi_trace{k}; % for the k_{th} packet
        
        if isempty(csi_entry) || size(csi_entry.csi, 1) ~= 1
            continue;
        end
        
        csi_all = squeeze(get_scaled_csi(csi_entry)).'; % estimate channel matrix Hexp-figu
        csi = csi_all(:,3); % select CSI for one antenna pair


        cfr = csi;
        cfr_a_array(k,:) = abs(cfr);
        cfr_p_array(k,:) = angle(cfr);
        cfr_array(k,:) = cfr;
    end
    cfr_an3 = cfr_array;
    
    save(strcat(filename, '.mat'), 'csi_trace', 'cfr_an1', 'cfr_an2', 'cfr_an3');
    ret = cfr_array;
end