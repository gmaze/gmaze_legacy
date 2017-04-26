function k = kurtosis(x,flag)
%KURTOSIS Kurtosis. 
%   For vectors, KURTOSIS(x) returns the sample kurtosis.  
%   For matrices, KURTOSIS(X) is a row vector containing the sample
%   kurtosis of each column. The kurtosis is the fourth central 
%   moment divided by fourth power of the standard deviation.
%
%   KURTOSIS(X,0) adjusts the kurtosis for bias.  KURTOSIS(X,1) is
%   the same as KURTOSIS(X), and does not adjust for bias.
%
%   See also MEAN, MOMENT, STD, VAR, SKEWNESS.

%   B.A. Jones 2-6-96
%   Copyright 1993-2000 The MathWorks, Inc. 
%   $Revision: 1.8 $  $Date: 2000/05/26 18:52:59 $

[row, col] = size(x);
if (row == 1), x = x(:); row = col; end

if row == 1 & col == 1
   k = NaN;
elseif (nargin >= 2) & isequal(flag,0)
   s = nanstd(x);             % standard deviation
   n = sum(~isnan(x));        % size of each sample
   ok = (n>3) & (s>0);        % otherwise bias adjustment is undefined
   k = repmat(NaN, size(n));  % initialize to NaN

   if any(ok)
      s = s(ok);
      n = n(ok);
      s4 = s.^4;
      x = x(:,ok);
      m = nanmean(x);
      m = m(ones(row,1),:);
      sx4 = nansum((x-m) .^ 4);
      f1 = n ./ ((n-1) .* (n-2) .* (n-3) .* (s.^4));
      k(ok) = f1 .* ((n+1).*sx4 - 3 * (((n-1).^3./n) .* s4));
   end
else
   m = nanmean(x);
   m = m(ones(row,1),:);
   m4 = nanmean((x - m).^4);
   m2 = nanmean((x - m).^2);
   k = m4./m2.^2;
end
   