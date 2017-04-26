% readh1line Read the H1 line of a matlab script file
%
% h1line = readh1line(file)
% 
% Return the H1 line of a matlab script file as a string without the trailing %.
%
% Created: 2013-07-17.
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

function tl = readh1line(mfile)

[pa na ex] = fileparts(mfile);

done = 0;
fid = fopen(mfile,'r');
fseek(fid,0,'bof');
il = 0;
tl = '';
while done ~= 1
	tline = fgetl(fid);
	if ischar(tline)
		tl = strtrim(tline);
		if ~isempty(tl)
			if tl(1) == '%'
				tl = tl(2:end);
				tl = strtrim(tl);
				tl = tl(max([1 min(strfind(tl,' '))]):end);
				% tl = strrep(tl,sprintf('%% %s',na),'');
				% tl = strrep(tl,sprintf('%%%s' ,na),'');
				% tl = strrep(tl,sprintf('%%%s' ,upper(na)),'');
				% tl = strrep(tl,sprintf('%% %s',upper(na)),'');
				% tl = strrep(tl,sprintf('%%%s' ,lower(na)),'');
				% tl = strrep(tl,sprintf('%% %s',lower(na)),'');
				% tl = regexprep(tl,sprintf('(\\w*)%%%s(\\w*)',na),'','ignorecase');
				tl = strtrim(tl);
				done = 1;				
			end
		else
			done = 1;
		end
	else
		done = 1;
	end% if 
end% end while
fclose(fid);


end %functionreadh1line