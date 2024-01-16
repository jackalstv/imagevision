clear all; close all;

I0=imread('pcb_3.bmp'); figure(1), imshow(I0); % Image
M=imread('motif_2.bmp'); figure(2), imshow(M); % Motif à détecter

% Rotation de l'image avec interpolation
theta = -30*pi/180;
I1 = rotate_image_bilin(I0, theta);
figure(3), imshow(I1);
title('Rotation avec interpolation');

% recherche du motif par mesure d'intercorrélation
I = double(I1);
M=double(M);
seuil = .75; % seuil pour valider la reconnaissance
cmax = seuil;
for i=1:size(I,1)-size(M,1)+1
    for j=1:size(I,2)-size(M,2)+1
        c = intercorrelation2D(M,I(i:i+size(M,1)-1,j:j+size(M,2)-1));
        if c>cmax
            cmax = c; imax = i; jmax = j;
        end
    end
end

figure(3), hold on; 
h = rectangle('Position',[jmax,imax, size(M,2), size(M,1)]);
get(h); set(h,'EdgeColor','red');


% Fonction d'intercorrélation 2D
function    c = intercorrelation2D(M,F)

A = sum(sum( ( M-mean(M(:)) ).^2 ));
B = sum(sum( ( F-mean(F(:)) ).^2 ));
c =  sum(sum( ( M-mean(M(:)) ).*( F-mean(F(:)) ) )) / sqrt(A*B);

end

% Fonction de rotation de l'image sans interpolation
function Ir = rotate_image(I0, theta)

% Centre de rotation (milieu de l'image)
[h,l] = size(I0);
u0 = round(h/2);
v0 = round(l/2);

for p=1:h
    for q=1:l
        % calcul de i,j correspondant à p,q
        i = round((p-u0)*cos(theta) - (q-v0)*sin(theta)) + u0;
        j = round((p-u0)*sin(theta) + (q-v0)*cos(theta)) + v0;
        
        % vérifier que le point est dans le cadre
        if (i>0) & (i<h) & (j>0) & (j<l)
            Ir(p,q) = I0(i,j); % copier le niveau de gris
        end
    end
end

end


% Fonction de rotation de l'image avec interpolation
function Ir = rotate_image_bilin(I0, theta)

% redressement de l'image
[h,l] = size(I0);
u0 = h/2;% centre de rotation au milieu de l'image
v0 = l/2;
Ir = zeros(h,l);
for p=1:h
    for q=1:l
        % calcul du point transformé théorique
        i = (p-u0)*cos(theta) - (q-v0)*sin(theta) + u0;
        j = (p-u0)*sin(theta) + (q-v0)*cos(theta) + v0;
             
        if (i>1) & (i<h-1) & (j>1) & (j<l-1)
            u = i - floor(i); % on arrondis au plus bas
            v = j - floor(j);
            
            % puis interpole...
            P = (1-v)*double(I0(floor(i),floor(j))) + v*double(I0(floor(i),ceil(j)));
            Q = (1-v)*double(I0(ceil(i),floor(j)))  + v*double(I0(ceil(i),ceil(j)));
            Ir(p,q) = (1-u)*P + u*Q;
        end;
    end;
end;
Ir = uint8(Ir);

end


