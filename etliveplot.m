function [data] = etliveplot(sock, lat)
sDim = get(groot, 'ScreenSize'); % Get screen dimensions
fig = figure('InnerPosition', sDim); % Create full screen figure

%% Create axis
sDim = get(groot, 'ScreenSize'); % Get screen size
ax = axes(... % Create axis
    'Position', [0, 0, 1, 1], ... % Fill window
    'NextPlot', 'add', ... % Keep plots when drawing new ones
    'XLim', sDim([1, 3]), ... % X limits to window width (pixels)
    'YLim', sDim([2, 4]), ... % X limits to window width (pixels)
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

trace = line(ax, repmat(mean(ax.XLim), 1, lat), repmat(mean(ax.YLim), 1, lat), ...
    'Color', 'red', ...
    'LineWidth', 2 ...
    );
fix = scatter(ax, repmat(mean(ax.XLim), 1, lat), repmat(mean(ax.YLim), 1, lat), ...
    'Marker', 'o', ...
    'LineWidth', 2, ...
    'SizeData', 72, ...
    'MarkerEdgeColor', 'red', ...
    'MarkerFaceColor', 'white' ...
    );
drawnow

data = [];
while ishandle(fig)
    val = etgetval(sock);
    
    trace.XData = [fix.XData(2:end), val.avg.x];
    trace.YData = [fix.YData(2:end), ax.YLim(2) - val.avg.y];
    
    if val.fix
        fix.XData = [fix.XData(2:end), val.avg.x];
        fix.YData = [fix.YData(2:end), ax.YLim(2) - val.avg.y];
    else
        fix.XData = [fix.XData(2:end), NaN];
        fix.YData = [fix.YData(2:end), NaN];
    end
    drawnow
    
    data = [data, val];
end
