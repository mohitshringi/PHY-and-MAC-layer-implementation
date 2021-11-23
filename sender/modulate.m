function [modulated] = modulate(packet, ta, ns, fc)
% modulate packet
% ta = bit pulse duration
% ns = no of samples in one pulse
% fc = carrier freq
dt = ta/ns; %our smapling period

% we will convert binary matrix of 1 and 0 to 1 and -1, so automatically
% phase shift of pi is introducted, now we just need to multiply by a
% single sine wave, rather than use two shifted sine waves, 
% also helps in threshold setting in demodulation to remove noise
msg = 2*packet-1;

% we create the instances in time when we want to collect the samples
t = dt:dt:ta*length(msg); 

% for modulation we need a digital/analog sinal wave, we cant modulate bits
% hence what we do is knd of sample the bit array, we create ta/dt samples 
% of each value in the bit array, separted by dt seconds, so we get almost
% continous stream of bits, you can see it by plotting bit_packet vs time 
% basically this plot would be values of length(t)/dt no of samples plotted
% against time 

% code to convert the bit array into bit stream (square wave),
% the ceil function basically calculates the index, and then value of
% packet[index] is assigned to that sample in the bitstream
msg = msg(ceil(t/ta));
% BPSK
modulated = msg .* cos(2*pi*fc*t);

% add noise say, with snr 20 dB
modulated = awgn(modulated, 20);

end