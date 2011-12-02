% listVarLongName List variables long name of a netcdf object
%
% [LongName_list VarName_list VarID_list] = netcdf.listVarLongName(ncid)
% 
% Give back the list of long names of all variables (not dimensions) of 
% the netcdf object ncid.
% If no output are requested, simply display the list on screen.
%
% Created: 2011-11-28.
% Copyright (c) 2011, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specific prior 
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

function varargout = listVarLongName(ncid)

[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
for iv = 1 : nvars
	varid = iv-1;
	[varname,xtype,dimids,natts] = netcdf.inqVar(ncid,varid);
	lgname = ''; % Set to an empty string, allow to use intersect on the output.
	for it = 1 : natts
		attid = it - 1;
		attname = netcdf.inqAttName(ncid,varid,attid);
		if strcmp(attname,'long_name')
			lgname = netcdf.getAtt(ncid,varid,attname);
		end% if 
	end% for it
	dstr = sprintf('\t#%3.1d: %20s [%s]',varid,varname,lgname);	
%	namelist_disp(iv) = {sprintf('%20s: %s',varname,lgname)};
	namelist_disp(iv) = {dstr};
	namelistIO(iv) = {lgname};
	namelist0(iv)  = {varname};
	namelistID(iv) = varid;
end% for iv
[namelist0 is] = sort(namelist0);
namelist_disp = namelist_disp(is);
namelistIO    = namelistIO(is);
namelistID    = namelistID(is);

switch nargout
	case 0
		s = sep;
		disp(sep('-',' VARIABLE''S  LONG NAME '))
		disp(sprintf('\t#IDS: %20s [%s]','VARIABLE NAME','LONG NAME'));
		disp(s(1:fix(length(s)/2)));
		for iv=1:length(namelist_disp)
			disp(namelist_disp{iv})
		end% for iv
		disp(s)
	case 1
		varargout(1) = {namelistIO};
	case 2
		varargout(1) = {namelistIO};
		varargout(2) = {namelist0};
	case 3
		varargout(1) = {namelistIO};
		varargout(2) = {namelist0};
		varargout(3) = {namelistID};
		
		
end% switch 




end %functionlistVarLongName















