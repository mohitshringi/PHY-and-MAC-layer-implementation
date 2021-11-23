function [raw] = mac_to_phy(mac_frame)

%  ______________________________________________
% | Preamble  | SFD    | Length  | mac frame     |
% | 7 bytes   | 1 byte | 2 bytes | 64-1522 bytes |
% |___________|________|_________|_______________|

% make a phy packet from the mac frame.
% use these for preamble and sfd:

% preamble is just an alternating sequence of 1 and 0's for synchronization
% sfd is start frame delimeter, indicates the starting of the frame.
% sfd is also an alternating sequence of 1's and 0's but with the last bit
% 1.

preamble = mod((1:56),2);
sfd = [mod(1:7, 2) 1];

%we need to append legth in proper endian form , because by default bi2de 
% return msb on right side, so in the frame/raw, the length gets appended
% in wrong manner, so using 'left-msb' flag 
len_mac_send = de2bi(length(mac_frame),'left-msb',16);

raw = [ preamble sfd len_mac_send mac_frame];
end