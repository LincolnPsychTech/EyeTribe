function fig = EyeTribePlot(data, stimdir, stimpos)
    i = ~any([isoutlier(data.values.avg.x) isoutlier(data.values.avg.y)],2);
    x = data.values.avg.x(i);
    y = data.values.avg.y(i);
    screendim = data.screen;

    fig = figure;
    set(fig, ...
        'InnerPosition', [0, 0, screendim]...
        );
    
    ax = axes(fig);
    set(ax, ... % Format axis
        'Position', [0, 0, 1, 1], ... % Fill window
        'NextPlot', 'add', ... % Keep plots when drawing new ones
        'XLim', [0, screendim(1)], ... % X limits to window width (pixels)
        'YLim', [0, screendim(2)], ... % X limits to window width (pixels)
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

    [img, ~, alpha] = imread(stimdir);
    
    im = image(ax, ...
        'XData', [stimpos(1), stimpos(1)+stimpos(3)], ...
        'YData', [stimpos(2), stimpos(2)+stimpos(4)], ...
        'CData', flipud(img), ...
        'AlphaData', flipud(alpha));
    
    trace = line(ax, x, screendim(2)-y);
    set(trace, ...
        'Color', 'red', ...
        'LineWidth', 2, ...
        'Marker', 'o', ...
        'MarkerSize', 8, ...
        'MarkerFaceColor', 'white' ...
        );

    %% Resize to fit screen
    sd = get(groot, 'ScreenSize');
    if any(fig.OuterPosition([3,4]) > sd([3,4]) - 100)
        scale = (sd([3,4])-100) ./ fig.OuterPosition([3,4]);
        fig.OuterPosition([3,4]) = fig.OuterPosition([3,4]) * min(scale);
    end
    
    movegui('center')
end