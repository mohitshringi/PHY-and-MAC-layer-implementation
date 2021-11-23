function [mac_frame_recv] = phy_to_mac(raw)

%  ______________________________________________
% | Preamble  | SFD    | Length  | mac frame     |
% | 7 bytes   | 1 byte | 2 bytes | 64-1522 bytes |
% |___________|________|_________|_______________|


% from raw bits, remove the preamble and sfd and return
%len_mac_recv = raw(:,65:80);
mac_frame_recv = raw(:,81:end);


end