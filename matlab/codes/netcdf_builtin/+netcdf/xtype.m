function varargout = xtype(xt,varargin)
% xtype Corresponding value between NC_TYPE and XTYPE
%
% NC_TYPE = xtype(XTYPE) Return the NC_TYPE corresponding to XTYPE
% XTYPE = xtype(NC_TYPE) Return the XTYPE corresponding to NC_TYPE
%
% MATLAB_TYPE = xtype(XTYPE,'matlab') Return the MATLAB_TYPE corresponding to XTYPE
% XTYPE = xtype(MATLAB_TYPE) Return the XTYPE corresponding to MATLAB_TYPE
%
% XTYPE are the set of predefined netCDF external data types. It can be:
% NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, NC_FLOAT and NC_DOUBLE
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

NC_TYPES  = {'NC_BYTE','NC_CHAR','NC_SHORT','NC_INT','NC_FLOAT','NC_DOUBLE'};
MAT_TYPES = {'int8',   'char',   'int16',   'int32', 'single',  'double'};
for il = 1 : length(NC_TYPES)
	XTYPE(il) = netcdf.getConstant(NC_TYPES{il});
end% for lt 

if ischar(xt) % NC_TYPES -> XTYPE
	if nargin==2 & strcmp(lower(varargin{1}),'matlab')
		[~,ix] = intersect(MAT_TYPES,xt);
		if isempty(ix)
			error('Unknown Matlab TYPE (try with lower case or Netcdf type)')
		end% if
	else	
		[~,ix] = intersect(NC_TYPES,xt);
		if isempty(ix)
			error('Unknown Netcdf TYPE (try with upper case or Matlab type)')
		end% if 
	end% if 
	varargout(1) = {XTYPE(ix)};
else % XTYPE -> NC_TYPES
	varargout(1) = {NC_TYPES{xt}};
	if nargin==2 & strcmp(lower(varargin{1}),'matlab')
		varargout(1) = {MAT_TYPES{xt}};
	end% if 
end% if 

end %functionxtype