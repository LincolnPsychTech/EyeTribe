[sock, screen] = etconnect(6555);
[fig, ax] = etwindow([0.8 0.8 0.8]);
stim = etstim(ax, 'test.png', [], [], [], []);
txt = etstim(ax, 'test.txt', [], [], [], []);
drawnow
data = etrun(sock, 30);
close(fig);
etdisconnect(sock);
fig2 = etplot(data, screen, stim, txt);