function fig = etplot(data, screen, varargin)
plotData = [data.avg]; % Get averaged data
x = [plotData.x]; % Get x data
y = [plotData.y]; % Get y data
i = ... % Generate exclusion matrix
    ~( isoutlier(x) | isoutlier(y) ) & ... % Exclude values which are outliers
    ~( x < 10 | y < 10 | x > screen.Width - 10 | y > screen.Height - 10 ) ... % Exclude values which are off the screen
    ;

%% Create figure
sDim = get(groot, 'ScreenSize'); % Get screen size
scale = min( (sDim(3)-200) / screen.Width, (sDim(4)-200) / screen.Height ); % Calculate the ratio between the screen used for testing and current screen
fig = figure(...
    'InnerPosition', [0, 0, screen.Width*scale, screen.Height*scale]... % Make figure the same size as 
    );
movegui('center')

%% Create axis
ax = axes(fig);
set(ax, ... % Format axis
    'Position', [0, 0, 1, 1], ... % Fill window
    'NextPlot', 'add', ... % Keep plots when drawing new ones
    'XLim', [0, screen.Width], ... % X limits to window width (pixels)
    'YLim', [0, screen.Height], ... % X limits to window width (pixels)
    'Color', [0.97, 0.97, 0.99], ... % Grey background
    'Box', 'off', ... % No outline
    'TickLength', [0 0], ... % No tickmarks
    'FontName', 'Verdana', ... % Nicer font
    ... % Add major gridlines
    'GridColor', 'white', ... % White lines
    'GridAlpha', 1, ... % Full opacity
    'GridLineStyle', '-', ... % Solid lines
    'XGrid', 'on', ... % Vertical lines
    'YGrid', 'on', ... % Horizontal lines
    ... % Add minor gridlines
    'MinorGridColor', 'white', ... % White lines
    'MinorGridAlpha', 1, ... % Full opacity
    'MinorGridLineStyle', '-', ... % Solid lines
    'XMinorGrid', 'on', ... % Vertical lines
    'YMinorGrid', 'on' ... % Horizontal lines
    );

%% Draw stimulus
for stim = varargin
    stim = stim{:};
    etstim(ax, stim.Dir, stim.Pos(1), stim.Pos(2), stim.Pos(3), stim.Pos(4))
end

%% Plot eye movement
trace = line(ax, x(i), screen.Height-y(i), ...
    'Color', 'red', ...
    'LineWidth', 2 ...
    );
fix = scatter(ax, x(i & [data.fix]), screen.Height-y(i & [data.fix]), ...
    'Marker', 'o', ...
    'LineWidth', 2, ...
    'SizeData', 72, ...
    'MarkerEdgeColor', 'red', ...
    'MarkerFaceColor', 'white' ...
    );

end