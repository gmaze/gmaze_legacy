% DimVar Return dimensions id and name of a variable
%
% [Dim_ids Dim_names Dim_length] = netcdf.DimVar(ncid,VAR)
% 
% Return dimensions id/name/length for the variable with name or id given by VAR.
% If no output are specify, results are listed on screen.
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

function varargout = DimVar(ncid,varid)

if ischar(varid)
	varid = netcdf.findVarID(ncid,varid);
end% if 

[varname,xtype,dimids,natts] = netcdf.inqVar(ncid,varid);

if ~isempty(dimids)

	for id = 1 : length(dimids)
		[dimName dimLen] = netcdf.inqDim(ncid,dimids(id));
		Dnames(id) = {dimName};	
		Dlen(id) = dimLen;
	end% for id
	
else
	Dnames = {};
	Dlen = [];
	
end% if


switch nargout
	case 1
		varargout(1) = {dimids};
	case 2
		varargout(1) = {dimids};
		varargout(2) = {Dnames};
	case 3
		varargout(1) = {dimids};
		varargout(2) = {Dnames};
		varargout(3) = {Dlen};
	otherwise
		disp(sprintf('DIMENSION(S) FOR VARIABLE: ''%s'' (id=%i)',varname,varid));
		for id = 1 : length(dimids)
			disp(sprintf('\t%i: %s (%i)',dimids(id),Dnames{id},Dlen(id)))
		end% for id
end% switch 
 

end %functionDimVar





















