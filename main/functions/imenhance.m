function I3 = imenhance(I,open_size)
open_size=size(I,1)*0.5;
background = imopen(I,strel('disk',2));
imshow(background)
% Display the Background Approximation as a Surface
% figure
% surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
% ax = gca;
% ax.YDir = 'reverse';
I2 = I - background;
I3 = imadjust(I2);
% figure
% subplot(2,2,1);
% imshow(I);
% subplot(2,2,2);
% imshow(background);
% subplot(2,2,3);
% imshow(I2);
% subplot(2,2,4);
% imshow(I3);
end
% bw = imbinarize(I3);
% bw = bwareaopen(bw, 50);
% imshow(bw)