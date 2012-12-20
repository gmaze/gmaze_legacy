% update_codes Update meta informations for my Matlab Codes
%
% [] = update_codes()
% 
% HELP:
% How to update my google code setup for matlab/codes ?:
%	% Run:
%	update_codes
%
%	% Then copy '~/matlab/codes/wiki/*' to '~/work/Contributions/code.google.com/guillaumemaze_wiki/'
%	% launch svnx, open working copies of Google code wiki pages
%	% Then update, remove or add files and click on commit !
%
% How to build a local setup ?:
%	tbcont('~/matlab/routines','link_pref','/Users/gmaze/matlab/','link_wiki','/Users/gmaze/matlab/routines/wiki')
%	tbcont('~/matlab/hydrolpo','link_pref','/Users/gmaze/matlab/','link_wiki','/Users/gmaze/matlab/hydrolpo/wiki','link_rel','hydrolpo')
%
% Created: 2011-03-04.
% Rev. by Guillaume Maze on 2012-12-20: Updated local paths to new configuration on 'airchassiron'
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

function varargout = update_codes(varargin)

%- Create the big content and wiki pages:
tbcont('~/matlab/codes/','link_rel','codes','ndepth',1,'overw_contentsm',1);

%- Remove wiki pages with personal data:
delete('~/matlab/codes/wiki/matlab_codes_off*');
delete('~/matlab/codes/wiki/matlab_codes_mcentral*');
%delete('~/matlab/codes/wiki/matlab_codes_custom*');

%- Also create a toc for each individual package:
subl = {'custom';'colors';'geophysic';'graphicxFigures';'graphicxPlots';'inout';'matrix';'netcdf';'overwrite';'statistics';'mcentral'};
for id = 1 : length(subl)
% 	system(sprintf('\\rm %s',abspath(sprintf('~/matlab/codes/%s/help/',subl{id}))))
% 	system(sprintf('\\rm %s',abspath(sprintf('~/matlab/codes/%s/wiki/',subl{id}))))
	packver(sprintf('~/matlab/codes/%s',subl{id}),'w',{'Name',sprintf('MY CODES: %s',upper(subl{id}))});
	tbcont(sprintf('~/matlab/codes/%s',subl{id}),'link_rel',sprintf('codes/%s',subl{id}),'ndepth',0,'do_single_html',0,'do_single_wiki',0,'overw_contentsm',1);
end

%- Update wiki pages
system('\cp ~/matlab/codes/wiki/* ~/work/Contributions/code.google.com/guillaumemaze_wiki/');
%pushd('~/work/Contributions/code.google.com/guillaumemaze_wiki/');
%system('svn add matlab_codes*');
%system('svn update matlab_codes*');
%system('svn commit -m "Update to matlab codes wikipages" ');
%popd;


end %functionupdate_codes















