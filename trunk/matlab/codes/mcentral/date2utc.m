function utc=date2utc(datenumber,Timezone);
% Converts matlab date-time format to Coordinated Universal Time (UTC) to 
% UTCtime eg. 3153496080 is 05-Dec-2003 20:08:00 (In GMT +01:00)
% Timezone eg. =1 when in GMT +01:00 (Sweden, Vienna etc)
% If Timezone not given this use information from the registry(WIN*)
% IO:
% time_ml_format=utc2date(UTCtime,Timezone);

% Anders Björk KTH Chemistry, Analytical 06-Dec-2003 20:08:00
% KTH - Royal Institute of Technology, Stockholm, Sweden

% (UTC is counting from 1904-1-1 12 AM)

if ispc
    % Thanks to us for providing this code in CSSM for getting timezon
    % data.
    rk='HKEY_LOCAL_MACHINE';
    sk=['system\currentcontrolset\'...
            'control\timezoneinformation'];
    n=winqueryreg('name',rk,sk);
    for i=1:length(n)
        try
            ent=winqueryreg(rk,sk,n{i});
            
        catch
            ;
        end
    end
    
    if nargin<2
        Timezone=-double(winqueryreg(rk,sk,n{8}))/60.0000000000; % GMT +1 zone
    end
    
else
    if nargin<2
        Timezone=1; % GMT +1 zone
	    warning('Using default timezone (GMT +1) because you are running on a non PCcomputer.');
    end   
end

seconds_per_day=3600*24;

% Matlab has 1-Jan-0000 as reference day and utc is in seconds,
% here we calculate time from 0000 to 1904
baseutc=datenum(1904,1,1,Timezone,0,0).*seconds_per_day; 
% Calculating the matlab format
utc=datenumber*seconds_per_day-baseutc;

