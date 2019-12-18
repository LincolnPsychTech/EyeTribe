function data = etrun(sock, dur)
data = []; % Create blank structure for data
tic % Start a timer
while toc < dur % Until timer reaches dur
    val = etgetval(sock); % Get eyetracker value
    data = [data, val]; % Append value to data structure
end
