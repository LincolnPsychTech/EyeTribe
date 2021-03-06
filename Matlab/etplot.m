function [fig, ax] = etplot(data, screen, varargin)
% Plot the results of an EyeTribe experiment.
% fig = Figure object of output plot
% data = Data structure from an EyeTribe experiment
% screen = Screen details structure, from @etconnect
% varargin = Stimuli to plot, each input being a stim structure from @etstim


%% Transform data
plotData = [data.avg]; % Get averaged data
x = [plotData.x]; % Get x data
y = [plotData.y]; % Get y data
i = ... % Generate exclusion matrix
    ~( isoutlier(x) | isoutlier(y) ) & ... % Exclude values which are outliers
    ~( x < 10 | y < 10 | x > screen.Width - 10 | y > screen.Height - 10 ) ... % Exclude values which are off the screen
    ;

%% Sort stimuli and roi
stim_array = [];
roi_array = [];
for inp = varargin
    if all( isfield(inp{:}, {'Type', 'Pos', 'Dir', 'Obj'}) ) % If input is a stimulus...
        stim_array = [stim_array, inp]; % Append to stimulus array
    end
    if all( isfield(inp{:}, {'Class', 'Name', 'x', 'y'}) ) % If input is an roi...
        roi_array = [roi_array, inp]; % Append to roi array
    end
end

%% Create figure
fig = figure(...
    'Units', 'normalized', ...
    'Position', [0.1 0.1 0.8 0.8] ...
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

%% Draw stimuli
for stim = stim_array % For each stimulus...
    stim{:}.Obj = etstim(ax, stim{:}); % Draw stimulus
end

%% Draw roi
for roi = roi_array
    roi{:}.Obj = plot(ax, polyshape(roi{:}.x, roi{:}.y), 'LineStyle', 'none'); % Draw region of interest
    roi{:}.Lbl = text(ax, mean(roi{:}.x), mean(roi{:}.y), roi{:}.Name, ... % Label region of interest
        'BackgroundColor', 'k', ...
        'Color', 'w' ...
        ); 
end

%% Plot eye movement
trace = line(ax, x(i), screen.Height-y(i), ... % Create a line to show path of eye movement
    'Color', 'red', ...
    'LineWidth', 2 ...
    );
fix = scatter(ax, x(i & [data.fix]), screen.Height-y(i & [data.fix]), ... % Create scatter points at each fixation
    'Marker', 'o', ...
    'LineWidth', 2, ...
    'SizeData', 72, ...
    'MarkerEdgeColor', 'red', ...
    'MarkerFaceColor', 'white' ...
    );

end