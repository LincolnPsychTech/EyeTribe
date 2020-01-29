function output = etextract(data, varargin)
%Extract specific fields from ET data and save to a flat csv

output = table();

for field = varargin
    fsplt = strsplit(field{:}, '.');
    lvl = data;
    for f2 = fsplt
        lvl = [lvl.(f2{:})];
    end
    output = [output, table(lvl', 'VariableNames', join(fsplt, '_'))];
    
    path = uigetdir();
    fname = inputdlg('Name data file', 'Name data file', 1, {'ETdata'});
    writetable(output, [path '\' fname{:} '.csv']);
    
end