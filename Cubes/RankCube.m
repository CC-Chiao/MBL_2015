% script to pull out all the HSI data cubes ranked 4 and 5

% read rankings file into matlab
[num, txt, raw] = xlsread('Aug14 Rankings.xlsx', 'A1:C58');

% split first line file identifier into different folder names
Horatio = strsplit(char(raw(2, 1)), '/');

% create identifier to create necessary folders
% this will be compared to other strings to see when a new folder has to be
% made
folderID = sprintf('%s%s%s', Horatio{1}, '/', Horatio{2});
mkdir(['Highlights/', folderID]);
for i = 2:length(raw(:,1))
    
    filename = raw{i, 1};
    
    if strcmp(raw{i,3}, 'WHITE') == 1
        copyfile(filename, 'WHITE')
    else
        folderID = sprintf('%s%s', 'JuvFlounder #', num2str(raw{i, 3}));
        if raw{i, 2} == 4 | raw{i, 2} == 5
            copyfile(filename, folderID);
        end
    end
end
    
    % pull out row name ( = filepath)
    filename = raw{i, 1};
    foldername = raw{i, 3};
    
    % divide up into different directory names
%     parts = strsplit(filename, '/');
    
%     Date = parts{1};
%     FlounderID = parts{2};
%     CubeID = parts{3};
    if raw{i,2} ~= 'WHITE'
        newfolderID = sprintf('%s%s', 'JuvFlounder #', num2str(foldername));
    else
        newfolderID = 'WHITE'
    end
    
    
    % if the new Date/FlounderID folder already exists, do nothing
    % if it does not, make a new one and set it as the new filepath
%     if ~exist(newfolderID, 'dir')
%         mkdir(newfolderID);
%     end
    
%     if folderID(end) ~= newfolderID(end)
%         mkdir(['Highlights/', newfolderID]);
%         folderID = newfolderID;
%     end
    
%     Source = sprintf('%s%s%s', folderID, '/', CubeID);

    if newfolderID == 'WHITE'
        copyfile(filename, 'WHITE/');
    else
        if raw{i,2} == 4 | raw{i,2} == 5
            copyfile(filename, newfolderID)
%     if raw{i, 2} == 4 | raw{i, 2} == 5
%         copyfile(filename, newfolderID);
%     end
%     if raw{i, 2} == 'WHITE'
%         copyfile(filename, newfolderID);
%     end
    
end

% channel = sprintf('%s%d%s','chan',k+4*(j-1),'.tif');
