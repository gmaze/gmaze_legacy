% packver Manage Package Version file
%
% pack_info = packver(PACK_DIR,ACTION,{'PROP','VAL'},{'PROP','VAL'},...)
% 
% Manage a Package Version file version.ver
%
% Inputs:
%	PACK_DIR: path to package
%	ACTION: 
%		'r': read package version information
%		'w': create version.ver version file
%		'u': update any property of the version file
%	PROP: One of the following properties:
%		'Name' with VAL (string): Package description
%		'Version' with VAL (string): Package version
%		'Release' with VAL (string): Older Matlab release compatible with the package
%		'Date' with VAL (datenum): Last update of the package
%
% Outputs:
%	pack_info: a structure with package informations.
%
% Created: 2010-04-15.
% Rev. by Guillaume Maze on 2011-03-04: Changed default package characteristics
% Copyright (c) 2010, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = packver(varargin)

packdir = varargin{1};
action  = varargin{2};

% Default 
%proplist = struct('Name',{'?'},'Version',{'0'},'Release',{'0'},'Date',{datenum(1900,1,1)});
proplist = struct('Name',{packdir},'Version',{'1'},'Release',{'1'},'Date',{now});

% Load
for ip = 1 : nargin-2
	ar = varargin{ip+2};
	switch lower(ar{1})
		case {'description','desc','name'}
			proplist.Name = ar{2};
		case {'version','ver'}
			proplist.Version  = ar{2};
		case {'date','dat'}
			proplist.Date = ar{2};
		case {'Release','rel'}
			proplist.Release = ar{2};
		otherwise
			error('Unknown property for Package version file')
	end%switch
end%for ip

packfilename = 'version.ver';
packfile     = sprintf('%s/%s',packdir,packfilename);

% File fid
switch action
	case {'w','c'} % Create
		fid = fopen(packfile,'w');
		fprintf(fid,'%s\nVersion %s (%s) %s',proplist.Name,proplist.Version,proplist.Release,datestr(proplist.Date,'dd-mmm-yyyy'));
		fclose(fid);		
		
	case 'r' % Read
		fid = fopen(packfile,'r');
		proplist.Name = fgetl(fid);
		a = fgetl(fid); a = strrep(a,'Version','');
		b = strread(a,'%s','delimiter',' ');
		proplist.Version = b{1};
		proplist.Release = strrep(strrep(b{2},'(',''),')','');
		proplist.Date = datenum(b{3},'dd-mmm-yyyy');
		fclose(fid);
		varargout(1) = {proplist};
		
	case 'u' % Update
		
		% Read old properties:
		fid = fopen(packfile,'r');
		proplist0.Name = fgetl(fid);
		a = fgetl(fid); a = strrep(a,'Version','');
		b = strread(a,'%s','delimiter',' ');
		proplist0.Version = b{1};
		proplist0.Release = strrep(strrep(b{2},'(',''),')','');
		proplist0.Date = datenum(b{3},'dd-mmm-yyyy');
		fclose(fid);
		
		% Update:
		if strcmp(proplist.Name,'?')
			proplist.Name = proplist0.Name;
		end
		if strcmp(proplist.Version,'0')
			proplist.Version = proplist0.Version;
		end
		if strcmp(proplist.Release,'0')
			proplist.Release = proplist0.Release;
		end
		if proplist.Date==datenum(1900,1,1)
			proplist.Date = proplist0.Date;
		end

		fid = fopen(packfile,'w');
		fprintf(fid,'%s\nVersion %s (%s) %s',proplist.Name,proplist.Version,proplist.Release,datestr(proplist.Date,'dd-mmm-yyyy'));
		fclose(fid);		
end

% 

end %functionpackver






