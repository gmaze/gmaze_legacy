function nvlist = diag_load(DID,MFILE,varargin)
% diag_load Load data from a diagnostic
%
% [VARLIST] = diag_load(DIAG_ID,DIAG_RESULTS_FILE,[PREFIX])
%
% Load data from a diagnostic directly in the base workspace and remove
% the diagnostic ID from all variables name.
% 
% Inputs:
% 	DIAG_ID: String id of the diagnostic (eg: 'pl74')
% 	DIAG_RESULTS_FILE: String to the matlab file to load
%	PREFIX: Optional string prefix to add to all variables
% 
% Eg:
%	diag_load('pl74','north_atlantic/diag_pl74.mm.north_atlantic.ISAS13_sea.mat');
% will load 'pl74_LABELS' as 'LABELS' in the base workspace.
%
%	diag_load('pl74','north_atlantic/diag_pl74.mm.north_atlantic.ISAS13_sea.mat','ref');
% will load 'pl74_LABELS' as 'refLABELS' in the base workspace.
% 
% Copyright (c) 2015, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% For more information, see the http://codes.guillaumemaze.org
% Created: 2015-11-02 (G. Maze)

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Ifremer, Laboratoire de Physique des Oceans nor the names of its contributors may be used 
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

%- Load all data:
ds = load(MFILE);

%- Remove ID from variable name:
vlist = fieldnames(ds);
for iv = 1 : length(vlist)
	nvlist{iv} = vlist{iv};
	
	pat = sprintf('%s_',DID);		
	if strfind(vlist{iv},pat)	
		nvlist{iv} = strrep(vlist{iv},pat,'');
	end% if 
	
	pat = sprintf('_%s',DID);
	if strfind(vlist{iv},pat)		
		nvlist{iv} = strrep(vlist{iv},pat,'');
	end% if
	
	if nargin == 3
		nvlist{iv} = sprintf('%s%s',varargin{1},nvlist{iv});
	end% if 
	
	eval(sprintf('%s = getfield(ds,vlist{iv});',nvlist{iv}));		
	ds = rmfield(ds,vlist{iv});
end% for 

%- Send it to the workspace
for iv = 1 : length(nvlist)
	eval(sprintf('wssave(''%s'');',nvlist{iv}));
end% for iv

end %functiondiag_load