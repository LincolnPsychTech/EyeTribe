function data = EyeTribeRun(port, dur, sps)
data = struct();

et = tcpip('localhost', port);
fopen(et);

fprintf(et,'{"category": "tracker", "request": "get", "values": ["screenresw"]}');
w_raw = erase(fscanf(et), {'"' '{' '}' ':'});
w_cell = strsplit(w_raw, 'valuesscreenresw');
fprintf(et,'{"category": "tracker", "request": "get", "values": ["screenresh"]}');
h_raw = erase(fscanf(et), {'"' '{' '}' ':'});
h_cell = strsplit(h_raw, 'valuesscreenresh');

screendim = [str2double(w_cell(end)) str2double(h_cell(end))];

thisTrial = etgetval(et);
for field = fieldnames(thisTrial)'
    data.(field{:}) = thisTrial.(field{:});
end

for frame = 1:dur*sps
    tic % Start a timer
    while toc < 1/sps % Until the timer reaches sps^-1
        thisTrial = etgetval(et);
    end
    for field = fieldnames(thisTrial)'
        try
            data.(field{:})(end+1,:) = thisTrial.(field{:});
        catch
            error
        end
    end
end

data.screen = screendim;

    function output = etgetval(et)
        fprintf(et,'{"category": "tracker", "request": "get", "values": ["frame"]}');
        raw = fscanf(et);
        
        %% Split into sections
        [dat, head] = strsplit(raw, {'values', 'lefteye', 'righteye', 'state', '}},"raw'}); %split into sections
        head = ['request' head]; %add header for first sections (request)
        dat{strcmp(head, 'values')} = [dat{strcmp(head, {'values'})} 'raw' dat{strcmp(head, '}},"raw')} 'state' dat{strcmp(head, 'state')}]; %compile general data
        dat(strcmp(head, '}},"raw') | strcmp(head, 'state')) = []; head(strcmp(head, '}},"raw') | strcmp(head, 'state')) = []; %clear redundant cells
        for h = 1:length(head)
            sections.(head{h}) = dat{h}; %convert to structure
        end
        
        %% Request Details
        request = readsection(sections.request, {'category' 'request' 'statuscode'}); %read data from section
        
        %% General Values
        values = readsection(sections.values, {'avg' 'fix' 'raw' 'state' 'time"' 'timestamp'}); %read data from section
        time = strsplit(values.timestamp, {':' '-' '.' ' '}); time(1) = []; time = str2double(time);
        values.timestamp = datetime(time(1), time(2), time(3), time(4), time(5), time(6), time(7), 'Format', 'hh:mm:ss.SSS dd-MM-yyyy'); %convert to datetime array
        
        %% Left Values
        lefteye = readsection(sections.lefteye, {'avg' 'pcenter' 'psize' 'raw'}); %read data from section
        
        %% Right Values
        righteye = readsection(sections.righteye, {'avg' 'pcenter' 'psize' 'raw'}); %read data from section
        
        %% Compile Output
        output = struct(...
            'request', request, ...
            'values', values, ...
            'lefteye', lefteye, ...
            'righteye', righteye ...
            );
        
        function section = readsection(str, q)
            [dat, head] = strsplit(str, q); %split data
            spam = {'"' ':' ',' '{' '}'};
            dat = erase(dat, {'"' ',' '{' '}'}); dat(1) = []; %clean up data
            head = erase(head, {'"' ',' '{' '}'}); %clean up headers
            for h = 1:length(head)
                if contains(dat{h}, 'x') && contains(dat{h}, 'y') %if data is x and y coordinates...
                    dat{h} = erase(dat{h}, ':');
                    [coords, coordheads] = strsplit(dat{h}, {'x' 'y'}); %split by headers
                    coords(1) = []; %remove empty cell
                    dat{h} = struct2table(struct(...
                        'x', coords(strcmp(coordheads, 'x')), ...
                        'y', coords(strcmp(coordheads, 'y')) ...
                        ));
                elseif ~contains(head{h}, 'timestamp')
                    dat{h} = erase(dat{h}, ':');
                end
                if istable(dat{h})
                    t = varfun(@str2num,dat{h});
                    t.Properties.VariableNames = dat{h}.Properties.VariableNames;
                    dat{h} = t;
                else
                    [num, isnum] = str2num(dat{h});
                    if isnum
                        dat{h} = num;
                    end
                end
                section.(head{h}) = dat{h}; %store in structure
            end
            section = struct2table(section);
        end
    end
end