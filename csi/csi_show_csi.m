function csi_show_csi()

fn = './detection/nlos_static.dat';
ant = 1;

cfr1 = csi_get_csi(fn,ant);

plot(angle(cfr1(1,:)))

end