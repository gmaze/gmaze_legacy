function s = skewness(x,flag)
%SKEWNESS Skewness. 
%   For vectors, SKEWNESS(x) returns the sample skewness.  
%   For matrices, SKEWNESS(X)is a row vector containing the sample
%   skewness of each column. The skewness is the third central 
%   moment divided by the cube of the standard deviation.
%
%   SKEWNESS(X,0) adjusts the skewness for bias.  SKEWNESS(X,1) is
%   the same as SKEWNESS(X), and does not adjust for bias.
%
%   See also MEAN, MOMENT, STD, VAR, KURTOSIS.

%   B.A. Jones 2-6-96
%   Copyright 1993-2000 The MathWorks, Inc. 
%   $Revision: 1.8 $  $Date: 2000/05/26 18:53:42 $

[row, col] = size(x);
if (row == 1), x = x(:); row = col; end

if row == 1 & col == 1
   s = NaN;
elseif (nargin >= 2) & isequal(flag, 0)
   s2 = nanstd(x);            % standard deviation
   n = sum(~isnan(x));        % size of each sample
   ok = (n>2) & (s2>0);       % otherwise bias adjustment is undefined
   s = repmat(NaN, size(n));  % initialize to NaN

   if any(ok)
      s2 = s2(ok);
      n = n(ok);
      x = x(:,ok);
      m = nanmean(x);
      m = m(ones(row,1),:);
      s(ok) = (n ./ ((n-1).*(n-2))) .* nansum((x-m).^3) ./ (s2.^3);
   end
else
   m = nanmean(x);
   m = m(ones(row,1),:);
   m3 = nanmean((x - m).^3);
   sm2 = sqrt(nanmean((x - m).^2));
   s = m3./sm2.^3;
end
   
