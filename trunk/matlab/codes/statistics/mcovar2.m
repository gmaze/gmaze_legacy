% MCOVAR2 Two Dimensioal Spectral Estimation
%
% Wang Xianju
% Two Dimensioal Spectral Estimation
% Convariance Method and Modified Convariance Method
% This function implements the modified covariance method for estimation
% of the AR parameters.
%
% [a,variance]=mcovar2(x,m,n,mode)
% Input Parameters:
% ================
%
%   x -----------> two dimensional data 
%   m*n -----------> Order of autoregressive process
%   mode =1  modified Convariance Method
%   mode =0  Convariance Method
% Output Parameters:
% =================
%
%   a -----------> AR coefficients, a(0,0), a(0,1),.......
%   variance ----> Driving noise variance (real)

function [a,variance]=mcovar2(x,m,n,mode)

A=zeros((m+1)*(n+1)-1,(m+1)*(n+1)-1);
row=0;
M=size(x,1);
N=size(x,2);
	for k=0:m
	for l=0:n
       if   ~(k==0 & l==0)
       col=1;
        for i=0: m
            for j=0: n
                if ~(i==0 & j==0)
                        if mode==0
               A(row,col)=sum(sum(x(m+1-i:M-i,n+1-j:N-j).*conj(x(m-k+1:M-k,n-l+1:N-l))))/2/(M-m)/(N-n);
                   else
              A(row,col)=sum(sum(x(m+1-i:M-i,n+1-j:N-j).*conj(x(m-k+1:M-k,n-l+1:N-l))))/2/(M-m)/(N-n)+sum(sum(x(k+1:M-m+k,l+1:N-n+l).*conj(x(i+1:M-m+i,j+1:N-n+j))))/2/(M-m)/(N-n);
                         end
         col=col+1;
                else
           b(row,1)=-sum(sum(x(m+1:M,n+1:N).*conj(x(m-k+1:M-k,n-l+1:N-l))))/2/(M-m)/(N-n)-sum(sum(x(k+1:M-m+k,l+1:N-n+l).*conj(x(1:M-m,1:N-n))))/2/(M-m)/(N-n);
                    end
            end
        end
      end
    row=row+1;
end
end
a=A\b;
a=[1 a']';
cc=1;
variance=0;
 for i=0: m
 for j=0: n
      if mode==0
    variance=variance+a(cc)*sum(sum(x(m+1-i:M-i,n+1-j:N-j).*conj(x(m+1:M,n+1:N))))/(M-m)/(N-n);
      else
    variance=variance+a(cc)*(sum(sum(x(m+1-i:M-i,n+1-j:N-j).*conj(x(m+1:M,n+1:N))))/2/(M-m)/(N-n)+sum(sum(x(1:M-m,1:N-n).*conj(x(i+1:M-m+i,j+1:N-n+j))))/2/(M-m)/(N-n));
    end
    cc=cc+1;
end
end
a=(reshape(a,n+1,m+1))';

