function surfplot(sum)
figure;
surf(sum);
shading interp;
% colormap(copper)
axis('equal');
view(2);
axis('off');
camlight('right')
set(gca,'Ydir','reverse')
set(gca,'Xdir','reverse')
set(gca,'position',[0 0 1 1],'units','normalized')
iptsetpref('ImshowBorder','tight');
end