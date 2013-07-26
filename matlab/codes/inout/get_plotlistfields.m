% get_plotlistfields Returns the list of fields required by a diag
%
% [LIST] = get_plotlistfields(MASTER,SUBDIR)
% 
% This function returns the list of fields required by
% the modules of MASTER file in SUBDIR
%
%
% Rev. by Guillaume Maze on 2013-07-03: Get rid of variables sla, using fullfile
% Created: 2006-05-06.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%
%

function varargout = get_plotlistfields(MASTER,SUBDIR)

global sla

% Define suffixe of module:
suff = '_pl';

d = dir(SUBDIR);
ii = 0;
% Select Matlab files:
for id = 1 : length(d)
  en = length( d(id).name );
  if en~=1 & (d(id).name(en-1:en) == '.m') &  ~d(id).isdir
    ii = ii + 1;
    l(ii).name = d(id).name;
  end
end

% Select Matlab files with MASTER as prefix
ii = 0;
for il = 1 : length(l)
	fil = l(il).name;
	pref = strcat(MASTER,suff);
%	iM = findstr( strcat(SUBDIR,sla,fil) , pref );
  	iM = strfind( fullfile(SUBDIR,fil) , pref ) ;

	if ~isempty(iM)
   
		% Recup list of fields required by the module:
		fid = fopen(fullfile(SUBDIR,fil),'r');	    
		thatsit = 0; 
		clear fiel
		while thatsit ~= 1
			tline = fgetl(fid);
			if tline ~= -1
				if length(tline)>4 & tline(1:4) == '%REQ'
					tl = strtrim(tline(5:end));
					if strmatch(';',tl(end)), tl = tl(1:end-1);end
					thisreq = tl;
					tl = [';' tl ';'];
					pv = strmatch(';',tl');
					for ifield = 1 : length(pv)-1
						fiel(ifield).name = tl(pv(ifield)+1:pv(ifield+1)-1);
					end %for
					thatsit = 1;
				end %if
			else
%				fiel.name = 'Not found';
%				LIST(ii).required = fiel;
				thatsit = 1;
			end %if
		end %while
		fclose(fid);
		if exist('fiel','var')
			ii = ii + 1; 
			LIST(ii).name = l(il).name;
			LIST(ii).index = ii;
			LIST(ii).nbfields = size(fiel,2);
			LIST(ii).required = fiel;
%			disp(strcat( num2str(LIST(ii).index),': Module extension : ',fil(length(MASTER)+2:end-2)));
%		    disp(sprintf('|-----> REQ : %s'  , thisreq ));
		    % disp(sprintf('%3s) Module extension "%s" : %s',...
		    % 				 num2str(LIST(ii).index),...
		    % 				 fil(length(MASTER)+2:end-2),...
		    % 				 thisreq));
		end %if


		   %disp(char(2))
    
  end %if
  
end %for il
    
if ~exist('LIST')
  LIST= NaN;
end


switch nargout
	case 1
		varargout(1) = {LIST};
end

end %function