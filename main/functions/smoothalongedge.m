function I=smoothalongedge(I,edgeI)
E = edge(edgeI,'canny');
%Dilate the edges
Ed = imdilate(E,strel('disk',2));
%Filtered image
Ifilt = imgaussfilt(I,1);
%Use Ed as logical index into I to and replace with Ifilt
I(Ed) = Ifilt(Ed);
end