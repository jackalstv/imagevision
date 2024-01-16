%%% Détection de contours droits par transformée de Hough %%%
clear all; close all;

I = imread('carte.png');
if length(size(I))==3
    I=rgb2gray(I); % conversion en niveaux de gris
end
figure(1), imshow(I); title('Image d''origine');

% Détection de contours 
Ic = edge(I,'sobel',.1);
figure(2), imshow(Ic); title('Image de contours');

% Construction table de Hough
[H,T,R] = hough(Ic,'RhoResolution',3,'ThetaResolution',2);
figure(3), imshow(imadjust(mat2gray(H)),'XData',T,'YData',R);
title('Hough transform table'); xlabel('\theta'), ylabel('\rho'); axis on, axis normal, hold on;

% Ecrétage et affichage maxima sur la table de Hough
P = houghpeaks(H,15);
hold on, plot(T(P(:,2)),R(P(:,1)),'s','color','red');

% Lignes correspondant aux pics (au moins 75 pixels de longueur,
% Comblement des lacunes inférieures à 5 pixels pour former des segments
% plus longs )
lines = houghlines(Ic,T,R,P,'FillGap',5,'MinLength',75);

% Tracer sur l'image d'origine
figure(1), hold on;
for k=1:length(lines)
      xy = [lines(k).point1; lines(k).point2];
      plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
