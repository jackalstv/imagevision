clear all; close all;

I = imread('oeil.png');
if length(size(I))==3
    I=rgb2gray(I); % conversion en niveaux de gris
end
figure(1), imshow(I); title('Image d''origine');

% D�tection de contours 
Ic = edge(I,'canny',.01);
figure(2), imshow(Ic); title('Image de contours');

% Table de Hough � 3 diemensions : centres + rayons (Xc, Yc, r)
r = 20:1:100; % On limite la recherche � des rayons entre 15 et 60 pixels (� ajuster selon contexte)
h = circle_hough(Ic, r, 'same', 'normalise');

% Ecr�tage et affichage sur la table de Hough (15 meilleurs cercles max)
peaks = circle_houghpeaks(h, r, 'nhoodxy', 15, 'nhoodr', 21, 'npeaks', 2);

% Affichage des cercles correspondant aux pics
figure(1), hold on;
for peak = peaks
    [x, y] = circlepoints(peak(3));
    plot(x+peak(1), y+peak(2), 'r-');
end

