function stim = etstim(ax, ogstim, pos)
% Function to draw a stimulus to an axis, recommended to draw it to an axis
% created via @etwindow, but can work with any axis.
% stim = Image / Textbox object created
% ax = Axis to draw to
% To create stim spec structure without plotting, supply a screen spec
% structure generated via @etconnect rather than an axis handle
% pos = [x co-ordinate of bottom left corner, y co-ordinate of bottom left
% corner, stimulus width, stimulus height]
% If no values for pos are supplied, stimulus will default to full size and
% centered. To default only some values, supply NaN.


%% Predefine reference variables
imgExts = imformats; % Get all valid image file types
txtExts = {'txt'}; % Specify valid text file types

%% Determine ax type
if ishandle(ax) % If ax is a handle...
    % Do nothing
elseif all( isfield(ax, {'Width', 'Height'}) ) % If ax is merely screen spec...
    ax.XLim = [1, ax.Width]; % Create placeholder XLim field with width
    ax.YLim = [1, ax.Height]; % Create placeholder YLim field with height
else % If ax is neither
    error("ax must be either an axis handle or screen spec structure generated via @etconnect");
end

%% Initialise storage structure
if all( isfield(ogstim, {'Type', 'Pos', 'Dir', 'Obj'}) ) % If input is an @etstim structure...
    stim = ogstim; % Get stimulus spec
    
elseif isstring(ogstim) || ischar(ogstim)
    %% Create stim structure
    stim = struct(...
    'Type', [], ... % File type
    'Pos', [], ... % Position (x, y, width, height)
    'Dir', ogstim, ... % File location
    'Obj', [] ... % Object handle
    ); 

    %% Determine stim type
    [~, ~, ext] = fileparts(ogstim); % Take only the last cell
    switch erase(ext, '.')
        case [imgExts.ext] % If stimulus is an image...
            stim.Type = 'img';
        case txtExts
            stim.Type = 'txt';
        otherwise
            stim.Type = 'str';
    end
    
    %% Read stimulus
    switch stim.Type
        case 'img'
            [stim.Img, ~, stim.Alpha] = imread(ogstim); % Read image from file
            if isempty(stim.Alpha) % If no transparency data...
                stim.Alpha = ones(size(stim.Img, [1,2])); % Set all pixels to fully opaque
            end
        case 'txt'
            stim.Text = fileread(ogstim); % Read text from file
        case 'str'
            stim.Text = ogstim;
            stim.Dir = [];
    end
    
    %% Position stim
    switch stim.Type
        case 'img'
            defPos = [...
                mean(ax.XLim) - size(stim.Img, 2)*0.5, ... % Default to center
                mean(ax.YLim) - size(stim.Img, 1)*0.5, ... % Default to center
                size(stim.Img, 2), ... % Default to full size
                size(stim.Img, 1), ... % Default to full size
                ];
        case {'txt' 'str'}
            defPos = [...
                mean(ax.XLim), ... % Default to center
                mean(ax.YLim), ... % Default to center
                ];
    end
    
    if exist('pos', 'var') % If position is supplied...
        if isnumeric(pos) % If position is numeric array of 4 values...
            stim.Pos( ~isnan(pos) ) = pos( ~isnan(pos) ); % Use non-NaN values
            stim.Pos( isnan(pos) ) = defPos( isnan(pos) ); % Use default values where supplied values were NaN
            switch stim.Type
                case 'img'
                    invPos = [max(ax.XLim) - stim.Pos(3), max(ax.YLim) - stim.Pos(4), stim.Pos(3), stim.Pos(4)]; % Positions for inverse values (e.g. x = -200 means 200px from right edge)
                case {'txt' 'str'}
                    invPos = [max(ax.XLim), max(ax.YLim)]; % Positions for inverse values (e.g. x = -200 means 200px from right edge)
            end
            stim.Pos( pos < 0 ) = invPos( pos < 0 ) + stim.Pos( pos < 0 ); % Calculate inverse values when supplied values were negative
        else
            error("Position must be a numeric array of 4 values.");
        end
    else % If no position given...
        stim.Pos = defPos; % Use default values
    end
    

else
    error("Input must be either a structure created using etstim or a string pointing to a stimulus file");
end

if ishandle(ax)
    switch stim.Type
        case 'img'
            %% Draw image
            stim.Obj = image(ax, ...
                'XData', [stim.Pos(1), stim.Pos(1) + stim.Pos(3)], ... % Position horizontal
                'YData', [stim.Pos(2), stim.Pos(2) + stim.Pos(4)], ... % Position vertical
                'CData', flipud(stim.Img), ... % Flip upside down as y axes are backwards
                'AlphaData', flipud(stim.Alpha) ... % Apply transparency
                );
            
        case {'txt' 'str'}
            stim.Obj = text(ax, ... % Create text...
                'EdgeColor', 'none', ... % ...with no edge...
                'FontSize', 20, ... % ...font size 20...
                'Position', stim.Pos, ... % ...at a user-specified position...
                'HorizontalAlignment', 'center', ... % Aligned at center
                'String', stim.Text ... % ...containing the string specified by the user
                );
    end
end

end




