function ax = fullscreenwindow
w = figure;
w.InnerPosition = get(groot, 'ScreenSize');
ax = axes(w, 'Position', [0, 0, 1, 1]);
ax.TickLength = [0 0];
ax.XLim = [0, w.Position(3)];
ax.YLim = [0, w.Position(4)];
set(ax, 'Box', 'off');
