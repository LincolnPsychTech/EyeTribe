function etdisconnect(sock)
% Disconnect from EyeTribe
% sock = TCPIP socket connected to EyeTribe, created from @etconnect

fclose(sock) % Close the socket