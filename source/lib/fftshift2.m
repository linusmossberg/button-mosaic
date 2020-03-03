function out=fftshift2(in)

[nr, nc]=size(in);

out=zeros(nr,nc);
n=(nr+1)/2;

out(1:n,1:n)=in(n:2*n-1,n:2*n-1);
out(1:n,n+1:nr)=in(n:nc,1:n-1);

out(n+1:nr,1:n)=in(1:n-1,n:nc);
out(n+1:nr,n+1:nc)=in(1:n-1,1:n-1);