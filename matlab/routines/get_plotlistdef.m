% get_plotlistdef Display/return description of diagnostic files
%
% [LIST] = get_plotlistdef(MASTER,SUBDIR)
% 
% This function display a description of pre-defined plots/diag
% available with the MASTER.m in the folder SUBDIR
%
% Example:
% get_plotlistdef('hydro_selected_O2','.');
% % will list all hydro_selected_O2_pl* matlab files
%
% Rev. by Guillaume Maze on 2009-05-29: Remove from the output diag without descriptions
%
% Created: 2006-07-12.
% Copyright (c) 2006 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = get_plotlistdef(MASTER,SUBDIR)

global sla

% Define suffixe of plot module:
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
%  iM =  findstr( strcat(SUBDIR,sla,fil) , pref ) ;
  iM =  strfind( strcat(SUBDIR,sla,fil) , pref ) ;

  if ~isempty(iM)

    % Recup description of plot module:
    fid = fopen(strcat(SUBDIR,sla,fil));
    thatsit = 0; desc = ''; req = '';
	while thatsit ~= 1
		tline = fgetl(fid);
		if tline ~= -1
			if length(tline)>4 
				switch tline(1:4) 
					case '%DEF'
						desc    = tline(5:end);
					case '%REQ'
						req     = tline(5:end);
				end%switch
				if ~isempty(desc) & ~isempty(req)
					thatsit = 1;
				end
			end %if
       else
%          desc = 'Not found';
          thatsit = 1;
       end %if
    end %while
	fclose(fid);
	if ~isempty(desc)
	    ii = ii + 1; 
	    LIST(ii).name = l(il).name;
		a = get_index(l(il).name,pref);
		ord(ii) = a;
	    LIST(ii).index = a;
		LIST(ii).description  = strtrim(desc);
		LIST(ii).requirements = strtrim(req);
	end
%    disp(strcat( num2str(LIST(ii).index),': Module extension: ',fil(length(MASTER)+2:end-2)));
%    disp(strcat('|-----> description :'  , LIST(ii).description ));
%    disp(char(2))

  end %if

end %for il

if ~exist('LIST')
  LIST= NaN;
else
	[ord iord] = sort(ord);
	for ii = 1 : length(ord)
		LI(ii) = LIST(iord(ii));
	end	
	LIST = LI;
	if nargout == 0
		for ii = 1 : length(LIST)
		    disp(sprintf('%3s) Module extension "%s" : %s',...
				 num2str(LIST(ii).index),...
				 LIST(ii).name,...
				 LIST(ii).description));
		end
	end
end

switch nargout
	case 1
		varargout(1) = {LIST};
end


end %function



function ind = get_index(name,pref);
	a = strread(strrep(name,'.m',''),'%s','delimiter',pref);
	a = unique(a);
	a = a{2};
	b = 'x';
	for ii = 1 : length(a)
		if ~isempty(str2num(a(ii)))
			b = [b a(ii)];
		end
	end
	ind = str2num(b(2:end));
end




