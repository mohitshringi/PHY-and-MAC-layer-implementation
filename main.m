% This is the main file to sum up all the components for simulation.
% Complete all the codes below.
% We are designing only phy and mac thus we are currently ignoring 
% other things such as IP etc.

% for uniformity in judgement, ensure that your transmitted signal has
% energy equal to 1. bit duration, ta=0.2ms
% Keep number of samples per pulse (ns) around 20-25 to not cause memory
% issues or crashes.
% Ensure fc in 17kHz-20kHz

% set your parameters fc, ta etc here:
ta = 0.0002;
ns = 20;
fc = 18000;


% 0) The message to be transmitted is actually divided into packets by the
% layers which are above the mac layer. You are free to divide the message
% as you wish. Longer packets will make it difficult to avoid collisions.
% IEEE has recommended 46 - 1500 bytes. It can vary as per your choice.

% Declare a single packet here:

packet = randi(0:1,1,400); % 50 byte message



% 1) Then mac layer combines this packet with some info to make a frame:
%  __________________________________________________________________
% | Dest mac addr | src mac addr | Length of| Packet        | CRC     |
% | (6 bytes)     | (6 bytes)    | L3 packet| from layer 3  | 4 bytes |
% |               |              | 2 bytes  | 46-1500 bytes |         |
% |_______________|______________|__________|_______________|_________|
%
% You can choose any 6 byte bit seq as the addresses for the simulation.

src_addr = randi(0:1,1,24); 
dest_addr = randi(0:1,1,24); 


% CRC is called cyclic redundancy check. It is used for checking if the
% transmission was accurate or erroneous.
% For 4-byte (32 bit) CRC calculation, use CRC32 algorithm.

% 1.1) Use comm.CRCGenerator with a 32 degree polynomial (Check Docs!)
% Generate a CRC generator object and pass it to the function
% This object is necessary because CRC values are not unique.

% Use this for th polynomial:
% 'z^32 + z^26 + z^23 + z^22 + z^16 + z^12 + z^11 + z^10 + z^8 + z^7 + z^5 + z^4 + z^2 + z + 1'
%crc poly is a of length 33, because we need to append 32 bits 

poly = 'z^32 + z^26 + z^23 + z^22 + z^16 + z^12 + z^11 + z^10 + z^8 + z^7 + z^5 + z^4 + z^2 + z + 1';
crcgenerator = comm.CRCGenerator(poly);


% 1.2) After generating a CRCGenerator above, create a CRCDetector Object for
% error detection here.
crcdetector = comm.CRCDetector(poly);


% 1.3) Generate the mac frame using L3_to_macframe.m

mac_frame = L3_to_macframe(dest_addr, src_addr, packet, crcgenerator);





% 2) The phy layer combines this frame with some extra bits:
%  ______________________________________________
% | Preamble  | SFD    | Length  | mac frame     |<---Interpacket Gap--->
% | 7 bytes   | 1 byte | 2 bytes | 64-1522 bytes | time delay bw packets
% |___________|________|_________|_______________|

% relevant functions: mac_to_phy.m

raw = mac_to_phy(mac_frame);



% 3) Before transmission, the sender checks if the channel is in use. To do
% that send a dummy message





% 3.1) generate a dummy message of 8 bits.
dummy = randi(0:1,1,8);

% 3.2) apply CRC. Use the object generated above
dummy_frame = crcgenerator(dummy')';

% 3.3) modulate the message. use function modulate.m
dummy_mod = modulate(dummy_frame,ta,ns,fc);

% 3.4) Now receiving ths signal, use demodulate.m
dummy_demod = demodulate(dummy_mod,ta,ns,fc);

% 3.5) Check if error occured by using comm.CRCDetector
[~,err] = crcdetector(dummy_demod');

if err==0
disp("Channel empty");
% 4) If no errors, the packet is modulated and transmitted
% use modulate.m
modulated = modulate(raw,ta,ns,fc);


% 5) receiver receives the packet, demodulates it. rejects if the message
% was not addressed to it.
% use demodulate.m
demodulated = demodulate(modulated,ta,ns,fc);


% 7) mac frame is extracted from the raw bits received by phy
% use phy_to_mac.m
mac_frame_recv = phy_to_mac(demodulated);


% 8) check the accuracy using CRC.
% use crcdetector defined above
%input to comm.CRC shoudl eb column vector, therefore we use transpose
[~,err] = crcdetector(mac_frame_recv');


% 8.1) extract the Level 3 packet from mac_frame (macframe_to_L3.m)
packet_recv = macframe_to_L3(mac_frame_recv);

% 9) If correct message received, send ACK else NACK from the receiver.

% ack is the 7 bit sequence 000 0110
ack = [0 0 0 0 1 1 0];

% nack is the 7 bit sequence 001 0101
nack = [0 0 1 0 1 0 1];

% use modulate.m
if err==0 
    acknowledge_send = modulate(ack,ta,ns,fc);
else
    acknowledge_send = modulate(nack,ta,ns,fc);
end

% 10) sender receives the acknowledgement.
% use demodulate.m
acknowledge_recv = demodulate(acknowledge_send,ta,ns,fc);

if isequal(acknowledge_recv,ack) 
    disp('Transmission Success');
else 
    disp('Transmission Failed');
end


else
    disp("Channel not empty");
end

