function link_distinction
    source_list = {'USRP', 'NIC_AMP', 'NIC_PHASE_DIFF'};
    source = source_list(2);
    nscene = 6;
    if strcmp(source, source_list(1))
        nitems = 2000;
        n = 52;
        feature = zeros(nscene,n,nitems);
        file_list = {'./mywifi/11.dat', './mywifi/21.dat', './mywifi/22.dat', './mywifi/23.dat', './mywifi/31.dat', './mywifi/71.dat'};
        for i = 1:nscene
            feature(i,:,:) = sanit_csi_usrp(char(file_list(i)), nitems);
        end
    elseif strcmp(source, source_list(2))
        nitems = 1000;
        n = 30;
        feature = zeros(nscene,n,nitems);
        file_list = {'./Wu/210.dat', './Wu/215.dat', './Wu/212.dat', './Wu/213.dat', './Wu/214.dat', './Wu/31.dat'};
        for i = 1:nscene
            feature(i,:,:) = sanit_csi_nic(char(file_list(i)), 1, nitems);
        end
    elseif strcmp(source, source_list(3))
        nitems = 2000;
        n = 30;
        feature = zeros(nscene,n,nitems);
        file_list = {'./Wu/210.dat', './Wu/211.dat', './Wu/212.dat', './Wu/213.dat', './Wu/214.dat', './Wu/31.dat'};
        for i = 1:nscene
            feature(i,:,:) = exp(1j * angle(sanit_csi_dant(char(file_list(i)),nitems)));
        end
    end

    figure;
    plot(abs(squeeze(feature(3,:,:))),'-*');
%     nsize = 500;
%     ngroup = nitems/nsize;
%     center = zeros(nscene, ngroup, n);
%     distance = zeros(nscene, ngroup);
%     for i = 1:nscene
%         for j = 1:ngroup
%             center(i, j, :) = mean(squeeze(feature(i, :, ((j-1)*nsize+1):(j*nsize))),2);
%             for k = ((j-1)*nsize+1):(j*nsize)-1
%                 for l = k+1:(j*nsize)
%                     distance(i,j) = distance(i,j) + norm(feature(i,:,k)-feature(i,:,l));
%                 end
%             end
%             distance(i,j) = 2 * distance(i,j) / (nsize * (nsize - 1));
%         end
%     end
%     center_dis_between_scene = zeros(nscene);
%     for i = 1:nscene
%         for j = 1:nscene
%             center_dis_between_scene(i,j) = norm(squeeze(center(i,1,:) - center(j,1,:)));
%         end
%     end
%     distance
%     center_dis_between_scene
end