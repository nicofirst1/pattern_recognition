clc;
clear;

%% getting data

img =imread('/Users/giulia/Desktop/pr/Resources/lab4-data/HeadTool0002.bmp');
img=im2double(img);
clahe = adapthisteq(img,'clipLimit',0.4,'Distribution','rayleigh','NumTiles',[16,16]);
[centers, radii, metric] = imfindcircles(clahe,[20,100]);



%% Question 2

if 0

    centers=centers(1:2,:);
    radii=radii(1:2,:);
   
end

%% Plot image
%imshowpair(img,clahe,'montage');
imshow(clahe)
viscircles(centers, radii,'EdgeColor','b');
title("S4171632\_S2843013");

