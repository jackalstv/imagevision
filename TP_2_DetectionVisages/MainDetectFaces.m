clear all; close all

Wx =19; Wy = 19;  % Taille imagette (fixe)
sc =1; % échelle de départ

I0 = imread('girl.jpg');
figure(1), imshow(I0);

I = rgb2gray(I0);
intImg = cumsum(cumsum(double(I),2));   %integralImg(I); % Image integrale

% chargement des classifieurs
load 'trainedClassifiers.mat';

% Cascade de couches de classifieurs faibles
class1 = selectedClassifiers(1:2,:); % première couche constituée des deux premiers classifieurs faibles
class2 = selectedClassifiers(3:12,:);
class3 = selectedClassifiers(13:20,:);
class4 = selectedClassifiers(21:40,:);
class5 = selectedClassifiers(41:70,:);
class6 = selectedClassifiers(71:150,:);
class7 = selectedClassifiers(151:200,:);

classes = {class1,class2,class3,class4,class5,class6,class7};
seuils = .5*ones(1,length(classes));

res = 0;                           % résultat de la recherche
% Pour chaque taille d'image
while min(size(intImg)) > 2*max([Wx,Wy]) % Tant que la taille d'image est 2x plus grande que l'imagette
    % Balayage de l'image
    for i=1:size(intImg,1) - Wx+1
        for j=1:size(intImg,2) - Wy+1
            % cascade de classifieurs
            window = intImg( i:i+Wx-1 , j:j+Wy-1 );
            check_total = 0;
            for k = 1:length(classes)
                if  cascade(classes{k} , window, seuils(k)) % Si niveau de la cascade validé
                    check_total = check_total + 1;
                else
                    break;
                end
            end
            if check_total == length(classes)
                sc_tr = sc;  i_tr = i; j_tr = j;
                break;
            end
        end
        if check_total == length(classes)
            res = 1;
            break;
        end
    end
    sc = sc*.8; % On resize l'image
    I = rgb2gray(imresize(I0,sc));
    intImg = integralImg(I);
end

if res
    figure(1), hold on, 
    h=rectangle('Position',[j_tr, i_tr, Wx, Wy]/sc_tr);
    get(h); set(h,'EdgeColor','green');
    disp('Trouvé')
end
        

% Fonctions


        
        
        