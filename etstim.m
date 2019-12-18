function stim = etstim(ax, stimdir, x, y, w, h)
%% Read image
[img, ~, alpha] = imread(stimdir); % Read image
if isempty(alpha) % If no transparency data...
    alpha = ones(size(img, [1,2])); % Set all pixels to fully opaque
end

%% Defaults for non-values
if isempty(w) % If width is blank...
    w = size(img, 2); % Default to full size
end
if isempty(h) % If height is blank...
    h = size(img, 1); % Default to full size
end
if isempty(x) % If x is blank...
    x = (ax.XLim(2) - w) / 2; % Default to center
end
if isempty(y) % If y is blank...
    y = (ax.YLim(2) - h) / 2; % Default to center
end

%% Create storage structure
stim = struct(...
    'Pos', [x y w h], ... % Position (x, y, width, height)
    'Dir', stimdir, ... % File location
    'Obj', [] ... % Object handle
    );

%% Draw image
stim.Obj = image(ax, ...
    'XData', [stim.Pos(1), stim.Pos(1)+stim.Pos(3)], ... % Position horizontal
    'YData', [stim.Pos(2), stim.Pos(2)+stim.Pos(4)], ... % Position vertical
    'CData', flipud(img), ... % Flip upside down as y axes are backwards
    'AlphaData', flipud(alpha) ... % Apply transparency
    );