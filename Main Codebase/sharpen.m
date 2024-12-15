I = imread('cauchy.png'); 
I = double(I);  

sigma = 1; 
hsize = 15; 

G = fspecial('gaussian', hsize, sigma);
L = fspecial('laplacian', 0.2); 
deblurred = zeros(size(I));

for channel = 1:3
    smoothed = imfilter(I(:,:,channel), G, 'replicate');
    LoG = imfilter(smoothed, L, 'replicate');
    deblurred(:,:,channel) = I(:,:,channel) - LoG;
end

amount = 5.0;  
radius = 5; 
threshold = 5;

for channel = 1:3
    blurred = imgaussfilt(deblurred(:,:,channel), radius);
    mask = deblurred(:,:,channel) - blurred;
    deblurred(:,:,channel) = deblurred(:,:,channel) + amount * mask;
end

deblurred = uint8(deblurred);  
I = uint8(I);

figure;
subplot(1, 2, 1);
imshow(I);  
title('Original RGB Image');

subplot(1, 2, 2);
imshow(deblurred);
title('Deblurred with Mask');