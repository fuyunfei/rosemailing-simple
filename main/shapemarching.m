function depth = shapemarching(f)
getd = @(p)path(p,path);
getd('../lib/toolbox_signal/');
getd('../lib/toolbox_general/');
getd('../lib/toolbox_graph/');

ss=size(f);

f = padarray(f,[10 10],255);

n = size(f,1);

f=imresize(f,[n n]);

h = n*.4;

f = rescale(f,0,h);
% 
% clf;
% imageplot(f);

options.order = 2;
N0 = cat(3, -grad(f,options), ones(n));

s = sqrt( sum(N0.^2,3) );
N = N0 ./ repmat( s, [1 1 3] );


d = [0 0 1];
L = max(0, sum( N .* repmat(reshape(d,[1 1 3]), [n n 1]),3 ) );

vmin = .3;
% clf;
% imageplot(max(L,vmin));

%For a vertical ligthing direction d=(0,0,1) 
d = [0 0 1];

% Compute the luminance map for d=(0,0,1)d=(0,0,1). 

L = sum( N .* repmat(reshape(d,[1 1 3]), [n n 1]),3 ); 
epsilon = 1e-9;
% clf;
% imageplot(L>1-epsilon);
W = sqrt(1./L.^2-1);
W = max(W,epsilon);
% clf;
% imageplot(min(W,3));

p = [10  ;10 ];
 
[depth,S,q] = perform_fast_marching(1./W, p);

depth = depth*n;
depth=imresize(depth(11:end-10,11:end-10),ss);
end