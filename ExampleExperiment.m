w = figure;
w.InnerPosition = get(groot, 'ScreenSize');
ax = axes(w, 'Position', [0, 0, 1, 1]);
ax.TickLength = [0 0];
ax.XLim = [0, w.Position(3)];
ax.YLim = [0, w.Position(4)];
set(ax, 'FontName', 'Verdana'); % Change font
set(ax,'Color',[0.97, 0.97, 0.99]) % Grey background
set(ax, 'Box', 'off');
hold on

im = image(ax, ...
    'XData', [200, 200+561], ...
    'YData', [200, 200+632], ...
    'CData', flipud(imread('AH00.PNG')));
drawnow

data = EyeTribeRun(6555, 10, 5);
close all

EyeTribePlot(data, 'AH00.PNG', [200,200,561,632])