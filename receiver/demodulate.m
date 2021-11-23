function [demodulated] = demodulate(modulated, ta, ns, fc)
% demodulate packet
% ta = bit pulse duration
% ns = no of samples in one pulse
% fc = carrier freq
dt = ta/ns;
t = dt:dt:ta*(length(modulated)/ns); % we need length of packet, so / by ns

demod = modulated .* cos(2*pi*fc*t);
demod = conv(demod, dt*ones(1,ta/dt), 'same');
demod = demod > 0; %this is demodulated bit stream 

% we sample at centre of each bit, to get original sized packet
sampling_instances = ta/2:ta:ta*(length(modulated)/ns);
demodulated = demod(floor(sampling_instances/dt)); %even ceil can be used
demodulated = demodulated >0;

end