function output = etcsv(data, path)
% Function to extract specific fields from EyeTribe data output and export
% them as a csv
% data = EyeTribe data
% output = Matlab table which will be saved to a csv



%% Save as a csv
if ~exist(path, 'var')
    folder = uigetdir();
    fname = inputdlg('Name data file', 'Name data file', 1, {'ETdata'});
    path = [folder '\' fname{:} '.csv'];
end
    
writetable(output, path);