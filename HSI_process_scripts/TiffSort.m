function TiffSort(Date)
% sorts the individual tiff files into folders according to name
% ex: TiffSort('Jun29')
% you should be in the directory when you execute this function
% ex: be in the Jun29 function when you execute TiffSort('Jun29')


directoryRead = dir(['../',Date]);
%fileNames = directoryRead.name;

directoryRead = directoryRead(arrayfun(@(x)x.name(1),
    directoryRead) ~='.'); %remove hidden files

directoryRead = directoryRead(arrayfun(@(x)x.name(1), directoryRead) ~='.');

FileID = directoryRead(1).name(1:18)
mkdir(FileID)

for i = 1:length(directoryRead)
    if directoryRead(i).name(1:18) == FileID
        movefile(directoryRead(i).name, FileID)
        i = i+1
    else
        FileID = directoryRead(i).name(1:18)
        mkdir(FileID)
        i = i+1
    end
end

    
    
