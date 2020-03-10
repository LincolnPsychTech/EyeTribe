function output = etcsv(data, filepath)
% Function to extract specific fields from EyeTribe data output and export
% them as a csv
% data = EyeTribe data
% output = Matlab table which will be saved to a csv

output = []; % Create blank variable to store output
subfields = tunnel({''}, data); % Get field paths of each field and subfield
for sf = subfields % For each subfield...
    path = strsplit(sf{:}, '.'); % Split the path by full stops
    rtlvl = data; % Identify the root structure
    for spf = path % For each subpath...
        rtlvl = [rtlvl.(spf{:})]'; % Move the current level to that path
    end
    
    output.(replace(sf{:}, '.', '_')) = rtlvl; % Store the data in an appropriately named field of the output structure
end

output = struct2table(output);

%% Save as a csv
if ~exist('filepath', 'var') % If no filepath was specified...
    folder = uigetdir(); % Open a directory window
    fname = inputdlg('Name data file', 'Name data file', 1, {'ETdata'}); % Ask user to name output file
    filepath = [folder '\' fname{:} '.csv']; % Create filepath from this
end

writetable(output, filepath); % Save csv






    function subs = tunnel(path, data)
        path = path{:};
        
        pathFields = strsplit(path, '.');
        if strcmp(pathFields, '')
            pathFields = [];
        end
        lvl = data;
        for pf = pathFields
            lvl = lvl.(pf{:});
        end
        
        subs = [];
        for f = fieldnames(lvl)'
            if isstruct([lvl.(f{:})])
                subs = [subs, tunnel(join([pathFields, f], '.'), data)];
            else
                subs = [subs, join([pathFields, f], '.')];
            end
        end
    end
end