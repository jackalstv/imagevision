clear all; close all;

nb_elem =10; % Nombre d'éléments du descripteur
seuil = .1;       % Seuil de distance entre 2 descripteurs
min_length = 200;  % Longueur minimale pour considérer  un contour (pixels)

% Descripteur pour la pièce de référence
I = imread('piece_ref.bmp'); figure(1), subplot(2,1,1), imshow(I);
Ib = not(im2bw(I,.85)); % Binarisation
b = bwboundaries(Ib); % détection des contours fermés
b = b{1};  % On garde le plus long
figure(1); subplot(2,1,1), hold on, plot(b(:,2),b(:,1),'.');
d_ref=Descripteur_Fourier(b,nb_elem); % Construction du descripteurs de Fourier
figure(1), subplot(2,1,2),stem(d_ref);

% Recherche des pièces conformes dans l'image requête
I = imread('im_test6.bmp'); figure(2),  imshow(I);
Ib = not(im2bw(I,.85));
b = bwboundaries(Ib);
for k=1:length(b) % On teste chaque contour fermé de longueur suffisante
    bk = b{k};
    length(bk)
    if length(bk)>min_length
        d=Descripteur_Fourier(bk,nb_elem);
        dist = norm(d-d_ref)
        if dist<seuil
            figure(2); hold on, plot(bk(:,2),bk(:,1),'g.');
        else
            figure(2); hold on, plot(bk(:,2),bk(:,1),'r.');
        end
    end
end


% Fonction descripteur de Fourier
function d=Descripteur_Fourier(b,nb_elem)

s = b(:, 1) + 1i*b(:, 2);

S = fft( s , max( [nb_elem, length(b)] ) ); % fft de b

d = abs( S ); % spectre d'amplitude

d = d( 2:nb_elem ); % On enlève la composante continue

d = d/norm(d); % On normalise

end

