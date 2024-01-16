clear all
close all

I_0 = imread('image2.bmp');
figure(1);
imshow(I_0);
title('Image originale');

figure(2);
mesh(double(I_0(:,:,1)));
figure(3);
mesh(double(I_0(:,:,2)));
figure(4);
mesh(double(I_0(:,:,3)));