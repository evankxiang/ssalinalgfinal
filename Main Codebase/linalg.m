% preliminary convolution testing -> essentially censoring stuff cuz im
% bored
image = imread('texttest.png');

if size(image, 3) ~= 3
    error('The image must be a color image (RGB).');
end

% choose a bounding box area to blur
figureHandle = figure;
imshow(image);
title('Drag to select the area to blur');
rect = imrect;
position = wait(rect);
close(figureHandle);

% obtain the location of the box
x = round(position(1));
y = round(position(2));
width = round(position(3));
height = round(position(4));

% create kernels
kernelSizeC = 55;
kernelSizeL = 15;
kernelSizeG = 15;
gamma = 15;
sigmaL = 15;
sigmaG = 55;
cauchyKernel = createCauchyKernel(kernelSizeC, gamma);
laplacianKernel = createLaplacianKernel(kernelSizeL, sigmaL);
gaussianKernel = createGaussianKernel(kernelSizeG, sigmaG);

% create images
cauchyBlurredImage = image;
laplacianBlurredImage = image;
gaussianBlurredImage = image;

% apply kernels to all three channels (r, g, b) of images
for channel = 1:3
    region = double(image(y:y+height-1, x:x+width-1, channel));
    
    cauchyBlurredRegion = uint8(conv2(region, cauchyKernel, 'same'));
    laplacianBlurredRegion = uint8(conv2(region, laplacianKernel, 'same'));
    gaussianBlurredRegion = uint8(conv2(region, gaussianKernel, 'same'));
    
    cauchyBlurredImage(y:y+height-1, x:x+width-1, channel) = cauchyBlurredRegion;
    laplacianBlurredImage(y:y+height-1, x:x+width-1, channel) = laplacianBlurredRegion;
    gaussianBlurredImage(y:y+height-1, x:x+width-1, channel) = gaussianBlurredRegion;
end

% display images
figure;
set(gcf, 'Position', [100, 100, 1000, 800]);
subplot(2, 2, 1);
imshow(image,'InitialMagnification', 'fit');
title('Original Image');

subplot(2, 2, 2);
imshow(cauchyBlurredImage,'InitialMagnification', 'fit');
title('Blurred Region (Cauchy Kernel)');

subplot(2, 2, 3);
imshow(laplacianBlurredImage,'InitialMagnification', 'fit');
title('Blurred Region (Laplacian Kernel)');

subplot(2, 2, 4);
imshow(gaussianBlurredImage,'InitialMagnification', 'fit');
title('Blurred Region (Gaussian Kernel)');


% kernel creation functions
function gaussianKernel = createGaussianKernel(kernelSize, sigma)
    [x, y] = meshgrid(-floor(kernelSize/2):floor(kernelSize/2), -floor(kernelSize/2):floor(kernelSize/2));
    gaussianKernel = exp(-(x.^2 + y.^2) / (2 * sigma^2));
    gaussianKernel = gaussianKernel / sum(gaussianKernel(:));
end

function cauchyKernel = createCauchyKernel(kernelSize, gamma)
    [x, y] = meshgrid(-floor(kernelSize/2):floor(kernelSize/2), -floor(kernelSize/2):floor(kernelSize/2));
    cauchyKernel = 1 ./ (1 + (x.^2 + y.^2) / gamma^2);
    cauchyKernel = cauchyKernel / sum(cauchyKernel(:));
end

function laplacianKernel = createLaplacianKernel(kernelSize, sigma)
    [x, y] = meshgrid(-floor(kernelSize/2):floor(kernelSize/2), -floor(kernelSize/2):floor(kernelSize/2));
    r = sqrt(x.^2 + y.^2);
    laplacianKernel = exp(-r / sigma) / (2 * pi * sigma^2);
    laplacianKernel = laplacianKernel / sum(laplacianKernel(:));
end