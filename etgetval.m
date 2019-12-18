function val = etgetval(sock)
try
    fprintf(sock,'{"category": "tracker", "request": "get", "values": ["frame"]}'); % Send request to socket
    raw = fscanf(sock); % Get data back from socket
    parsed = jsondecode(raw); % Parse json data to a structure
    val = parsed.values.frame; % Remove extraneous layers
    val.timestamp = datetime(val.timestamp); % Convert timestamps to datetime format
catch % If request fails...
    val = NaN; % Set value to NaN
    warning('Could not get value from sensor.') % Issue warning
end