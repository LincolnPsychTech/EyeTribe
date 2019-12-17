function [sock, screen] = etconnect(port)

% Establish socket
sock = tcpip('localhost', port);
sock.timeout = 1;
fopen(sock);

% Get screen parameters
fprintf(sock,'{"category": "tracker", "request": "get", "values": ["screenresw"]}');
w_raw = fscanf(sock);
w = jsondecode(w_raw);
screen.Width = w.values.screenresw;

fprintf(sock,'{"category": "tracker", "request": "get", "values": ["screenresh"]}');
h_raw = fscanf(sock);
h = jsondecode(h_raw);
screen.Height = h.values.screenresw;

