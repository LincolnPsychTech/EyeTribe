function data = etrun(sock, dur, varargin)

roi = []; % Create blank array to store regions of interest in
for v = varargin % For each optional input...
    if all( isfield(v{:},{'Class', 'Name', 'x', 'y'}) ) % ...if it has the fields you would expect of an roi spec...
        if strcmp(v{:}.Class, 'roi') % ...and its Class field is listed as "roi"...
            roi = [roi; v{:}]; % Store it in the roi array
        end
    end
end
eye = ["avg" "lefteye" "raw" "righteye"]; % Specify possible eyes data could come from

data = []; % Create blank structure for data
tic % Start a timer
while toc < dur % Until timer reaches dur
    val = etgetval(sock); % Get eyetracker value
    for r = roi' % For each roi...
        for e = eye(isfield(val, eye)) % ...for each eye...
            val.(['ROI_' r.Name]).(e) = inpolygon(val.avg.x, val.avg.y, r.x, r.y); % Do the coords for this eye fall within this roi?
        end
    end
    data = [data, val]; % Append value to data structure
end
