function ShowHSIimage(Date, Directory)
% Example: ShowHSIimage('Aug7','2014-08-07-14hr17min41sec')

WaveNumber = ['360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'];

for i = 1:16
    filename = [Date,'/',Directory,'/',Directory,'_',WaveNumber((i-1)*5+1:i*5),'_raw.tiff'];  
    Img(:,:,i) = imread(filename,'tiff');
end

ImgRGB(:,:,1) = Img(:,:,15); % 640nm
ImgRGB(:,:,2) = Img(:,:,10); % 540nm
ImgRGB(:,:,3) = Img(:,:,5);  % 436nm

UpBound = max(ImgRGB(:));
sc = 2^16/UpBound;
ScaledImgRGB = ImgRGB*sc;

figure
imshow(ScaledImgRGB);

Output_filename = [Date,'/',Directory,'/',Directory,'_','raw_all'];
save(Output_filename, 'Img');

Scaled256ImgRGB = uint8(ScaledImgRGB/256);
Output_filename_img = [Date,'/',Directory,'/',Directory,'_raw_RGB.tiff'];
imwrite(Scaled256ImgRGB, Output_filename_img, 'tiff');
end