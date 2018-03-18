function [signal_cos, signal_sin] = fmcw_ofdm_signal(sample_rate, space_freq, center_freq, carrier_count, samples_count, gain, bandwidth)
    carrier_count = floor(carrier_count / 2);
    carrier_freq = (-carrier_count:carrier_count) * space_freq;
    time_indices = (0:samples_count-1) / sample_rate;
    baseband_signal = gain * exp(1j*2*pi*carrier_freq'*time_indices);
    
    sweep_time = sample_rate / space_freq;
    [signal_cos, signal_sin] = sawtooth_signal(sample_rate, sweep_time, ceil(samples_count / sweep_time), bandwidth, center_freq, 0);
    carrier_signal = signal_cos + 1j * signal_sin;
    signal_cos = real(baseband_signal .* carrier_signal);
    signal_sin = imag(baseband_signal .* carrier_signal);
    figure;
    plot((0:length(signal_cos)-1)/(length(signal_cos)/sample_rate), abs(fft(signal_cos)));
end