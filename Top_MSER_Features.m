clc
clear all
close all
%%
[fname1,pname1]=uigetfile('*.jpg','Select Input Scene Image');
u1a=imread(strcat(pname1,fname1));
figure,imshow(u1a)
title 'Input Image'
%%
[fname2,pname2]=uigetfile('*.jpg','Select Input Target Image');
u2a=imread(strcat(pname2,fname2));
figure;imshow(u2a);
title('Image of a Cluttered Scene');
%% 
if ndims(u1a)==3
    u1=rgb2gray(u1a);
else
    u1=u1a;
end
figure,imshow(u1)
title 'Scene Image in GrayScale form'

if ndims(u2a)==3
    u2=rgb2gray(u2a);
else
    u2=u2a;
end
figure,imshow(u2)
title 'Target Image in GrayScale form'

%% MSER
u3 = detectMSERFeatures(u1);
u4 = detectMSERFeatures(u2);
%% 
figure;
imshow(u1);
title('Feature Points from Target Image');
hold on;
plot(u3);

figure;
imshow(u2)
title('Feature Points from Target Image');
hold on;
plot(u4);
%% 
[boxFeatures, boxPoints] = extractFeatures(u1, u3);
[sceneFeatures, scenePoints] = extractFeatures(u2, u4);
boxPairs = matchFeatures(boxFeatures, sceneFeatures);

matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);

[tform, inlierBoxPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');

figure;
showMatchedFeatures(u1, u2, matchedBoxPoints, ...
    matchedScenePoints, 'montage');
title('Exactly Matched Points (Including Outliers)');


boxPolygon = [1, 1;...                           % top-left
        size(u1, 2), 1;...                 % top-right
        size(u1, 2), size(u1, 1);... % bottom-right
        1, size(u1, 1);...                 % bottom-left
        1, 1]; 
    
    
    detect_box = transformPointsForward(tform, boxPolygon);
    
figure;
imshow(u2);
hold on;
line(detect_box(:, 1), detect_box(:, 2), 'Color', 'r');
title('Detected Box');
