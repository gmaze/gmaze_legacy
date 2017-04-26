% LaTeXlist Copy a LaTeX file TeX ressources to a local folder
%
% [] = LaTeXlist(LaTeXFileName)
% 
% Sparse LaTeXFileName log file to identify all .cls, .sty and .cfg
% files required to compile LaTeXFileName, and copy them to a folder
% named: <LaTeXFileName>_LaTeX_ressources.
% A zip archive is also created.
%
% Note:
%	Any pre-existing files into LaTeXFileName_LaTeX_ressources are deleted !
%
% Created: 2011-01-29.
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

function varargout = LaTeXlist(varargin)

TeXfile = varargin{1};
TeXfile = strrep(TeXfile,'.log','');


%- 1st create a cell with all dependencies !

%-- Class, style and config files
extlist = {'.cls';'.sty';'.cfg'};
ifil = 0;

for iext = 1 : length(extlist)
	
	[sta res] = system(sprintf('grep "\\%s" %s.log > .LaTeXlist',extlist{iext},TeXfile));

	if sta == 0 	
		fid = fopen('.LaTeXlist','r');	
	    while 1
	        tline = fgetl(fid);
	        if ~ischar(tline), break, end
	%        disp(tline)
			if strcmp(tline(1),'(') 
				% I dont knwo for others, but this is how I can identify
				% a line with the file ... 
				% to be tuned for you ...
				ifil = ifil + 1;
				fil(ifil) = {strrep(strrep(tline,'(',''),')','')};
			end
	    end
	    fclose(fid);
		delete('.LaTeXlist');
	else
		error(sprintf('Cannot sparse LaTeX log file (%s), please compile and re-proceed',TeXfile));
	end	

end%for iext

%-- Figures (or anything inseerted using 'input' or 'include')
[sta res] = system(sprintf('grep "<use " %s.log > .LaTeXlist',TeXfile));
ifil2 = 0;
if sta == 0 	
	fid = fopen('.LaTeXlist','r');	
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end
%        disp(tline)
		op = strfind(tline,'<');
		cl = strfind(tline,'>');
		if ~isempty(op)	
			% I dont knwo for others, but this is how I can identify
			% a line with the file ... 
			% to be tuned for you ...
			ifil2 = ifil2 + 1;
			fil2(ifil2) = strread(tline(op(1):cl(1)),'<use %s','delimiter','>');
		end% if 
    end%while
    fclose(fid);
	delete('.LaTeXlist');
else
	error(sprintf('Cannot sparse LaTeX log file (%s), please compile and re-proceed',TeXfile));
end	

%- 2nd Copy dependencies in a local folder:
depfolder = sprintf('%s_LaTeX_ressources',TeXfile);
if exist(depfolder,'dir')
	rmdir(depfolder,'s');
end
mkdir(depfolder);

for ifil = 1 : length(fil)
	disp(sprintf('Copying %s ...',fil{ifil}))
%	system(sprintf('\\cp %s %s',fil{ifil},depfolder));
	copyfile(fil{ifil},depfolder);
end%for ifil
disp(sprintf('LaTeX dependencies have been copied into: %s',depfolder))

%- 3rd Create a zip file with all dependencies:
system(sprintf('zip -r %s.zip %s',depfolder,depfolder));
disp(sprintf('And a zip file created (%s.zip)',depfolder))

%- 4th Copy included files in a local folder:
depfolder = sprintf('%s_LaTeX_includes',TeXfile);
if exist(depfolder,'dir')
	rmdir(depfolder,'s');
end
mkdir(depfolder);

for ifil2 = 1 : length(fil2)
	disp(sprintf('Copying %s ...',fil2{ifil2}))
	copyfile(fil2{ifil2},depfolder);
end%for ifil2
disp(sprintf('LaTeX figures have been copied into: %s',depfolder))

%- 5th Create a zip file with all dependencies:
system(sprintf('zip -r %s.zip %s',depfolder,depfolder));
disp(sprintf('And a zip file created (%s.zip)',depfolder))

end %functionLaTeXlist
























