clear all; close all;

% Chargement de l'image bruitée
I0 = imread('image5.bmp');
if length(size(I0))==3 % Si nécessaire, on convertit en image de gris
    I0 = rgb2gray(I0);
end
figure(1); imshow(I0); title('Image originale');

% Filtre moyenneur
w = 5;          % taille du masque de convolution (2w+1)X(2w+1)
K = (1/((2*w+1)^2))*ones(2*w+1,2*w+1);  % filtre moyenneur
I1 = convolution2D(I0,K,w); 
figure(2); imshow(I1); title('Image filtrée par moyenne mobile');

% Filtre gaussien
w = 5;                                  % taille du masque (2w+1)X(2w+1)
sigma = 2.5;                           % écart type de la gaussienne
K = gaussienne2D(w,sigma);             % filtre gaussien
figure(3), mesh((-w:w),(-w:w),K);
I2 = convolution2D(I0,K,w);
figure(4), imshow(I2); title('Image filtrée par gaussienne');

% 2/ Filtrage médian
w = 1;                                 % taille du masque (2w+1)X(2w+1)
I3 = filtragemedian(I0,w);
figure(5); imshow(I3); title('Image filtrée par médian');

% Fonction de convolution
function I1 = convolution2D(I0,K,w)

I0 = double(I0); % On convertit en double

I1 = zeros(size(I0));  % on initialise l'image résultat

for i=w+1:size(I0,1)-w
    for j=w+1:size(I0,2)-w
        I1(i,j) = sum(sum(I0(i-w:i+w,j-w:j+w).*K));
    end;
end;

I1 = uint8(I1); % On convertit en format image

end

% Fonction filtre gaussien
function K = gaussienne2D(w,sigma)

K = zeros(2*w+1,2*w+1);

for i=-w:w
    for j=-w:w
        K(i+w+1,j+w+1)=exp(-(i^2+j^2)/(2*sigma^2))/(2*pi*sigma^2);
    end;
end;

end


% Fonction filtrage médian
function I1 = filtragemedian(I0,w);

I1 = zeros(size(I0));  % on initialise l'image résultat

for i=w+1:size(I0,1)-w
    for j=w+1:size(I0,2)-w       
        A = double(I0(i-w:i+w,j-w:j+w)); % sélection du voisinnage        
        B = sort(A(:));           % tri par ordre croissant        
        I1(i,j) = B((length(B)-1)/2);
    end;
end;

I1 = uint8(I1); % On convertit en format image

end
