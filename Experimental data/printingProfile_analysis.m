%% Be careful, this first bit clears the workspace completely
clear, close, clc

%% Select image of interest
[filename, pathname] = uigetfile('*.*','Pick a file');
addpath(genpath(pathname));
cd(pathname)

% You could expand this to go through a whole folder for a more automated
% analysis, but for now let's just give you manual baby steps.

%% Display image and select a region of interest
image = imadjust(rgb2gray(imread(filename)));
figure, imshow(image)

% Overlays a box, you select a region, double click to use that ROI
hBox = imrect;
roiPosition = wait(hBox);

% Get that box's coordinates and crop image accordingly
indRowROI = round([roiPosition(2), roiPosition(2), ...
    roiPosition(2)+roiPosition(4), roiPosition(2)+roiPosition(4)]);
indColROI = round([roiPosition(1), roiPosition(1)+roiPosition(3), ...
    roiPosition(1)+roiPosition(3), roiPosition(1)]);
close

imageROI = image(indRowROI(1):indRowROI(3),indColROI(1):indColROI(2));

% Display image you will now be working with
imshow(imageROI)

%% Real basic profile detection
[imageHeight, imageWidth] = size(imageROI);

% Threshold the image, turn it into a binary image
% Suitable GTS: H0.26(0.7), H0.25(0.7), H0.24(0.8),H0.23(0.8), H0.22(1), H0.21(0.8)
% H0.2(0.9)
graythreshScaling = 0.8;
imageROI_BW = im2bw(imageROI,graythresh(imageROI)*graythreshScaling);

% Go through each row, find the first and last black pixels
for indRow = 1:imageHeight
    row = imageROI_BW(indRow,:);
    wallLeft(indRow) = find(row==0,1,'first');
    wallRight(indRow) = find(row==0,1,'last');
end

MM_PER_PIXEL = 0.5/(2016-1531);
width = (wallRight-wallLeft)*MM_PER_PIXEL;

%generate length array accordingly
length=0:1:(length(width)-1);
length=length*MM_PER_PIXEL;

plot(length,width,'k')
title('Width Vs. Length');

% Show the wall edges
figure
Con_WallLeft=wallLeft*MM_PER_PIXEL;
Con_WallRight=wallRight*MM_PER_PIXEL;
%hold on, plot(length,wallLeft,'k'), plot(length,wallRight,'k');
plot(length,Con_WallLeft,'r',length,Con_WallRight,'b');
legend('Wallleft','Wallright');
title('Wallleft and Wallright plot');


% Calculate the area of the black pixels
%require user input of the current LayerHeight in the unit of mm.
prompt = 'What is the current LayerHeight in mm?';
LayerHeight = input(prompt);
[Average_area, StdDeviation] = get_averageArea(imageHeight, wallLeft, wallRight, LayerHeight);



%% Fitting a circle to single wall edges demonstration
indicesR = 1:246;
wR = wallRight(indicesR);

[xc,yc,rFit] = circfit(indicesR,wR);

theta = 0:pi/64:pi;
xFit = xc + rFit*cos(theta);
yFit = yc + rFit*sin(theta);

figure
subplot(2,1,1), plot(xFit,yFit,'r-','LineWidth',2);
hold on, plot(indicesR,wR,'ko','LineWidth',2)
title('Right wall, circle fit')
set(gca,'FontSize',16)


indicesL = 1:233;
wL = wallLeft(indicesL);

[xc,yc,rFit] = circfit(indicesL,wL);

theta = pi:pi/64:2*pi;
xFit = xc + rFit*cos(theta);
yFit = yc + rFit*sin(theta);

subplot(2,1,2)
plot(xFit,yFit,'r-','LineWidth',2);
hold on, plot(indicesL,wL,'ko','LineWidth',2)
title('Left wall, circle fit')
set(gca,'FontSize',16)


%% Fitting an eclipse to both wall edges demonstration
[semimajor_axis, semiminor_axis, x0, y0, phi] = ellipse_fit(inds,edges);

xc = x0;
yc = y0;
a = semimajor_axis;
b = semiminor_axis;
alpha = phi;

t = 0:pi/200:2*pi;

xu = a*cos(t);
yv = b*sin(t);

xx = xu*cos(-alpha) - yv*sin(-alpha);
yy = xu*sin(-alpha) + yv*cos(-alpha);

x = xc + xx; 
y = yc + yy;

plot(x,y,'r-','LineWidth',2)
hold on, plot(inds,edges,'ko','LineWidth',2)
title('Fitting an Ellipse')
set(gca,'FontSize',16)







%{
%% Single threshold - Don't need this, just for demonstration

thresh = graythresh(image);

levelPercent = 0.1:0.1:2;

figure('units','normalized','outerposition',[0 0 1 1])
for indImage = 1:length(levelPercent)
    imageBW = im2bw(image,thresh*levelPercent(indImage));
    subplot(4,5,indImage), imshow(imageBW)
    title(strcat(num2str(levelPercent(indImage)*100),'% of graythresh'))
end

%% Multithreshold - Don't need this, just for demonstration

threshLevel = 1:12;
figure('units','normalized','outerposition',[0 0 1 1])
for indThresh = 1:length(threshLevel)
    thresh = multithresh(image,threshLevel(indThresh));
    Iseg = imquantize(image,thresh);
    RGB = label2rgb(Iseg);
    subplot(3,4,indThresh), imshow(RGB)
    title(strcat(num2str(indThresh),' threshold levels'))
end


%%
%}
