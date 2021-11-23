# PHY-and-MAC-layer-implementation

## Here is a MATLAB implementation of the PHY AND MAC layers of the OSI MODEL.
* Most of the code is explained in main.m through comments, but here is an overall overview of the process of transmitting the signal

0) The message to be transmitted is actually divided into packets by the layers which are above the mac layer. You are free to divide the message as you wish. Longer packets will make it difficult to avoid collisions.
IEEE has recommended 46 - 1500 bytes. It can vary as per your choice.

We start with a signal packet

1) Then mac layer combines this packet with some info to make a frame:  
| Dest mac addr | src mac addr | Length | Packet        | CRC     |  
CRC is called cyclic redundancy check. It is used for checking if the
transmission was accurate or erroneous.  

2) The phy layer combines this frame with some extra bits:  
| Preamble  | SFD    | Length  | mac frame     |


3) Before transmission, the sender checks if the channel is in use. To do that send a dummy message  
3.1) generate a dummy message of 8 bits.  
3.2) apply CRC.  
3.3) modulate the message  
3.4) Now receiving ths signal, use demodulate.m  
3.5) Check if error occured by using comm.CRCDetector

4) If no errors, the packet is modulated and transmitted
5) receiver receives the packet, demodulates it. rejects if the MAC is not address to the receiver
6) MAC frame is extracted from the raw bits received by physical layer
7) check the accuracy using CRC.
8) extract the Level 3 packet from mac_frame 
9) If correct message received, send ACK else NACK from the receiver.

