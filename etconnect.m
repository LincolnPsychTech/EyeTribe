function [sock, screen] = etconnect(port)

% Establish socket
sock = tcpip('localhost', port); % Create tcpip object
sock.timeout = 1; % Set it to time out if no response after 1s
fopen(sock); % Open connection

%% Get screen parameters
try
    fprintf(sock,'{"category": "tracker", "request": "get", "values": ["screenresw"]}'); % Send request for screen width
    w_raw = fscanf(sock); % Get response
    w = jsondecode(w_raw); % Parse response
    
    fprintf(sock,'{"category": "tracker", "request": "get", "values": ["screenresh"]}'); % Send request for screen height
    h_raw = fscanf(sock); % Get response
    h = jsondecode(h_raw); % Parse response

    screen = struct(... % Store screen size
        'Width', w.values.screenresw, ...
        'Height', h.values.screenresh ...
        ); 
    
catch % If communication fails...
    warning('EyeTribe could not supply screen size. Using Matlab estimate.')
    sDim = get(groot, 'ScreenSize'); % Get screen size from Matlab
    screen = struct(... % Store screen size
        'Width', sDim(3), ...
        'Height', sDim(4) ...
        ); 
end

