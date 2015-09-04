function EvalEdgeDetection(Directory,Filename)
% Example: EvaluateEdgeDetection_UsingRadianceData('Flounders/Blue','20150814104945.840_31ms.3d_31.00ms')
% Example: EvaluateEdgeDetection_UsingRadianceData('Flounders/Gravel','20150724110559.555_33ms.3d_33.00ms')
% Example: EvaluateEdgeDetection_UsingRadianceData('Flounders/Sand','20150730101055.833_42ms.3d_42.00ms')

load Buzzard4Cones.dat; % 4x16 (V,S,M,L) % load Buzzard4Cones.dat; % 1x16
load ChickenDoubleCone.dat; % 1x16 (very similar to PekinRobinDoubleCone, but more realistic) 
ChickenDoubleCone = ChickenDoubleCone/100; % make sensitivity range from 0 to 1
WaveNumber = ['360nm', '380nm', '405nm', '420nm', '436nm', '460nm', '480nm', '500nm', '520nm', '540nm', '560nm', '580nm', '600nm', '620nm', '640nm', '660nm'];

FishMask = importdata(['Masks/AnimalMask_SegImg_', Filename, '.png.mat'], 1);
RefObjectImg = importdata([Directory, '/', Filename], 1);

% figure
for i = 1:16
    TempImg = RefObjectImg(:,:,i);
    inx1 = find(TempImg > 1); % find reflectance larger than one
    TempImg(inx1) = 1; % make reflectance larger than one equal 1 
    inx_nan = isnan(TempImg); % find NaN in the image file
    inx2 = find(inx_nan == 1);
    TempImg(inx2) = 0; % make reflectance NaN (because of noise) equal 0
    RefObjectImg(:,:,i) = TempImg; % reflectance range 0-1
%     subplot(4,4,i), imshow(RefObjectImg(:,:,i)); title(WaveNumber((i-1)*5+1:i*5));
end
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 1,'\bf Radiance images of 16 bands','HorizontalAlignment','center','VerticalAlignment', 'top');

for i = 1:16
    Uimg(:,:,i) = RefObjectImg(:,:,i)*Buzzard4Cones(1,i); % use Up direction of light field
    Simg(:,:,i) = RefObjectImg(:,:,i)*Buzzard4Cones(2,i);
    Mimg(:,:,i) = RefObjectImg(:,:,i)*Buzzard4Cones(3,i);
    Limg(:,:,i) = RefObjectImg(:,:,i)*Buzzard4Cones(4,i);
    Dimg(:,:,i) = RefObjectImg(:,:,i)*ChickenDoubleCone(i); % double cone
end

Ucone = sum(Uimg,3); % summation across all wavelengths
Scone = sum(Simg,3);
Mcone = sum(Mimg,3);
Lcone = sum(Limg,3);
Dcone = sum(Dimg,3);

% figure
% RadImg(:,:,1) = Lcone;
% RadImg(:,:,2) = Mcone;
% RadImg(:,:,3) = Scone;
% imshow(RadImg);

% x90 = prctile(Lcone(:),90)
% x50 = prctile(Lcone(:),50)

for i = 1:16
    Background(i) = mean2(RefObjectImg(:,:,i)); % average all reflectance spectra across the entire image
end

WhiteSurface = ones(1,16); % white surface for normalization purpose
BlackSurface = 0.01*ones(1,16); % black surface for normalization purpose

for i = 1:16
    U_bk(i) = Background(i)*Buzzard4Cones(1,i); 
    S_bk(i) = Background(i)*Buzzard4Cones(2,i);
    M_bk(i) = Background(i)*Buzzard4Cones(3,i);
    L_bk(i) = Background(i)*Buzzard4Cones(4,i);
    D_bk(i) = Background(i)*ChickenDoubleCone(i);
    U_White(i) = WhiteSurface(i)*Buzzard4Cones(1,i); 
    S_White(i) = WhiteSurface(i)*Buzzard4Cones(2,i);
    M_White(i) = WhiteSurface(i)*Buzzard4Cones(3,i);
    L_White(i) = WhiteSurface(i)*Buzzard4Cones(4,i);
    D_White(i) = WhiteSurface(i)*ChickenDoubleCone(i);
    U_Black(i) = BlackSurface(i)*Buzzard4Cones(1,i); 
    S_Black(i) = BlackSurface(i)*Buzzard4Cones(2,i);
    M_Black(i) = BlackSurface(i)*Buzzard4Cones(3,i);
    L_Black(i) = BlackSurface(i)*Buzzard4Cones(4,i);
    D_Black(i) = BlackSurface(i)*ChickenDoubleCone(i);
end

% make the quantal catch 0 equal the black surface quantal catch (to avoid log problem)
inxU = find(Ucone == 0);
Ucone(inxU) = sum(U_Black);
inxS = find(Scone == 0);
Scone(inxS) = sum(S_Black);
inxM = find(Mcone == 0);
Mcone(inxM) = sum(M_Black);
inxL = find(Lcone == 0);
Lcone(inxL) = sum(L_Black);
inxD = find(Dcone == 0);
Dcone(inxD) = sum(D_Black);

