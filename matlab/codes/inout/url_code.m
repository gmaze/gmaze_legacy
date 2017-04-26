% url_code Percent encode/decode of a string
%
% URL = url_code(URL,[DIR])
% 
% This function will translate a string URL into
% or from percent-encoding
%
% see: http://en.wikipedia.org/wiki/Percent-encoding
%
% Created: 2009-06-16.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = url_code(varargin)

% String to encode/decode:
url = varargin{1};

% encode (0) or decode (1):
if nargin == 2
	way = varargin{2};
else
	way = 0;
end
safe_prot = 0;


if safe_prot
	is = strfind(url,'://');	
	if ~isempty(is)	
		prot = url(1:is-1);
		url = url(length(prot)+4:end);
	end
end

url = code(url,way,'%','%25');
url = code(url,way,'!','%21');
url = code(url,way,'*','%2A');
url = code(url,way,'''','%27');
url = code(url,way,'(','%28');
url = code(url,way,')','%29');
url = code(url,way,';','%3B');
url = code(url,way,':','%3A');
url = code(url,way,'@','%40');
url = code(url,way,'&','%26');
url = code(url,way,'=','%3D');
url = code(url,way,'+','%2B');
url = code(url,way,'$','%24');
url = code(url,way,',','%2C');
url = code(url,way,'/','%2F');
url = code(url,way,'?','%3F');
url = code(url,way,'#','%23');
url = code(url,way,'[','%5B');
url = code(url,way,']','%5D');
url = code(url,way,'<','%3C');
url = code(url,way,'>','%3E');

if safe_prot
if ~isempty(is)	
	url = sprintf('%s://%s',prot,url);
end
end

varargout(1) = {url};


end %function




function txt = code(txt,way,st1,st2);
	
	switch way
		case 0, txt = strrep(txt,st1,st2);
		case 1, txt = strrep(txt,st2,st1);
	end
	
end %function