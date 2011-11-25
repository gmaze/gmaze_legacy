% findVarID Find a VarID
%
% VARID = netcdf.findVarID(NCID,VARNAMELIST)
% 
% Find VARID of the variable name given in VARNAMELIST in the netcdf pointer NCID.
%
% 'VARNAMELIST' is a cell of string, so that it can contains more than version of 
% the variable name. This is usefull in case you don't exactly know the name
% of the variable or want to use the same script to retrieve the same variable but
% named differently.
%
% Note that 
%	netcdf.findVarID(ncid,'time')
% will return the same id as:
%	netcdf.inqVarID(ncid,'time')
%
% Example:
%	ncid = netcdf.open('myfile.nc','NC_NOWRITE');
%	netcdf.findVarID(ncid,'time')
%	netcdf.findVarID(ncid,{'t','time'})
%
% Created: 2011-11-25.
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

function dimid = findVarID(ncid,vlist)

	if ischar(vlist)
		vlist = {vlist};
	end% if 
	
	found = false;
	dimid = [];
	for ii = 1 : length(vlist)
		if ~found
			try
				dimid = netcdf.inqVarID(ncid,vlist{ii});  
				found = true;
			end%try
		end% if 
	end% for ii

end %functionfindVarID