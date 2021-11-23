function [packet_recv] = macframe_to_L3(mac_frame)
% The format of mac_frame:
%  __________________________________________________________________
% | Dest mac addr | src mac addr | Length of| Packet        | CRC     |
% | (6 bytes)     | (6 bytes)    | L3 packet| from layer 3  | 4 bytes |
% |               |              | 2 bytes  | 46-1500 bytes |         |
% |_______________|______________|__________|_______________|_________|

% remove extra bits and return the Layer 3 packet
%len_L3_recv = mac_frame(:,97:112);
packet_recv = mac_frame(:,113:end);


end