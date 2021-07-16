# CRC-Transmitter
In this project, I have implemented Cyclic Redundancy Check Algorithm on Verilog Hardware Description Language(HDL) to transmit data appended with a redundant 16-bit check data.

A CRC is an error-detecting code which is generally used to detect accidental changes to raw data while transmitting. The appended data is based on remainder of polynomial division by a generator polynomial. On recieving the data, the same calculation is repeated and the remainder obtained is compared with that of transmitted. Thus, it's obvious that both transmitter and reciever hardware is necessary.
