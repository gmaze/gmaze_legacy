function day = datevec2doy(mydate)
% Takes a date vector and returns the day of year, known incorrectly in the
% Geophysical community as the julian calender day, i.e. 12/31/2005
% is returned as day 365, day 06/22/2010 is returned as 173, etc... The
% function is vectorized. This function needs etime.m (R2009a and later).
% 
% USAGES
% julday = datevec2doy(mydate)
% 
% INPUT
% mydate:   Either a 6xN or Nx6 array of date vectors, as output by
%           functions like datevec.
% 
% OUTPUT
% julday:   An Nx1 array of julian days.
% 
% -----------------------------------------------------------------------
% EXAMPLE
% %Take the current day and add normally distributed random days to the
% %date.
% 
% tadd          = randn(1,12);
% mydate        = datevec(now)';
% mydate        = repmat(mydate,1,12);
% mydate(2,:)   = mydate(2,:) + tadd;
% day           = datevec2doy(mydate);
% -----------------------------------------------------------------------
% Latest Edit: 24.June.2010
% Joshua D Carmichael
% josh.carmichael@gmail.com
%-----------------------------------------------------------------------

[M,N]   = size(mydate);
ind     = [M,N]==[6,6];

if( nnz(ind) < 1 )
    
    error('MATLAB:datevec2doy', 'Input is not in date vector format');
    
end;

if(ind(1))
    
    mydate = mydate';
    
end;

doy         = mydate;
doy(:,2:3)  = 1;
doy(:,4:6)  = 0;

if(length(mydate) <= 6)
    
    day         = 1+floor(etime(mydate,doy)./(3600*24));
    
elseif(length(mydate) > 6)
    
    A       = mat2cell(doy,ones(size(doy,1),1),6);
    B       = mat2cell(mydate,ones(size(doy,1),1),6);
    dt      = cellfun(@etime,B,A);
    day     = 1+floor((dt)./(3600*24));
    
else
    
    error('Matlab:etime','Not a date format');
    
end;

return