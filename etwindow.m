function [ax, fig] = etwindow(sDim, col)
% Function to create a fullscreen window for plotting stimuli to.
% ax = Axis to plot to
% fig = Figure object containing window
% col = Background colour [r, g, b]
% X and Y limits of ax will be set to the dimensions of the screen,
% background colour will default to [0.5, 0.5, 0.5] if none is specified

if ~exist('sDim', 'var') % If user did not specify screen dim...
    sDim = get(groot, 'ScreenSize'); % Get screen dimensions
end
if ~exist('col', 'var') % If user did not specify colour...
    col = [0.5 0.5 0.5]; % Default to 0.5 grey
end

fig = figure('InnerPosition', sDim); % Create full screen figure

ax = axes(fig, ... % Create axis within figure
    'Position', [0, 0, 1, 1], ... % Occupy entire figure
    'XLim', sDim([1,3]), ... % X limits are width of screen in pixels
    'YLim', sDim([2,4]), ... % Y limits are height of screen in pixels
    'Color', col, ... % Colour defined by user
    'TickLength', [0 0], ... % Remove ticks
    'Box', 'off' ... % Remove box
    );

