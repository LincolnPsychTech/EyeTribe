clear all
close all

[sock, screen] = etconnect(6555); % Connect to EyeTribe
[ax, fig] = etwindow(); % Create window
stim = etstim(ax, 'example_image.png', [], [], [], []); % Draw image stimulus
stim.ROI = etroi('Image', ... % Define ROI for image stimulus...
    stim.Pos(1) + [0 0 stim.Pos(3) stim.Pos(3)], ... % ...image corner x coords (formatted to define a polygon)
    stim.Pos(2) + [0 stim.Pos(4) stim.Pos(4) 0] ... % ...image corner y coords (formatted to define a polygon)
    );
txt = etstim(ax, 'example_text.txt', [], [], [], []); % Draw text stimulus
txt.ROI = etroi('Text', ... % Define ROI for text stimulus...
    txt.Pos(1) + [0 0 txt.Pos(3) txt.Pos(3)], ... % ...text corner x coords (formatted to define a polygon)
    txt.Pos(2) + [0 txt.Pos(4) txt.Pos(4) 0] ... % ...text corner y coords (formatted to define a polygon)
    );
drawnow % Refresh window
data = etrun(sock, 30, stim.ROI, txt.ROI); % Run the EyeTribe for 30 seconds, with ROI's for the image and text
close(fig); % Close window
etdisconnect(sock); % Disconnect EyeTribe
fig2 = etplot(data, screen, stim, txt); % Plot trace on top of stimuli and ROI's
dataFlat = etcsv(data, 'example_data.csv'); % Flatten data and save as a csv

