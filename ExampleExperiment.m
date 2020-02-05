[sock, screen] = etconnect(6555);
[ax, fig] = etwindow();
stim = etstim(ax, 'test.png', [], [], [], []);
txt = etstim(ax, 'test.txt', [], [], [], []);
drawnow
data = etrun(sock, 30);
close(fig);
etdisconnect(sock);
fig2 = etplot(data, screen, stim, txt);