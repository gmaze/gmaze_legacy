% FFTMSPEC Module Spectra of the Fourier Transform
%
% FFTMSPEC(XT,T) Plots the signal XT versus time T and the absolute value of the the discrete 
% Fourier transform (DFT) of the signal vector XT versus the a frequency vector F.
%
% [XFM,F] = FFTMSPEC(XT,T) Returns the Fourier Transform of XT and the frequency range in
% vectors XFM and F.
%
% Considerations:
% - XT and T must be row vectors of the same length.
% - T must have an even number of elements .
% - Tn<Tn+1, Tn+1=Tn+T.
%
% The graphical output is a figure of two graphics.
% Use SUBPLOT(2,g,1) to handle the graphics.
%
% Plese send any comments to jrojasz@telcel.net.ve 
% Future comments. Jes�s A. Rojas Zavarce.

%   J.A.R.Z. 11-25-98
%   $Revision: 1.1 $  $Date: 1998/11/25 22:59:11 $

function [xfm,f] = fftmspec(xt,t)

ni = nargin;
no = nargout;
% Checking Inputs arguments
if ni<2,
   nargchk(2,2,ni)
   return
end
[r_xt,c_xt] = size(xt);
[r_t,c_t] = size (t);
if or(r_xt~=1,r_t~=1),
   'Input arguments must be row vectors'
   return
end
if c_xt~=c_t,
   'Input arguments must be the same length'
   return
end
s=c_t; % Number of samples
if s~=(2*round(s/2)),
   'Time vector must have even number of elements.'
   return
end
tmin=t(1,1);
tmax=t(1,length(t));  
ts=t(1,2)-t(1,1);
t2=tmin:ts:tmax;   
if length(t2)~=length(t), 
   'Time vector must be an aritmetical progresion.(1)'
   return
end
if (t-t2)~=zeros(1,s),
   'Time vector must be an aritmetical progresion.(2)'
   return
end
m=s/2;
fs=(1/(2*m))*(1/ts);      
fmax=m*fs;                
fmin=-fmax+fs;            
f=fmin:fs:fmax;
xf=fft(xt)/length(f);
xfm=abs(xf);
xfp=angle(xf);
% Checking output type
if no==0,
   %'Grphical output'
   xfmg=[xfm(((length(xfm)/2)+1):length(xfm)) xfm(1:(length(xfm)/2))];
   figure;
   subplot(2,1,1), plot(t,xt);grid on; ylabel('x(t)'); xlabel('(sec)');
   subplot(2,1,2), plot(f,xfmg); grid on; ylabel('|X(f)|'); xlabel('(Hz)');
   return
elseif no==2,
   %'Numerical output'
   return
else
   'Not enough output arguments.'
   return
end
% end fftmspec
