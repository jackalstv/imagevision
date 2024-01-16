clear all; close all;

I = imread('carte.png');
if size(I,3)==3
    I=rgb2gray(I); % conversion en niveaux de gris
end
figure(1), imshow(I); title('Image niveaux de gris');

% Détection de contour avec l'opérateur de Sobel
I = double(I); % Conversion des données uint8 en double

% Gradient selon x
Sx= [-1 0 1; % Opérateur de Sobel en x
        -2 0 2;
        -1 0 1];
Igx = imfilter(I,Sx);

% Gradient selon y
Sy = [-1 -2 -1; % Opérateur de Sobel en y
       0  0  0;
       1  2  1];
Igy = imfilter(I,Sy);

% Module du gradient
Ig = sqrt(Igx.^2+Igy.^2); % Image du gradient
figure(2); imshow(uint8(Ig)); title('Image du gradient');

% Seuillage du gradient
seuil=250;
Ic=Ig>seuil; % Image de contours
figure(3); imshow(Ic); title('Image de contours avec Sobel');


% Détection de contours avec la fonction edge de Matlab
Ic = edge(I,'sobel', 50); figure(4); imshow(Ic); title('Sobel (Matlab)');
Ic = edge(I,'prewitt', 50); figure(5); imshow(Ic); title('Prewit');
Ic = edge(I,'canny', 0.5); figure(6); imshow(Ic); title('Canny');



