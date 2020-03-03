function f=MFTsp(N,d,dis)

% f=MFTsp(N,d,dis)
% N decides the size of the filter 
% d is the dot size, which is 0.0847 mm for 300 dpi
% dis is the viewing distance in mm 

F=MTF(N,d,dis);
F2=fftshift2(F);
f2=real(ifft2(F2));
f=fftshift(f2);
