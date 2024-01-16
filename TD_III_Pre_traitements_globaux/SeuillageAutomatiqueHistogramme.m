clear all; close all;

% Chargement et afficage de l'image
I = imread('image9.bmp');
figure(1), subplot(2,1,1), imshow(I);

% Histogramme
[h,j]=imhist(I);
figure(1), subplot(2,1,2), stem(j,h);

% Valeurs initiales approximatives des paramètres de la double gaussienne
sigma0 = 10; m0 = 50; A0 = 2000;
sigma1 = 10; m1 = 100; A1 = 100;
X0 = [sigma0, m0, A0, sigma1, m1, A1];

% Optimisation selon les moindres carrés avec l'agorithme de Levenberg-Marquardt
options.Algorithm = 'levenberg-marquardt';
X = lsqnonlin(@(X) ErrFun(X,h), X0, [],[], options);
sigma0 = X(1); m0 = X(2); A0 = X(3);
sigma1 = X(4); m1 = X(5); A1 = X(6);

% Affichage de la double gaussienne
g = A0*exp(-(j-m0).^2/(2*sigma0^2)) + A1*exp(-(j-m1).^2/(2*sigma1^2));
figure(1), subplot(2,1,2), hold on, plot(j,g,'g-','LineWidth',2);

% Seuil de séparation des deux gaussienne = valeur min de g située entre m0 et m1
[a,s] = min(g(m0:m1));
seuil = round(s+m0);   % Ne pas oublier l'offset m0
figure(1), subplot(2,1,2), hold on, stem(seuil, max(g), 'r');

% Seuillage de l'image
[x,y]=find(I>s+m0);  % Sélection des pixels dont le niveau de gris est supérieur au seuil
figure(1), subplot(2,1,1), hold on, plot(y, x,'r.'); % On colorie en rouge les pixels au dessus du seuil


% Fonction d'erreur
function [ err ] = ErrFun( X , h )
% Fonction de coût à minimiser
% Input : valeur courante des paramètres du modèle à identifier et vecteur de mesures (ici fonction double gaussienne)
% Ouput : vecteur d'erreur composé des différences entre mesures (histogramme) et modèle (double gaussienne)

sigma0 = X(1); m0 = X(2); A0 = X(3);
sigma1 = X(4); m1 = X(5); A1 = X(6);

i = 1:length(h);
h_est = A0*exp(-(i-m0).^2/(2*sigma0^2)) + A1*exp(-(i-m1).^2/(2*sigma1^2));

err = h' - h_est;

end


