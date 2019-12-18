function [fig, ax] = etwindow(col)

sDim = get(groot, 'ScreenSize'); % Get screen dimensions

fig = figure('InnerPosition', sDim); % Create full screen figure

ax = axes(fig, ... % Create axis within figure
    'Position', [0, 0, 1, 1], ... % Occupy entire figure
    'XLim', sDim([1,3]), ... % X limits are width of screen in pixels
    'YLim', sDim([2,4]), ... % Y limits are height of screen in pixels
    'Color', col, ... % Colour defined by user
    'TickLength', [0 0], ... % Remove ticks
    'Box', 'off' ... % Remove box
    );

