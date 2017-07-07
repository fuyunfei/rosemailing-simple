clear all ; close all;
load('temp3.mat');

stroke1=Regions{1}(5).PixelList;

idx1 = sub2ind(size(Img{1}), stroke1(:,2), stroke1(:,1));

%%
testI=zeros(size(Img{1}));
testI(idx1)=255;
testI=imfill(testI,'hole');
idx1=find(testI>0);
[stroke1y,stroke1x]=ind2sub(size(Img{1}),idx1);
stroke1=[stroke1x stroke1y];
%%

stroke1_depth=zeros(size(depthlist{1,1}));
stroke1_depth(idx1)=depthlist{1,1}(idx1);
% stroke1_depth(stroke1_depth == 0) = NaN;

figure;
surfplot(stroke1_depth/100);

 

[x_input y_input] = ginput(5);
x_static=uint16(x_input);
y_static=uint16(y_input);
idx_static = sub2ind(size(Img{1}),y_static,x_static);

% [lap1,V1]=lap(stroke1,depthlist{1,1}(idx1));
U=lap2(stroke1,depthlist{1,1}(idx1),y_static,x_static);

U=uint16(U);
stroke_U= zeros(size(Img{1}));

for i = 1:length(U)
stroke_U(U(i,2),U(i,1)+1)=U(i,3);
end


stroke_U=imfill(stroke_U,'holes');
figure;
surf(stroke_U/100);

shading interp;
axis('equal');
view(2);
axis('off');
camlight('right') 
set(gca,'Ydir','reverse')
set(gca,'Xdir','reverse')
set(gca,'position',[0 0 1 1],'units','normalized')
iptsetpref('ImshowBorder','tight');


Z=stroke1_depth/80;
[X,Y] = meshgrid(1:size(Z,2),1:size(Z,1));
saveobjmesh('stroke1_null.obj',X,Y,-Z);

