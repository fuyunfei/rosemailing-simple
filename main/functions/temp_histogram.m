clear all, close all 
inten=imread('1intensity.png');
alpha=(imread('2.png'));

region= uint8(inten<255);
% imshow(region,[0 1]);

inten_region=inten.*region;
alpha_region=alpha.*region;
inten_region = nonzeros(inten_region);
alpha_region = nonzeros(alpha_region);

figure;
h_i=histogram(inten_region(:),'BinLimits',[1,254],'BinWidth',5);xlim([0 255]); ylim([0 12000]);set(gca,'fontsize',30)

figure;
h_a=histogram(alpha_region(:),'BinLimits',[1,254],'BinWidth',5);xlim([0 255]); ylim([0 12000]);set(gca,'fontsize',30)

