function stim = etstim(ax, stimdir, x, y, w, h)
% Function to draw a stimulus to an axis, recommended to draw it to an axis
% created via @etwindow, but can work with any axis.
% stim = Image / Textbox object created
% ax = Axis to draw to
% x = x co-ordinate of bottom left corner
% y = y co-ordinate of bottom left corner
% w = stimulus width
% h = stimulus height

%% Create storage structure
stim = struct(...
    'Type', [], ... % File type
    'Pos', [x y w h], ... % Position (x, y, width, height)
    'Dir', stimdir, ... % File location
    'Obj', [] ... % Object handle
    );

%% Determine stim type
imgExts = imformats; % Get all valid image file types
txtExts = {'txt'}; % Specify valid text file types

stimdirSplt = strsplit(stimdir, '.'); % Split stim dir at every full stop
stimExt = stimdirSplt{end}; % Take only the last cell


%% Split by stim type
switch stimExt
    case [imgExts.ext] % If stimulus is an image...
        stim.Type = 'img';
        
        %% Read image
        if isstring(stimdir) || ischar(stimdir) % If stimdir is a string
            [img, ~, alpha] = imread(stimdir); % Read image
            if isempty(alpha) % If no transparency data...
                alpha = ones(size(img, [1,2])); % Set all pixels to fully opaque
            end
        elseif all( isfield(stimdir, {'img' 'alpha'}) ) % If stimdir is a structure with "img" AND "alpha" fields
            img = stimdir.img; % Read image
            alpha = stimdir.alpha; % Read alpha
        elseif isfield(stimdir, 'img') % If stimdir is a structure with just an "img" field
            img = stimdir.img; % Read image
            alpha = ones( size(stimdir.img, [1 2]) ); % Set all pixels to fully opaque
        elseif isnumeric(stimdir) && size(stimdir, 3) == 3 % If stimdir is a numeric array of RGB triplets
            img = stimdir; % Read image
            alpha = ones( size(stimdir, [1 2]) ); % Set all pixels to fully opaque 
        end
        
        %% Defaults for non-values
        if isempty(w) % If width is blank...
            stim.Pos(3) = size(img, 2); % Default to full size
        end
        if isempty(h) % If height is blank...
            stim.Pos(4) = size(img, 1); % Default to full size
        end
        if isempty(x) % If x is blank...
            stim.Pos(1) = (ax.XLim(2) - stim.Pos(3)) / 2; % Default to center
        end
        if isempty(y) % If y is blank...
            stim.Pos(2) = (ax.YLim(2) - stim.Pos(4)) / 2; % Default to center
        end
        
        %% Draw image
        stim.Obj = image(ax, ...
            'XData', [stim.Pos(1), stim.Pos(1) + stim.Pos(3)], ... % Position horizontal
            'YData', [stim.Pos(2), stim.Pos(2) + stim.Pos(4)], ... % Position vertical
            'CData', flipud(img), ... % Flip upside down as y axes are backwards
            'AlphaData', flipud(alpha) ... % Apply transparency
            );
        
    case txtExts
        %% Read text
        txt = fileread(stimdir);
        
        %% Defaults for non-values
        if isempty(w) % If width is blank...
            stim.Pos(3) = 0.8; % Default to full size
        end
        if isempty(h) % If height is blank...
            stim.Pos(4) = 0.2; % Default to full size
        end
        if isempty(x) % If x is blank...
            stim.Pos(1) = 0.1; % Default to center
        end
        if isempty(y) % If y is blank...
            stim.Pos(2) = 0.1; % Default to center
        end
        
        %% Draw text
        stim.Obj = annotation(ax.Parent, 'textbox', ... % Create a textbox...
            'EdgeColor', 'none', ... % ...with no edge...
            'FontSize', 20, ... % ...font size 20...
            'Position', [stim.Pos(1) stim.Pos(2) stim.Pos(3) stim.Pos(4)], ... % ...at a user-specified position...
            'String', txt); % ...containing the string specified by the user
end




