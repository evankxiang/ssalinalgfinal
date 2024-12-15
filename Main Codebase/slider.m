function slider()
    image = imread('ducks.jpg');

    if size(image, 3) ~= 3
        error('The image must be a color image (RGB).');
    end

    % bounding box area blur
    figureHandle = figure;
    imshow(image);
    title('Drag to select the area to blur');
    rect = imrect;
    position = wait(rect);
    close(figureHandle);

    % box location
    x = round(position(1));
    y = round(position(2));
    width = round(position(3));
    height = round(position(4));

    fig = figure('Position', [100, 100, 1200, 800]);

    % slider creation
    sliderCauchyGamma = uicontrol('Style', 'slider', 'Min', 1, 'Max', 100, 'Value', 20, ...
        'Position', [10, 700, 120, 20], 'Callback', @updateImages);
    uicontrol('Style', 'text', 'Position', [10, 720, 120, 20], 'String', 'Cauchy Gamma');

    sliderGaussianSigma = uicontrol('Style', 'slider', 'Min', 1, 'Max', 100, 'Value', 20, ...
        'Position', [10, 650, 120, 20], 'Callback', @updateImages);
    uicontrol('Style', 'text', 'Position', [10, 670, 120, 20], 'String', 'Gaussian Sigma');

    sliderKernelSizeC = uicontrol('Style', 'slider', 'Min', 3, 'Max', 50, 'Value', 20, ...
        'Position', [10, 600, 120, 20], 'Callback', @updateImages);
    uicontrol('Style', 'text', 'Position', [10, 620, 120, 20], 'String', 'Kernel Size (C)');

    sliderKernelSizeL = uicontrol('Style', 'slider', 'Min', 3, 'Max', 50, 'Value', 20, ...
        'Position', [10, 550, 120, 20], 'Callback', @updateImages);
    uicontrol('Style', 'text', 'Position', [10, 570, 120, 20], 'String', 'Kernel Size (B)');

    sliderKernelSizeG = uicontrol('Style', 'slider', 'Min', 3, 'Max', 50, 'Value', 20, ...
        'Position', [10, 500, 120, 20], 'Callback', @updateImages);
    uicontrol('Style', 'text', 'Position', [10, 520, 120, 20], 'String', 'Kernel Size (G)');

    % display
    ax1 = subplot(2, 2, 1, 'Parent', fig);
    imshow(image, 'InitialMagnification', 'fit');
    title(ax1, 'Original Image');

    ax2 = subplot(2, 2, 2, 'Parent', fig);
    ax3 = subplot(2, 2, 3, 'Parent', fig);
    ax4 = subplot(2, 2, 4, 'Parent', fig);

    % update 
    updateImages();

    function updateImages(~, ~)
        % pull slider vals
        gamma = get(sliderCauchyGamma, 'Value');
        sigmaL = 25;
        sigmaG = get(sliderGaussianSigma, 'Value');
        kernelSizeC = round(get(sliderKernelSizeC, 'Value'));
        kernelSizeL = round(get(sliderKernelSizeL, 'Value'));
        kernelSizeG = round(get(sliderKernelSizeG, 'Value'));

        % kernel create
        cauchyKernel = createCauchyKernel(kernelSizeC, gamma);
        laplacianKernel = createLaplacianKernel(kernelSizeL, sigmaL);
        gaussianKernel = createGaussianKernel(kernelSizeG, sigmaG);

        % image create
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

        % update images
        imshow(cauchyBlurredImage, 'Parent', ax2, 'InitialMagnification', 'fit');
        title(ax2, sprintf('Cauchy Kernel: Gamma = %.2f, Size = %d', gamma, kernelSizeC));

        imshow(laplacianBlurredImage, 'Parent', ax3, 'InitialMagnification', 'fit');
        title(ax3, sprintf('Box Kernel: Size = %d', kernelSizeL));

        imshow(gaussianBlurredImage, 'Parent', ax4, 'InitialMagnification', 'fit');
        title(ax4, sprintf('Gaussian Kernel: Sigma = %.2f, Size = %d', sigmaG, kernelSizeG));
    end
end

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