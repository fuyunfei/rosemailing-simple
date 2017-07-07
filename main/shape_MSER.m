close all, clear all ;

edgei= 1-double(imread('./layers/5l.png'))/255;
% edgei= edge(rgb2gray(imread('/home/sun/Cloud/matting/Decompose-Single-Image-Into-Layers/5/5l.png')));
edgei = uint8(1-bwareaopen(edgei,150));
imshow(edgei,[0 1])
depthlist={};
depthlist_layer={};
Regions={};
Img={};
layer_num=3;
scaleratio=1;


for i = 1:layer_num;
% name = ['/home/sun/Cloud/matting/Decompose-Single-Image-Into-Layers/5/5edge-layer_optimization_all_weights_map-0',int2str(i),'.png'];
name=['./layers/w',int2str(i),'.png'];
backupI=imread(name);
% backupI=imsharpen(backupI);
I=backupI;
if(size(I,3)==3)  
I=rgb2gray(I);
end 
% I=rgb2gray(imread('/layers/5.jpg'));
% I=imguidedfilter(I);
% I = imadjust(I,stretchlim(I),[]);%
edge_I=I.*edgei;
imshow(I);
Img{i} =I;
sz=size(I,1)*size(I,2);
minsize=0.005;

%% prepossing    white stroke black background assummed 

%  I = imadjust(I); 

I= imresize(I,scaleratio);
Igui=imguidedfilter(I);
Igui=imgaussfilt(Igui,1);
strokefield=imadjust(I)>40;

% if i~=4
% strokefield=imfill(strokefield,'holes');
% end
se = strel('disk',1);
strokefield = 1-imerode(1-strokefield,se);
strokefield=imgaussfilt(double(strokefield),1);
imshow(strokefield); 
% 
I=uint8(double(I));

%% detect 

mservar=struct(...
    'ThresholdDelta',0.1, ...
    'RegionAreaRange', [int64(sz*minsize) int64(sz*0.3)], ...
    'MaxAreaVariation', 0.01);
% [G,~]=imgradient(I);
Regions{i} = detectMSERFeatures(Igui,mservar);

% Regions{i}=filterRegions(I,Regions{i},20,0.4); 
close all 
temp=zeros(size(I));
figure; imshow(temp,[0 255]); hold on;
plot(Regions{i},'showPixelList',true,'showEllipses',false);hold off;

% for j=1:length(Regions{i})
% figure; imshow(Img{i}); hold on;
% plot(Regions{i}(j),'showPixelList',true,'showEllipses',false);
% end

% % %%  SFS 
imageblur= imguidedfilter(I);
% imageblur=I;
% imageblur=smoothalongedge(I,rgb2gray(imread('5-flat.png')));
% imshowpair(I,imageblur,'montage');

depthlist{i}=shapemarching(double(imageblur)); %
depthlist{i}=depthlist{i}-depthlist{i}(20,20);
depthlist{i}=depthlist{i}.*strokefield;
%%% 
% [depthlist{i+layer_num},depthlist_layer{i+layer_num}]= shape_region(Regions{i},imageblur,1.5);
% depthlist{i+layer_num}=depthlist{i+layer_num}-depthlist{i}(10,10);
% depthlist{i+layer_num}=depthlist{i+layer_num}.*strokefield;
end
 
name = ['./layers/w0.png'];

I=imread(name);
I= (imresize(I,scaleratio));
strokefield=(imadjust(I))>200;
se = strel('disk',1);
strokefield=1-imerode(strokefield,se);
strokefield=imgaussfilt(strokefield,2);
% strokefield=imfill(strokefield,'hole'); 
figure;imshow(strokefield);

close all
layer_weight=[30,30,30,30,30,30,30,30];
for i= 1:3
     depthlist{i}=imgaussfilt(depthlist{i});
     surfplot(depthlist{i}/layer_weight(i));
end

 