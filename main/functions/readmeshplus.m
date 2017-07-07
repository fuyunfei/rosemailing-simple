clear all , close all ;

for i=1:3 
name=['/home/sun/paper510/marchlayer',int2str(i),'.obj']
vertex{i}=read_obj(name);
depth{i}=zeros(-min(vertex{i}(2,:)),max(vertex{i}(1,:)));
idx=sub2ind(size(depth{i}),-vertex{i}(2,:),vertex{i}(1,:));
depth{i}(idx)=vertex{i}(3,:);
surfplot(depth{i});
end 

depth_max=zeros(size(depth{1}));
depth_sum=zeros(size(depth{1}));

for i= 1:3 
depth_max=max(depth_max,depth{i});
depth_sum=depth_sum+depth{i};
end

depth_comb=depth_max;

depth_comb(1:290,:)=depth_sum(1:290,:);
surfplot(depth_max);
surfplot(depth_comb);
% f_1=depth{1}>0.5;
% f_2=depth{2}>0.5;
% f =  f_1.*f_2;
% imshow(f);
for i= 1:3
Z=depth{i};
[X,Y] = meshgrid(1:size(Z,2),1:size(Z,1));
saveobjmesh(['layer_null',int2str(i),'.obj'],X,-Y,Z);
end 


Z=zeros(size(depth{i}));
[X,Y] = meshgrid(1:size(Z,2),1:size(Z,1));
saveobjmesh(['plane.obj'],X,-Y,Z);
