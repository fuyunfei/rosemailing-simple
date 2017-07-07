function [sum_depth,depthlist]= shape_region(Regions,I,blur_ratio)
getd = @(p)path(p,path);
getd('../lib/toolbox_signal/');
getd('../lib/toolbox_general/');
getd('../lib/toolbox_graph/');
getd('/home/sun/Cloud/SFS/cvision-algorithms/');


depthlist={};
for i= 1:size(Regions,1)
region_idx= Regions(i,1).PixelList;
idx = sub2ind(size(I),region_idx(:,2),region_idx(:,1));
% b=zeros(size(I)); 
b=ones(size(I))*255; 
b(idx)=I(idx);
imageblur=b;
% mask=zeros(size(I));
% mask(idx)=1;
if length(idx)>5000
imageblur= imgaussfilt(b,blur_ratio);
% imageblur=imageblur.*mask;
end
% subplot(2,3,i)
% imshow(imageblur,[0 255])
%% SFS
% imageblur= imgaussfilt(b,2);
% depth = shapeFromShading(imageblur, 1000, 1/8); 
depth = shapemarching(imageblur); %
% depth=ones(size(depth))*depth(20,20)-depth;
depthlist{i}=depth-depth(15,15);

% surfplot(depth(20:end-20,20:end-20));
end 

sum_depth=zeros(size(depthlist{1}));
for i=1:size(depthlist,2)
%     sum_depth=sum_depth+depthlist{i};
    sum_depth=max(sum_depth,depthlist{i});
end

end