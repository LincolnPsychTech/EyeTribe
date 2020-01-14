function [data] = etliveplot(sock, ax, lat)
% Plot EyeTribe data as it is received.

%% Format axis
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
set(ax, ...
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
drawnow

data = [];
while ishandle(ax.Parent)
    
    val = etgetval(sock);
    if isnan(val)
        warning('Data not gathered this frame');
    else
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
    
    
    
end
