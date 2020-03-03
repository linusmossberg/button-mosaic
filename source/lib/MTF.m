function M=MTF(N,DELTA,DIS);

%MTF(N,DELTA,DIS) generates the human modulation-transfer function (size NxN)
%	with the sample spacing DELTA and the viewing distance DIS. Thus, the
%	 MTF is given in image frequencies. (DELTA=the physical size of a pixel
%	in millimeters, DIS is also in millimeters)

%	From Sullivan, J. Opt. Soc. Am. - Vol. 10 - No. 8,
%	Implemented by Fredrik Nilsson 970724

a=2.2;
b=0.192;
c=0.114;
d=1.1;
w=0.7;
fmax=6;

M=zeros(N,N);
my=((N+1)/2);
mx=((N+1)/2);
for m=1:N
  for n=1:N
    f_i=sqrt((m-my)^2+(n-mx)^2)/(N*2*DELTA);
    %f_i in images frequencies! Max freq. (N-1)/(2*N*DELTA)
    %f_i should be divided with N*DELTA but to correspond to the figures
    %in Sullivans article, the extra term 2 is necessary

    f_v=(pi/180)*f_i/(asin(1/sqrt(1+DIS^2)));
    %f_v is in cycles per visual degree

    alpha=atan2((m-my),(n-mx));
    s=((1-w)/2)*cos(4*alpha)+((1+w)/2);
    %f_v is scaled with s to obtain the angular dependence
    f_v=f_v/s;

    if f_v>fmax
      M(m,n)=a*(b+c*f_v)*exp(-(c*f_v)^d);
    else
      M(m,n)=1;
    end;
  end;
end;

