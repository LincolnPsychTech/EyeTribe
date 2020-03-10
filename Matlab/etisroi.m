function data = etisroi(data, varargin)

roi = []; % Create blank array to store regions of interest in
for v = varargin % For each optional input...
    if all( isfield(v{:},{'Class', 'Name', 'x', 'y'}) ) % ...if it has the fields you would expect of an roi spec...
        if strcmp(v{:}.Class, 'roi') % ...and its Class field is listed as "roi"...
            roi = [roi; v{:}]; % Store it in the roi array
        end
    end
end
eye = ["avg" "raw" "lefteye.avg" "lefteye.raw" "righteye.avg" "righteye.raw"]; % Specify possible eyes data could come from


for row = 1:length(data)
    for r = roi' % For each roi...
        for e = eye(isfield(data(row), eye)) % ...for each eye...
            data(row).(['ROI_' r.Name]).(e) = inpolygon(data(row).(e).x, data(row).(e).y, r.x, r.y); % Do the coords for this eye fall within this roi?
        end
    end
end