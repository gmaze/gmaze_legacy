% get_pyc Compute pycnocline characteristics
%
% pyc = get_pyc([ARG,VAL],...)
% 
% HELPTEXT
%
% Created: 2013-05-10.
% Copyright (c) 2013, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
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
%

function varargout = get_pyc(varargin)

%- Load user options:
if nargin~= 0
	if mod(nargin,2) ~=0
		error('Arguments must come in pairs: ARG,VAL')
	end% if 
	for in = 1 : 2 : nargin
		eval(sprintf('%s = varargin{in+1};',varargin{in}));
	end% for in
end% if

z = z(:)';
temp = temp(:)';
psal = psal(:)';

%- First guess:
[pe mld] = get_pyc_idvgrads_v2b(varargin{:},'z',z,'temp',temp,'psal',psal);				

% THD looks shallow, try to improve with less smoothing:
testA = false;
if pe.depth > -300 | (pe.qc == 20 | pe.qc == 31)
	[pe mld] = get_pyc_idvgrads_v2b(varargin{:},'z',z,'temp',temp,'psal',psal,'dz',dz/2,'zscal',zscal/2);
	testA = true;
end% if

% The 1st inflexion point is to close to the top (qc=20) or the top gaussian is not well resolved (qc=31), 
% try to look deeper, by changing the Maximum depth of the mode water:
testB = false;
if pe.qc == 20 | pe.qc == 31
	testB = true;
	if testA
		[pe mld] = get_pyc_idvgrads_v2b(varargin{:},'z',z,'temp',temp,'psal',psal,'dz',dz/2,'zscal',zscal/2,'core_top',core_top - 200);
	else					
		[pe mld] = get_pyc_idvgrads_v2b(varargin{:},'z',z,'temp',temp,'psal',psal,'core_top',core_top - 200);					
	end% if 

	% Again ?, try to look to other way then:
	testC = false;
	if pe.qc == 20 | pe.qc == 31 
		testC = true;
		if testA
			[pe mld] = get_pyc_idvgrads_v2b(varargin{:},'z',z,'temp',temp,'psal',psal,'dz',dz/2,'zscal',zscal/2,'core_top',core_top + 200);					
		else
			[pe mld] = get_pyc_idvgrads_v2b(varargin{:},'z',z,'temp',temp,'psal',psal,'core_top',core_top + 200);					
		end% if 
	end% if
end% if

if pe.qc == 22 % ixtop == 1, we may not be looking shallow enough
	if testA
		[pe mld] = get_pyc_idvgrads_v2b(varargin{:},'z',z,'temp',temp,'psal',psal,'dz',dz/2,'zscal',zscal/2,'core_top',below + 20);					
	else
		[pe mld] = get_pyc_idvgrads_v2b(varargin{:},'z',z,'temp',temp,'psal',psal,'core_top',below + 20);					
	end% if 
end% if


%- Output
varargout(1) = {pe};

end %functionget_pyc