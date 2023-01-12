N=100000000;
n=N/2;
scale=200;
Q=zeros(2*scale+1,1);
syms x;
syms y;
a=limit(y^(2*y+1),y,n);
j=0;
for i=n-scale:1:n+scale
    b=limit(sqrt(x*(N-x))*x^x*(N-x)^(N-x),x,i);
    j=j+1;
    Q(j,1)=a/b;
end
plot(Q)
disp(Q(scale+1,1))
