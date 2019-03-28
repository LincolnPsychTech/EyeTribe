function fig = EyeTribePlot(data, stimdir, stimpos)
    i = ~any([isoutlier(data.values.avg.x) isoutlier(data.values.avg.y)],2);
    x = data.values.avg.x(i);
    y = data.values.avg.y(i);
    screendim = data.screen;
    
    
    
    fig = figure;
    fig.InnerPosition = [0, 0, screendim];
    
    ax = axes(fig, 'Position', [0, 0, 1, 1]);
    ax.TickLength = [0 0];
    ax.XLim = [0, screendim(1)];
    ax.YLim = [0, screendim(2)];
    set(ax, ...
        'FontName', 'Verdana', ... % Nicer font
        'Color', [0.97, 0.97, 0.99], ... % Grey background
        'Box', 'off' ...
        ); % Format axis
    set(ax, ... % Add gridlines
        {'YGrid' 'YMinorGrid' 'XGrid' 'XMinorGrid'}, ...
        {'on' 'on' 'on' 'on'} ...
        ); 
    set(ax, ... % Format gridlines
        {'GridAlpha' 'MinorGridAlpha' 'MinorGridLineStyle' 'GridColor' 'MinorGridColor'}, ...
        {1           1                '-'                  'white'     'white'}...
        );
    hold on
    
    [img, map, alpha] = imread(stimdir);
    
    im = image(ax, ...
        'XData', [stimpos(1), stimpos(1)+stimpos(3)], ...
        'YData', [stimpos(2), stimpos(2)+stimpos(4)], ...
        'CData', flipud(img), ...
        'AlphaData', flipud(alpha));
    
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