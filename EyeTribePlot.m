function fig = EyeTribePlot(data, stimdir, stimpos)
    x = data.values.avg.x;
    y = data.values.avg.y;
    screendim = data.screen;
    
    fig = figure;
    fig.InnerPosition = [0, 0, screendim];
    
    ax = axes(fig, 'Position', [0, 0, 1, 1]);
    ax.TickLength = [0 0];
    ax.XLim = [0, screendim(1)];
    ax.YLim = [0, screendim(2)];
    set(ax, 'FontName', 'Verdana'); % Change font
    set(ax,'Color',[0.97, 0.97, 0.99]) % Grey background
    set(ax, 'YGrid', 'on'); % Add horizontal gridlines
    set(ax, 'YMinorGrid', 'on'); % Add horizontal gridlines
    set(ax, 'XGrid', 'on'); % Add vertical gridlines
    set(ax, 'XMinorGrid', 'on'); % Add vertical gridlines
    set(ax, 'GridColor', 'white'); % Make gridlines white
    set(ax, 'GridAlpha', 1); % Make gridlines opaque
    set(ax, 'MinorGridColor', 'white'); % Make gridlines white
    set(ax, 'MinorGridAlpha', 1); % Make gridlines opaque
    set(ax, 'MinorGridLineStyle', '-'); % Make gridlines opaque
    set(ax, 'Box', 'off');
    hold on
    
    im = image(ax, ...
        'XData', [stimpos(1), stimpos(1)+stimpos(3)], ...
        'YData', [stimpos(2), stimpos(2)+stimpos(4)], ...
        'CData', flipud(imread(stimdir)));
    
    trace = line(ax, x, screendim(2)-y);
    trace.Color = 'red';
    trace.LineWidth = 2;
    trace.Marker = 'o';
    trace.MarkerSize = 8;
    trace.MarkerFaceColor = 'white';
    
    
    %% Resize to fit screen
    sd = get(groot, 'ScreenSize');
    if any(fig.OuterPosition([3,4]) > sd([3,4]) - 100)
        scale = (sd([3,4])-100) ./ fig.OuterPosition([3,4]);
        fig.OuterPosition([3,4]) = fig.OuterPosition([3,4]) * min(scale);
    end
    
    movegui('center')
end