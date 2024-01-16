clear all;  close all;

I = imread('image6.bmp'); figure(1), subplot(1,2,1), imshow(I)
title('Image originale');

% calcul de l'histogramme
figure(1), subplot(1,2,2), imhist(I);
title('Niveau de gris'); ylabel('Nb. de pixels');

% Etalement d'histogramme
I = histet(I,1,10);
figure(2), subplot(1,2,1), imshow(I)
title('Image après étalement d''histogramme');

% Calcul de l'histogramme à nouveau
figure(2), subplot(1,2,2), imhist(I);
title('Niveau de gris'); ylabel('Nb. de pixels');


% Fonction
function J = histet(I,a,b)

J = zeros(size(I));

for i=1:size(I,1)
    for j=1:size(I,2)
        if I(i,j)<a
            J(i,j) = round( 1*double(I(i,j)));
        elseif I(i,j)<b
            J(i,j) = round( 255*( double(I(i,j))-a ) / (b-a) );
        else
            J(i,j)=255;
        end
    end;
end;

J = uint8(J);

end