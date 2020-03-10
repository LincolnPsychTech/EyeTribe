function data = etrun(sock, dur, varargin)


eye = ["avg" "lefteye" "raw" "righteye"]; % Specify possible eyes data could come from

data = []; % Create blank structure for data
tic % Start a timer
while toc < dur % Until timer reaches dur
    val = etgetval(sock); % Get eyetracker value
    val = etisroi(val, varargin{:}); % Check whether it falls within an roi
    data = [data, val]; % Append value to data structure
end
