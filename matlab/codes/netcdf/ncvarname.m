% ncvarname List variable name of a netcdf object
%
% namelist = ncvarname(nc)
% 
% Give back the list of names of all variables of the netcdf object nc
%
% Created: 2009-10-20.
% Copyright (c) 2009, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = ncvarname(varargin)

switch ncbuiltin
	case 0
		nc = varargin{1};
		if ~isa(nc,'netcdf')
			error('ncvarname only take as argument a netcdf object')
		end

		v = var(nc);
		for iv = 1 : length(v)
			namelist(iv) = {name(v{iv})};
		end
		namelist = sort(namelist);

	case 1
		ncid = varargin{1};	
		switch ischar(ncid)
			case 1
				ncid    = netcdf.open(ncid,'NC_NOWRITE');
				closeit = true;
			case 2
				closeit = false;
		end% switch 
		[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);		
		for iv = 1 : nvars
			[varname, xtype, dimids, atts] = netcdf.inqVar(ncid,iv-1);
			namelist(iv) = {varname};
		end% for iv		
		namelist = sort(namelist);
		
		if closeit
			netcdf.close(ncid);
		end% if 
		
end% switch 

if nargout == 0
	for iv=1:length(namelist)
		disp(namelist{iv})
	end
else
	varargout(1) = {namelist};
end

end %functionncvarname