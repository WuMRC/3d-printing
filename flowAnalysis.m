%% STEP 1 - Get video file
% Get video for analysis
[videoInfo.filename, videoInfo.pathname] = ...
    uigetfile('*.mp4;*.avi','Pick a video file');
addpath(genpath(videoInfo.pathname))

videoFile = VideoReader(videoInfo.filename);


%% STEP 2 - Look through frames/regions of interest
implay(videoInfo.filename)

% Select region of interest
figure, imshow(read(videoFile,1))

hBox = imrect;
roiPosition = wait(hBox);

% roiPosition;
roi_xind = round([roiPosition(2), roiPosition(2), ...
    roiPosition(2)+roiPosition(4), roiPosition(2)+roiPosition(4)]);
roi_yind = round([roiPosition(1), roiPosition(1)+roiPosition(3), ...
    roiPosition(1)+roiPosition(3), roiPosition(1)]);
close

video = read(videoFile);
videoROI = video(roi_xind(1):roi_xind(3),roi_yind(1):roi_yind(2),1,:);


videoROI = permute(videoROI,[1 2 4 3]);
%% STEP 3 - FIND DIAMETER OVER TIME

implay(videoROI)

x = uint8(kalmanStack(double(videoROI),0.9,0.5);

PIXEL_PER_MM = 1;
FRAMES_PER_SECOND = 30;

nFrame = size(x,3);
for indFrame = 1:nFrame
    level(indFrame) = graythresh(x(:,:,indFrame));
    videoBW(:,:,indFrame) = im2bw(x(:,:,indFrame),level(indFrame));
    diameter(indFrame) = sum((videoBW(5,:,indFrame)==0))/PIXEL_PER_MM;

end

time = (1:nFrame)./FRAMES_PER_SECOND;

plot(time,diameter);
