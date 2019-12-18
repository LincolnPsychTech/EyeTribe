[sock, screen] = etconnect(6555);
[fig, ax] = etwindow([0.5 0.5 0.5]);
stim = etstim(ax, 'test.png', [], [], [], []);
drawnow
data = etrun(sock, 30);
fig2 = etplot(data, stim, screen);
