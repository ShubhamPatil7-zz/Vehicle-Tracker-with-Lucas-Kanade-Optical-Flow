% Author: Shubham Patil

function [u, v] = LkOpticalFlow(frm1,frm2, window, cornertype)
    if nargin < 2
        frm1 = './screens/scene00033.png';
        frm2 = './screens/scene00034.png';
        frame1 = rgb2gray( im2double( imread(frm1) ));
        frame2 = rgb2gray( im2double( imread(frm2) ));
        window = 45;
        cornertype = 'Harris';
    else
        frame1 = frm1;
        frame2 = frm2;
    end
    
    [height, width] = size(frame1);  
    
    kernelX = ones(5, 1) * [1 -8 0 8 -1] / 12;
    dx1 = imfilter(frame1, kernelX);
    dy1 = imfilter(frame1, kernelX');
    dx2 = imfilter(frame2, kernelX);
    dy2 = imfilter(frame2, kernelX');
    
    gauss = fspecial('gaussian', 3, 1);
    frame1gauss = imfilter(frame1, gauss);
    frame2gauss = imfilter(frame2, gauss);
    
    Ix = (dx1 + dx2) / 2;
    Iy = (dy1 + dy2) / 2;
    It = frame1gauss -  frame2gauss;
    
    window_half = floor(window/2);
    
    u = zeros(height, width);
    v = zeros(height, width);
    
    C = corner(frame1, cornertype);    
    corner_x = C(:,1);
    corner_y = C(:,2);
    
    no_of_feature_points = length(corner_y);   
    for i = 1:no_of_feature_points
        A = zeros(2, 2);
        B = zeros(2, 1);
        indexrow = corner_y(i);
        indexcol = corner_x(i);
        
        for m = indexrow - window_half:indexrow + window_half
            for n = indexcol - window_half:indexcol + window_half
                if ( m >= (1 + window_half)) && (m <= (height - window_half)) && (n >= (1 + window_half)) && ( n <= (width -  window_half))
                    A(1, 1) = A(1, 1) + Ix(m, n) * Ix(m, n);
                    A(1, 2) = A(1, 2) + Ix(m, n) * Iy(m, n);
                    A(2, 1) = A(2, 1) + Ix(m, n) * Iy(m, n);
                    A(2, 2) = A(2, 2) + Iy(m, n) * Iy(m, n);
                    B(1) = B(1) + Ix(m, n) * It(m, n);
                    B(2) = B(2) + Iy(m, n) * It(m, n);
                end
            end
        end
        
        x = pinv(A) * (B);
        u(indexrow, indexcol) = x(1);
        v(indexrow, indexcol) = x(2);
    end
    
    if nargin < 2
        imshow(imread(frm1)); axis image; axis off; 
        hold on;
        quiver(u, v, 15, 'g');
    end
end