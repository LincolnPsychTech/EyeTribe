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

[img, map, alpha] = imread('chartest.png');

im = image(ax, ...
    'XData', [200, 200+900], ...
    'YData', [200, 200+400], ...
    'CData', flipud(img), ...
    'AlphaData', flipud(alpha));
drawnow

data = EyeTribeRun(6555, 10, 5);
close all

EyeTribePlot(data, 'chartest.png', [200,200,900,400])