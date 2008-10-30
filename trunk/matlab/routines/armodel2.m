% ARMODEL2 Two Dimensional Spectral Estimation
%
% [a,variance] = ARMODEL2(x,m,n,mode)
%
% Wang Xianju, April 2002
% Two Dimensional Spectral Estimation
% Note: The program is for Quater Plane Model Region Support ( Causal Support)
%
%
% This function determines the autoregressive coefficients by the
% Yule-Walker algorithm (sometimes known as the autocorrelation method).
%
% Input Parameters:
% ================
% 
%  x is the 2-D signal
%  m*n is the AR order 
%   mode = 1;           % Biased ACF estimates
%   model =0 is unbiased  =1 biased
% Output Parameters:
% =================
%
%   a -----------> AR coefficients
%   variance ----> Driving noise variance (real).
%
%-------------------------------------------------------------------------
%CC   = zeros(p,p);
   
function [a,variance]=armodel2(x,m,n,mode)

%%%%
% 1. computer R
lagsx=2*m+1;
lagsy=2*n+1;
r=zeros(lagsx,lagsy);
M=size(x,1);
N=size(x,2);
for i = 0:lagsx-1
for j=0:lagsy-1
  k=i-m;
  l=j-n; 
  if k>=0 & l>=0
  MK=M-k;
  NL=N-l;
  SUM = sum(sum(conj(x(1:MK,1:NL)).*x(1+k:MK+k,1+l:NL+l)));
  if mode == 0
    r(i+1,j+1)=SUM./NL/MK;                % Unbiased estimate
  else
    r(i+1,j+1)=SUM./N/M;                 % Biased estimate
  end
end
if k>0 & l<0
  MK=M-k;
  NL=N-l;
SUM = sum(sum(conj(x(1:MK,-l+1:N)).*x(1+k:MK+k,-l+1+l:N+l)));
  if mode == 0
    r(i+1,j+1)=SUM./NL/MK;                % Unbiased estimate
  else
    r(i+1,j+1)=SUM./N/M;                 % Biased estimate
  end
end
end
end

nn=(m+1)*(n+1);
R=zeros(nn,nn);
Rxx=zeros(n+1,n+1);

for i=0: m
for j=0: i
    for k=0:n
        for l=0:k
            Rxx(k+1,l+1)=r(i-j+m+1,k-l+n+1);
           if k~=l
             if  i-j==0
              Rxx(l+1,k+1)=conj(r(i-j+m+1,(k-l)+n+1));   
          else
             Rxx(l+1,k+1)=r(i-j+m+1,-(k-l)+n+1);
         end
            end
        end
 R(i*(n+1)+1:i*(n+1)+n+1,j*(n+1)+1:j*(n+1)+n+1)=Rxx;
 if i~=j
 R(j*(n+1)+1:j*(n+1)+n+1,i*(n+1)+1:i*(n+1)+n+1)=Rxx';
end
end
end
end

%2 . R*a=b
A=R(2:nn,2:nn);
b=-R(2:nn,1);
a=A\b;
a=[1 a']';
variance=R(1,1:nn)*a;
% 
a=(reshape(a,n+1,m+1))'