UconeAdp = log(Ucone/sum(U_bk)); % adapted to background and log-transformed (Ln)
SconeAdp = log(Scone/sum(S_bk)); 
MconeAdp = log(Mcone/sum(M_bk)); 
LconeAdp = log(Lcone/sum(L_bk)); 
DconeAdp = log(Dcone/sum(D_bk)); 

% normalized to a range from 0 to 1 (for display purpose), using black and white surfaces
UconeAdpNorm = (UconeAdp - log(sum(U_Black)/sum(U_bk)))/(log(sum(U_White)/sum(U_bk)) - log(sum(U_Black)/sum(U_bk)));
SconeAdpNorm = (SconeAdp - log(sum(S_Black)/sum(S_bk)))/(log(sum(S_White)/sum(S_bk)) - log(sum(S_Black)/sum(S_bk)));
MconeAdpNorm = (MconeAdp - log(sum(M_Black)/sum(M_bk)))/(log(sum(M_White)/sum(M_bk)) - log(sum(M_Black)/sum(M_bk)));
LconeAdpNorm = (LconeAdp - log(sum(L_Black)/sum(L_bk)))/(log(sum(L_White)/sum(L_bk)) - log(sum(L_Black)/sum(L_bk)));
DconeAdpNorm = (DconeAdp - log(sum(D_Black)/sum(D_bk)))/(log(sum(D_White)/sum(D_bk)) - log(sum(D_Black)/sum(D_bk)));

% % normalized to a range no larger than 1 (for display purpose), using only white surface
% UconeAdpNorm = UconeAdp/log(sum(U_White)/sum(U_bk));
% SconeAdpNorm = SconeAdp/log(sum(S_White)/sum(S_bk));
% MconeAdpNorm = MconeAdp/log(sum(M_White)/sum(M_bk));
% LconeAdpNorm = LconeAdp/log(sum(L_White)/sum(L_bk));
% DconeAdpNorm = DconeAdp/log(sum(D_White)/sum(D_bk));

figure
imshow(DconeAdpNorm); title('Double cone');

% Edge detection (Laplacian of Gaussian (Stevens and Cuthill, PRSB 2006)
img1=edge_Otsu(DconeAdpNorm,'log',[],0.5); % adaptive thresholding (Otsu, 1979)
img2=edge_Otsu(DconeAdpNorm,'log',[],1);
img3=edge_Otsu(DconeAdpNorm,'log',[],1.5);
img4=edge_Otsu(DconeAdpNorm,'log',[],2);
img5=edge_Otsu(DconeAdpNorm,'log',[],2.5);
img6=edge_Otsu(DconeAdpNorm,'log',[],3);
img7=edge_Otsu(DconeAdpNorm,'log',[],3.5);
img8=edge_Otsu(DconeAdpNorm,'log',[],4);
img9=edge_Otsu(DconeAdpNorm,'log',[],4.5);
img10=edge_Otsu(DconeAdpNorm,'log',[],5);
img11=edge_Otsu(DconeAdpNorm,'log',[],5.5);
imgp1 = img1 & img2;
imgp2 = img2 & img3;
imgp3 = img3 & img4;
imgp4 = img4 & img5;
imgp5 = img5 & img6;
imgp6 = img6 & img7;
imgp7 = img7 & img8;
imgp8 = img8 & img9;
imgp9 = img9 & img10;
imgp10 = img10 & img11;
Dcone_img = double(imgp1+imgp2+imgp3+imgp4+imgp5+imgp6+imgp7+imgp8+imgp9+imgp10)./10;

figure
imshow(Dcone_img); title('Edge detection using Laplacian of Gaussian model');

CombinedImg(:,:,1) = DconeAdpNorm + Dcone_img;
CombinedImg(:,:,2) = DconeAdpNorm + Dcone_img;
CombinedImg(:,:,3) = DconeAdpNorm;

figure
imshow(CombinedImg);

BWoutline = bwperim(FishMask,8);  % get animal outline
DetectedEdge = (BWoutline + Dcone_img) > 1;  % detected edge segments fall on the animal outline
figure, imshow(BWoutline);
figure, imshow(DetectedEdge);
PercentEdge1pixel = sum(DetectedEdge(:))/sum(BWoutline(:))

SE = strel('square', 3);  % 3 and 5 are good values here (symmetrical dilation)
BWoutline3pixel = imdilate(BWoutline, SE);
DetectedEdge3pixel = (BWoutline3pixel + Dcone_img) > 1;
figure, imshow(DetectedEdge3pixel);
PercentEdge1pixe3 = sum(DetectedEdge3pixel(:))/sum(BWoutline3pixel(:))

SE = strel('square', 5);  % 3 and 5 are good values here (symmetrical dilation)
BWoutline5pixel = imdilate(BWoutline, SE);
DetectedEdge5pixel = (BWoutline5pixel + Dcone_img) > 1;
figure, imshow(DetectedEdge5pixel);
PercentEdge1pixe5 = sum(DetectedEdge5pixel(:))/sum(BWoutline5pixel(:))

DetectedEdge_LRflipped = (fliplr(BWoutline) + Dcone_img) > 1;
figure, imshow(fliplr(BWoutline));
figure, imshow(DetectedEdge_LRflipped);
PercentEdgeLRflipped = sum(DetectedEdge_LRflipped(:))/sum(BWoutline(:))

end