% udunits Unidata units library
%
% [INFO] = udunits(UNIT)
% 
% Standard units definitions for Unidata softwares (netcdf...) 
%
% Input:
%	UNIT is a string to look for in the database units name.
%		It is case sensitive.
%
% Output:
%	INFO is a cell of structure with fields:
%		name: Unit name
%		plural: indicates whether or not the unit name has a plural 
%			form (i.e. with an 's' appended). A 'P' indicates that 
%			the unit has a plural form, whereas, a 'S' indicates
%			that the unit has a singular form only.
%		definition: Definition for the unit.
%		comment: Any comment from the original database file
%
% Source:
%	Id: udunits.dat,v 1.18 2006/09/20 18:59:18 steve Exp $
%	http://www.unidata.ucar.edu/software/udunits/
%
% Created: 2009-09-10.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software Foundation, 
% either version 3 of the License, or any later version. This program is distributed 
% in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
% implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. You should have received a copy of 
% the GNU General Public License along with this program.  
% If not, see <http://www.gnu.org/licenses/>.
%

function varargout = udunits(varargin)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Build cell array with units:
fid=fopen('data/udunits.txt');
iunit = 0;
while 1
	tline = fgetl(fid);
	if ~ischar(tline), break, end
	if length(tline)>1
		if tline(1) ~= '#'
			iunit = iunit + 1;
			% ic = strfind(tline,'#');
			% if ~isempty(ic)
			% 	tline = tline(1:ic-1);
			% end
			t = strread(tline,'%s');
			u_name = t{1};
			u_plur = t{2}; % either P or S
			if length(t)>=3
				[u_def u_com] = clean_def(t(3:end));
			else
				u_def  = '?';
				u_com  = '';
			end
			unit_list(iunit).name       = u_name;
			unit_list(iunit).plural     = u_plur;
			unit_list(iunit).definition = u_def;
			unit_list(iunit).comment    = u_com;
%			unit_list(iunit) = [{u_name} ; {u_plur} ; {u_def}];
%			disp(sprintf('Unit: %s (plural: %s) => %s',u_name,u_plur,u_def));
%			if iunit == 100, break;end
		end
	end
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
if nargin == 1
	unit_in = varargin{1};
	def = find_unit(unit_list,unit_in);
end
% if nargin == 2
% 	unit_in  = varargin{1};
% 	unit_out = varargin{2};
% 	def     = find_def(unit_list,unit_in)
% 	def_out = find_def(unit_list,unit_out)
% end


%%%
switch nargout
	case 0
		if exist('def','var')
			if iscell(def)
				def{:}
			elseif isnan(def)
				error(sprintf('Unit %s not found',unit_in));
			end
		elseif nargin == 1
			error(sprintf('Unit %s not found',unit_in));
		else
			disp('Specify an unit to look for !')
		end
	case 1
		varargout(1) = {def};
end

end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function def = find_unit(unit_list,unit_name)
	idef = 0;
	for ii=1:length(unit_list)
		if strfind(unit_list(ii).name,unit_name)
			idef = idef + 1;
			def(idef) = {unit_list(ii)};
		end
	end
	if idef == 1, % OK
	elseif idef == 0, def = NaN;
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function def = find_def(unit_list,unit_name)
	idef = 0;
	for ii=1:length(unit_list)
		if strcmp(unit_list(ii).name,unit_name)
			idef = idef + 1;
			def(idef) = {unit_list(ii).definition};
		end
	end
	if idef == 1, % OK
	elseif idef == 0, def = NaN;
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [str1 str2] = clean_def(strC)	
	str = '%';
	for ii = 1 : length(strC)
		str = sprintf('%s %s',str,strC{ii});
	end	
	str = str(2:end);
	str = strtrim(str);
	a = strread(str,'%s','delimiter','#');
	str1 = a{1};
	if length(a) > 1
		str2 = a{2};
	else
		str2 = '';
	end
end










