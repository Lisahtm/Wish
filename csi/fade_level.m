function fade_level
%     fn = {'./raw-trace/92030101.dat','./raw-trace/92030102.dat','./raw-trace/92030103.dat', ...
%         './raw-trace/92030301.dat','./raw-trace/92030302.dat','./raw-trace/92030303.dat', ...
%         './raw-trace/92030401.dat','./raw-trace/92030402.dat','./raw-trace/92030403.dat', ...
%         './raw-trace/92030601.dat','./raw-trace/92030602.dat','./raw-trace/92030603.dat', ...
%         './raw-trace/92030701.dat','./raw-trace/92030702.dat','./raw-trace/92030703.dat', ...
%         './raw-trace/92030901.dat','./raw-trace/92030902.dat','./raw-trace/92030903.dat'};
    fn = {'./raw-trace/91030201.dat','./raw-trace/91030202.dat','./raw-trace/91030203.dat', ...
        './raw-trace/91030501.dat','./raw-trace/91030502.dat','./raw-trace/91030503.dat', ...
        './raw-trace/91030801.dat','./raw-trace/91030802.dat','./raw-trace/91030803.dat'};
    static_a = [18.9710, 22.3585, 22.4720, 21.8573, 21.6723, ...
                    21.0898, 19.9256, 18.8392, 17.4444, 15.8834, ...
                    14.0228, 12.3325, 11.0830, 9.8516,  9.2202,  ...
                    8.6252,  8.2854,  8.6166,  9.1612,  9.7840,  ...
                    10.2180, 10.2868, 10.8510, 11.0885, 11.1229, ...
                    11.6365, 13.1682, 14.3656, 14.9959, 14.1175]';
    figure;
    for k = 1:size(fn,2)
        filename = char(fn(k));
        feature = sanit_csi_nic(filename, 1, -1);
        window = 100;
        nitems = floor(size(feature,2)/window);
        group = zeros(size(feature,1), nitems);
        for i = 0:nitems-1
            group(:,i+1) = mean(feature(:,i*window+1:(i+1)*window),2);
        end

        delta_h = db(abs(group) ./ repmat(static_a, 1, size(group,2)));

        time_group = ifft(group,30);
        first = abs(time_group(1,:));
        first = repmat(first, 30, 1);
        fade = first ./ abs(group);
        
        if k == 1
            total_fade = fade;
            total_delta = delta_h;
        else
            total_fade = [total_fade, fade];
            total_delta = [total_delta, delta_h];
        end
        
%         for i = 1:30
%             plot(fade(i,:), delta_h(i,:), 'b*');
%             ylim([-20,10]);
%             xlim([-20,10]);
%             hold on
%         end
    end
    global f;
    f = total_fade(14,:);
    global d;
    d = total_delta(14,:);
%     obj = zeros(30,2);
%     for i = 1:30
%         obj(i,:) = robustfit(total_fade(i,:), total_delta(i,:));
%         x = [-20:20];
%         plot(x, obj(2)*x+obj(1));
%         hold on
%     end
end