function [mac_frame] = L3_to_macframe(dest_addr, src_addr, packet, crcgenerator)
% dest_addr is the mac address of receiver
% src_addr is the mac address of receiver
% packet is the data received from layer 3
% crcgenerator is the crc generator object for generating and appending
% CRC code to the packet

% The format of mac_frame:
%  __________________________________________________________________
% | Dest mac addr | src mac addr | Length of| Packet        | CRC     |
% | (6 bytes)     | (6 bytes)    | L3 packet| from layer 3  | 4 bytes |
% |               |              | 2 bytes  | 46-1500 bytes |         |
% |_______________|______________|__________|_______________|_________|

% CRC is called cyclic redundancy check. It is used for checking if the
% transmission was accurate or erroneous.
% For 4-byte (32 bit) CRC calculation, use CRC32 algorithm.

%we need to append legth in proper endian form , because by default bi2de 
% return msb on right side, so in the frame/raw, the length gets appended
% in wrong manner, so using 'left-msb' flag 
len_L3_send = de2bi(length(packet),'left-msb',16);
frame = [dest_addr src_addr len_L3_send packet];

% the crcgenerator takes in binary "column" vector as input, 
% so we need to feed in transpose of frame,
% also output is column vector, 
% so we need to assign its transpose to mac_frame
mac_frame = crcgenerator(frame')';



end