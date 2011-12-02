% listVar List all variables of a netcdf
%
% [] = netcdf.listVar(ncid)
% 
% List all variables of a netcdf
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

function varargout = listVar(ncid)

[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);

for iv = 1 : nvars
	varid = iv-1;
	[varname,xtype,dimids,natts] = netcdf.inqVar(ncid,varid);
	[Dim_ids Dim_names Dim_length] = netcdf.DimVar(ncid,varid);	
	dim_str = '';
	for id = 1 : length(Dim_ids)
		str = sprintf('(%s=%i)',Dim_names{id},Dim_length(id));
		if length(Dim_ids) == 1
			dim_str = sprintf('%s',str);
		elseif id == length(Dim_ids)
			dim_str = sprintf('%s %s',dim_str,str);
		else
			dim_str = sprintf('%s %s x',dim_str,str);
		end% if 
	end% for 
	dstr = sprintf('\t#%3.1d: %20s [%s]',varid,varname,dim_str);
	RESdisp(iv) = {dstr};
	Vnames(iv) = {varname};
	Vids(iv)   = varid;
end% for iv
[Vnames is] = sort(Vnames);
RESdisp = RESdisp(is);
Vids    = Vids(is);

switch nargout
	case 1
		varargout(1) = {Vnames};
	case 2
		varargout(1) = {Vnames};
		varargout(2) = {Vids};
	otherwise
		s = sep;
		disp(sep('-',' LIST OF VARIABLE(S) '))	
		disp(sprintf('\t#IDS: %20s [%s]','VARIABLE NAME','(DIMENSION NAME = LENGTH)'))			
		disp(s(1:fix(length(s)/2)));
		for iv = 1 : nvars
			disp(RESdisp{iv});
		end% for iv
		disp(s);
end% switch 



end %functionlistVar

















