% Reconnaissance de formes supervisée par apprentissage avec une base d'images
% Codages : rétinien ou HOG (histogramme d'orientation du gradient)
% Algorithme de classification : KPPV (K plus proches voisins)
clear all; close all;

%% Dataset
dataset = 'fashion.png'; % 'fashion.png'
I0 = imread(dataset);  
if length(size(I0))==3
    I0 = rgb2gray(I0);
end

if strcmp(dataset , 'fashion.png')
    taille_exemples = [28,28];    % Taille de chaque imagette exemple
    nb_par_classe = 90;           % Nombre d'exemples par classe  
elseif strcmp(dataset , 'digits.png')
    taille_exemples = [20,20];    % Taille de chaque imagette exemple
    nb_par_classe = 500;           % Nombre d'exemples par classe  
end
nb_exemples = size(I0)./taille_exemples;   % Nombre d'exemples total


%% Paramètres de l'algorithme de reconnaissance KPPV
descripteur = 'H';    % Choix du codage : 'H' = HOG , 'R' = rétinien   
if descripteur == 'H'
    nbwin_x = 4; nbwin_y = 4; B = 12; % nombre de blocs et nombre de bins par bloc(pour HOG uniquement)
end
distance = 'euclidean';          % Distance à utiliser pour la classification
k = 5; % Nombre k pour l'algorithme KPPV


%% Construction de la base d'apprentissage et de la base de test
exemples = []; etiquettes = [];
n=0;
for i=1:taille_exemples(1):size(I0,1)
    for j=1:taille_exemples(2):size(I0,2)
        M =  I0( i:i+taille_exemples(1)-1 , j:j+taille_exemples(2)-1 ) ;
        if descripteur == 'H'
            exemples = [ exemples ; HOG(M,nbwin_x,nbwin_y,B)' ]; % Codage de la forme par HOG
        elseif descripteur == 'R'
            exemples = [ exemples ; double(M(:))' /norm(double(M(:)))];    % Codage de la forme par codage rétinien
        end
        etiquettes = [ etiquettes , floor(n/nb_par_classe) ];     % Etiquettes associées
        n = n+1;
    end
end

exemples_entrainement = exemples(1:2:end,:);  % Base d'apprentissage
exemples_test = exemples(2:2:end,:);                 % Base de test
etiquettes_entrainement = etiquettes(1:2:end);
etiquettes_test = etiquettes(2:2:end);

%% Validation
nb_positifs = 0;
for i=1:length(etiquettes_test)
    etiquette_resultat = KPPV(exemples_entrainement , etiquettes_entrainement , exemples_test(i,:) , k);
    if etiquettes_test(i) == etiquette_resultat
        nb_positifs = nb_positifs + 1;
    end
end

taux_reussite = 100*nb_positifs/length(etiquettes_test)


%% Fonctions

function etiquette_resultat = KPPV(exemples_entrainement , etiquettes_entrainement , exemple_test , k)

% Distances
for i=1:length(etiquettes_entrainement)
    dist(i) = norm(exemples_entrainement(i,:)-exemple_test);
end

% Recherche des k etiquettes ayant les plus petites distances
liste_etiquettes_resultats = [];
for i=1:k
    [dmin,idx]=min(dist);
    liste_etiquettes_resultats = [liste_etiquettes_resultats, etiquettes_entrainement(idx)];
    dist(idx) = max(dist);
end

% Recherche de l'étiquette la plus représentée parmi les k
nb_occur_max = 0;
for i=1:length(liste_etiquettes_resultats)
    nb_occur =  length(find(liste_etiquettes_resultats==liste_etiquettes_resultats(i)));
    if nb_occur > nb_occur_max
        nb_occur_max = nb_occur;
        etiquette_resultat =  liste_etiquettes_resultats(i);
    end
end

end


function H=HOG(Im,nwin_x,nwin_y,B)

[L,C]=size(Im); % L num lignes ; C num colonnes
H=[];  % Histogramme vide

% Calcul du gradient
Im=double(Im);
[grad_x,grad_y] = gradient(Im);
angles=atan2(grad_y,grad_x);  % orientations
magnit=sqrt( grad_y.^2 + grad_x.^2 ); % magnitude

% Construction de l'histogramme
step_x=floor(C/(nwin_x+1));
step_y=floor(L/(nwin_y+1));
for n=0:nwin_y-1  % Pour chaque bloc
    for m=0:nwin_x-1
        angles2=angles(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x); 
        magnit2=magnit(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x);
        % On construit un histogrammes à B barres (2pi/B deg par barre)
        H0 = zeros(1,B);
        bins = -pi:2*pi/B:pi;
        for k = 1:length(bins)-1
            [x,y] = find( angles2>=bins(k) & angles2<bins(k+1) );
            H0(k) = sum(sum(magnit2(x,y))); % La valeur de la barre est la somme des gradients dans cette direction
        end
        H=[H,H0];
    end
end

H = (H/norm(H))'; % On normalise le vecteur de codage

end



