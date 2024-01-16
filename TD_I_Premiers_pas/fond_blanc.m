clear all
close all

I_3 = imread('image3.bmp');
figure(3);
imshow(I_3);

I_4 = imread('image4.bmp');
figure(4);
imshow(I_4);

for i=1:size(I_3,1)
    for j=1:size(I_3,2)
        if I_3(i,j) > 240
            I_3(i,j) = I_4(i,j);
        end
    end
end

figure(3),
imshow(I_3);
