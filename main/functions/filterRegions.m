function mserRegions=filterRegions(I,mserRegions,threshold1,threshold2)
sz = size(I);
empty=0;

for i=1:length(mserRegions)
    pixelList=mserRegions(i-empty).PixelList;
    valueidx=sub2ind(sz,pixelList(:,2),pixelList(:,1));
    valuelist=I(valueidx);
       
    if mean(valuelist)<threshold1
        mserRegions(i-empty) = [];
        empty=empty+1;
    end
end

end