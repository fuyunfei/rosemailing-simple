function U =lap1(stroke,depth,y_static,x_static)
vertex=cat(2,stroke,depth);
n = length(vertex);

neighbors={};
Lap=zeros(size(stroke,1));
for i=1:size(stroke,1)
    y=stroke(i,1);
    x=stroke(i,2);
    A=find((y-2)<stroke(:,1)&stroke(:,1)<(y+2)&(x-2)< stroke(:,2)& stroke(:,2)<(x+2));
    neighbors{i}=  A(A~=i);
    Lap(i,A)=-1/(length(A)-1);
    Lap(i,i)=1;
end

L=sparse(Lap);

delta = L * vertex;
L_prime = [   L     zeros(n) zeros(n)   % the x-part
	       zeros(n)    L     zeros(n)   % the y-part     
           zeros(n) zeros(n)    L    ]; % the z-part

for i = 1:n
    
    ring = [i neighbors{i}'];
    V = vertex(ring,:)';
    V = [V
        ones(1,length(ring))];%Here is ones matrix, multiplying V' becomes A in formula (10). Such writing is for associating multiplication factors of v'.
    %The first row of V is x part,the second row is y part, the third one is z part, the elements in last row are all ones.
    C = zeros(length(ring) * 3, 7);
    % ... Fill C in
    for r=1:length(ring)
        C(r,:) =                [V(1,r) 0 V(3,r) (-1)*V(2,r) V(4,r) 0 0];
        C(length(ring)+r,:) =   [V(2,r) (-1)*V(3,r) 0 V(1,r) 0 V(4,r) 0];
        C(2*length(ring)+r,:) = [V(3,r) V(2,r) (-1)*V(1,r) 0 0 0 V(4,r)];
    end;
    Cinv = pinv(C);
    s =   Cinv(1,:);
    h1 =  Cinv(2,:);
    h2 =  Cinv(3,:);
    h3 =  Cinv(4,:);
    
    delta_i = delta(i,:)';
    delta_ix = delta_i(1);
    delta_iy = delta_i(2);
    delta_iz = delta_i(3);
    
    % T*delta gives us an array of coefficients
    % T*delta*V' equals to T(V')*delta in formula (5)
    Tdelta = [delta_ix*s       + delta_iy*(-1)*h3 + delta_iz*h2
        delta_ix*h3      + delta_iy*s       + delta_iz*(-1)*h1
        delta_ix*(-1)*h2 + delta_iy*h1      + delta_iz*s];
    
    % updating the weights in Lx_prime, Ly_prime, Lw_prime
    % Note that L_prime has already containted L. Here L_prime represents T(V')*delta - L(V') in formula(5)
    L_prime(i,[ring (ring + n) (ring + 2*n)]) = ...
        L_prime(i,[ring (ring + n) (ring + 2*n)]) + (-1)*Tdelta(1,:);
    L_prime(i+n,[ring (ring + n) (ring + 2*n)]) = ...
        L_prime(i+n,[ring (ring + n) (ring + 2*n)]) + (-1)*Tdelta(2,:);
    L_prime(i+n*2,[ring (ring + n) (ring + 2*n)]) = ...
        L_prime(i+n*2,[ring (ring + n) (ring + 2*n)]) + (-1)*Tdelta(3,:);
end

% weight for the constraints
w=1;

% building the least-squares system matrix
A_prime = L_prime;
rhs = zeros(3*n,1);

w=1;
ind_static=[];

for i=1:4
    ind_static(i)=find(stroke(:,1)==x_static(i)& stroke(:,2)==y_static(i));
    A_prime = [A_prime
        w*((1:(3*n))==ind_static(i))
        w*((1:(3*n))==(ind_static(i)+n))
        w*((1:(3*n))==(ind_static(i)+2*n))];
    rhs = [rhs
        w*stroke(ind_static(i),1);
        w*stroke(ind_static(i),2);
        w*depth(ind_static(i))];
end;

for i=5:length(y_static)
    ind_static(i)=find(stroke(:,1)==x_static(i)& stroke(:,2)==y_static(i));
    A_prime = [A_prime
        w*((1:(3*n))==ind_static(i))
        w*((1:(3*n))==(ind_static(i)+n))
        w*((1:(3*n))==(ind_static(i)+2*n))];
    rhs = [rhs
        w*stroke(ind_static(i),1)+80;
        w*stroke(ind_static(i),2);
        w*depth(ind_static(i))];
end;

xyz_col = A_prime\rhs;
U = [xyz_col(1:n) xyz_col((n+1):(2*n)) xyz_col((2*n+1):(3*n))];

end