clear all; close all;

%I = imread('piece_ref.bmp');
I = imread('piece.bmp'); figure(1), imshow(I); title('Image d''origine');
if length(size(I))==3
    I=rgb2gray(I); % conversion en niveaux de gris si l'image est RGB
end

I = medfilt2(I,[3,3]); % filtrage médian pour lisser le bruit (pré-traitement)

seuil = 20; % 3 pour "oiel.png" et "monnaie.png"
label = 0;
Ir=zeros(size(I));
for i=1:size(I,1)
    for j=1:size(I,2) % pour chaque pixel
        if Ir(i,j)==0           % si non déjà labelisé
            label=label+1;
            Ir(i,j)=label;
        end
        for k=i-1:i+1       % je cherche le voisinage
            for l=j-1:j+1
                if k>0 & k<=size(Ir,1) & l>0 & l<=size(Ir,2)   % si dans le cadre
                    if Ir(k,l)==0                                                   % si non labelisé
                        if abs( double(I(i,j)) - double(I(k,l)) ) < seuil        % si niveau de gris proche
                           Ir(k,l)=Ir(i,j);                                          % alors affecter le même label
                        end
                    end
                end
            end
        end
    end
end

% Fusion region connectées
for i=1:size(Ir,1)
    for j=1:size(Ir,2) 
        for k=i-1:i+1       
            for l=j-1:j+1
                if k>0 & k<=size(Ir,1) & l>0 & l<=size(Ir,2)  
                    if Ir(i,j)~=Ir(k,l) & abs( double(I(i,j))-double(I(k,l)) ) < seuil       % si niveau de gris similaire mais label région différents
                        Ir(Ir==Ir(k,l))=Ir(i,j);                                  % alors fusionner les labels
                    end
                end
            end
        end
    end
end

figure(3), imagesc(Ir);
        
