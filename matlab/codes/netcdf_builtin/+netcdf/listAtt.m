function varargout = listAtt(ncid,varid)
% listAtt List all Attributes of a variable
%
% [AttName, AttIDs, AttNCtype] = listAtt(ncid,var[id])
% 
% List all Attributes of a variable. If no output required displau list on screen
%
% Inputs:
% 	ncid: netcdf scope of the variable
% 	var[id]: Variable name (string) or ID (int). 
% 		It can also be 'NC_GLOBAL' for global variables
%
% Outputs:
%	AttName: Cell of Attribute's name (string)
% 	AttIDs: Attribute's IDs (int)
% 	AttXtype: Cell of Attribute's NC_TYPE (string)
% 
% Eg:
%	listAtt(ncid,3)
%	listAtt(ncid,'TEMP')
%	listAtt(ncid,'GLOBAL')
% 
% See Also: listVar
%
% Copyright (c) 2016, Guillaume Maze (Ifremer, Laboratoire d'Océanographie Physique et Spatiale).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2016-04-14 (G. Maze)

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Ifremer, Laboratoire d'Océanographie Physique et Spatiale nor the names of its contributors may be used 
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

if ischar(varid)
	if strcmp(varid,'NC_GLOBAL') | strcmp(varid,'GLOBAL')
		varid = netcdf.getConstant('NC_GLOBAL');
	else
		varid = netcdf.findVarID(ncid,varid);
	end% if 
end% if

if ischar(ncid)
	error('Invalid ncid')
end% if 

trashed = false;
attid = 0;
while ~trashed
	try
		attname = netcdf.inqAttName(ncid,varid,attid);
		[xtype,attlen] = netcdf.inqAtt(ncid,varid,attname);
		attype = netcdf.xtype(xtype);
		it = attid+1;
		Anames{it} = attname;
		Aids{it} = attid;
		Atype{it} = attype;
		dstr = sprintf('\t#%3.1d: %20s [%s]',attid,attname,attype);
		RESdisp(it) = {dstr};
	catch	
		trashed = true;
	end% try
	attid = attid + 1;
end% for it

switch nargout
	case 1
		varargout(1) = {Anames};
	case 2
		varargout(1) = {Anames};
		varargout(2) = {Aids};
	case 3
		varargout(1) = {Anames};
		varargout(2) = {Aids};
		varargout(3) = {Atype};
	otherwise
		if varid == netcdf.getConstant('NC_GLOBAL')
			varname = 'NC_GLOBAL';
			disp(sep('-',sprintf(' LIST OF GLOBAL ATTRIBUTE(S) ')))			
		else
			varname = netcdf.inqVar(ncid,varid);
			disp(sep('-',sprintf(' LIST OF ATTRIBUTE(S) FOR %s ',varname)))			
		end% if 
		disp(sprintf('\t#IDS: %20s [%s]','ATTRIBUTE''S NAME','TYPE'))
		sep
		for iv = 1 : it
			disp(RESdisp{iv});
		end% for iv
		sep
end% switch 


end %functionlistAtt