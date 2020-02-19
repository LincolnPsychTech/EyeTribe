function [ax, fig] = etwindow(screen, col)
% Function to create a fullscreen window for plotting stimuli to.
% ax = Axis to plot to
% fig = Figure object containing window
% col = Background colour [r, g, b]
% X and Y limits of ax will be set to the dimensions of the screen,
% background colour will default to [0.5, 0.5, 0.5] if none is specified

if ~exist('sDim', 'var') % If user did not specify screen dim...
    screen = get(groot, 'ScreenSize'); % Get screen dimensions
end
if ~exist('col', 'var') % If user did not specify colour...
    col = [0.5 0.5 0.5]; % Default to 0.5 grey
end
if all( isfield(screen, {'Width', 'Height'}) )
    screen = [1 1 screen.Width screen.Height];
end

fig = figure(... % Create full screen figure
    'InnerPosition', screen, ... % Fullscreen figure
    'KeyPressFcn', @keyFcn, ... % Create keypress listener
    'WindowButtonDownFcn', @clickFcn, ... % Create click listener 
    'SizeChangedFcn', @sizeFcn, ... % Function to match axis limits of fullscreen axes to figure size
    'CloseRequestFcn', @closeFcn, ... % Function to save data on close
    'UserData', struct(...
        'Key', [], ...
        'Click', [], ...
        'Store', [] ...
        ) ...
    );

ax = axes(fig, ... % Create axis within figure
    'Position', [0 0 1 1], ... % Occupy entire figure
    'XLim', screen([1,3]), ... % X limits are width of screen in pixels
    'YLim', screen([2,4]), ... % Y limits are height of screen in pixels
    'Color', col, ... % Colour defined by user
    'TickLength', [0 0], ... % Remove ticks
    'Box', 'off' ... % Remove box
    );




    function keyFcn(app, event)
        app.UserData.Key = event.Key; % Store last key to user data
        if strcmp(event.Key, 'escape')
            close(app);
            error('Experiment terminated by user.')
        end
    end

    function clickFcn(app, ~)
        axArray = findobj(app.Children, 'Type', 'axes', 'Position', [0 0 1 1]); % Find all full screen axes
        app.UserData.Click = get(axArray, 'CurrentPoint'); % Store mouse position to user data
    end

    function sizeFcn(app, ~)
        axArray = findobj(app.Children, 'Type', 'axes', 'Position', [0 0 1 1]); % Find all full screen axes
        for a = axArray' % For each axis...
            set(a, ...
                'XLim', [0, app.Position(3)], ... % Match XLim to figure width
                'YLim', [0, app.Position(4)] ... % Match YLim for figure height
                );
        end
    end

    function closeFcn(app, ~)
        disp('Experiment terminated by user.');
        delete(app)
    end
end

