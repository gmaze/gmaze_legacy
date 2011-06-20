% GETCOMPUTERNAME returns the name of the computer (hostname)
%
% name = getComputerName()
%
% WARN: output string is converted to lower case
%
% See also SYSTEM, GETENV, ISPC, ISUNIX
%


function name = getcomputername()

[ret, name] = system('hostname');   
name = strrep(name,'.cshrc: No such file or directory.','');

if isempty('name')
   if ispc
      name = getenv('COMPUTERNAME');
   else      
      name = getenv('HOSTNAME');
      if strcmp(name,'hostname')
		name = getenv('HOST');
      end	
   end
end
name = lower(name);
name = strrep(name,' ','');
name = urlencode(name);
name = strrep(name,'%0A','');
name = strrep(name,'%20','');
name = urldecode(name);

