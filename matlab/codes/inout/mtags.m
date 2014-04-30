% mtags Read/write tags to Matlab function header section
%
% tags_list = mtags(FILE)
% 	Read the list of tags documented in a Matlab script FILE
% 
% tags_list = mtags(FILE,'add',TAGS)
% 	Add TAGS to the list of tags documented in Matlab script FILE
%
% tags_list = mtags(FILE,'remove',TAGS)
% 	Remove TAGS from the list of tags documented in Matlab script FILE
%
% bool = mtags(FILE,'has',TAGS)
% bool = mtags(FILE,'hasany',TAGS)
% 	Return true if one of TAGS is listed in tags documented in Matlab script FILE
%
% bool = mtags(FILE,'hasall',TAGS)
% 	Return true if all TAGS are listed in tags documented in Matlab script FILE
%
% Note that all methods pointing to a function are supported:
% 	mtags(@stophere)
% 	mtags('stophere')
% 	mtags(which('stophere'))
% 
% Created: 2013-12-09.
% Copyright (c) 2013, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

%TAGS tag,help,documentation
 
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

function varargout = mtags(varargin)

switch nargin
	case 1
		fname = varargin{1};
		tags_list = read_all_tags(fname);
		varargout(1) = {tags_list};
	case 3
		fname   = varargin{1};
		test    = varargin{2};
		tags_in = varargin{3}; if isa(tags_in,'char'), tags_in = {tags_in}; end% if 		
		tags_list = read_all_tags(fname);
		switch test
			case {'has','hasany'}
				[c1 ia1 ib1] = intersect(tags_in,tags_list);
				if isempty(c1)
					varargout(1) = {false};
					if nargout == 2, varargout(2) = {}; end
				else
					varargout(1) = {true};
					if nargout == 2, varargout(2) = {tags_in(ia1)}; end
				end% if 
			otherwise
				error('Not implemented yet !');			
		end%switch
	otherwise
		error('Not implemented yet !');
end% switch 

end %functionmtags

function tags_list = read_all_tags(varargin)
	
	fname = varargin{1};
	if isa(fname,'function_handle')
		io = functions(fname);
		fname = io.file;
	end% if 
	
	switch exist(fname)
		case 2
			fname = which(fname); % This will return the file even if fname is already the path to it
		otherwise
			error(sprintf('Function %s does not exist !',fname));			
	end% switch 

	% Read lines from input file
	fid = fopen(fname,'r');	
	if fid < 0
		stophere
		error(sprintf('Cannot read file: %s',fname));
	end% if
	C = textscan(fid, '%s', 'Delimiter', '\n');
	fclose(fid);
	
	% Search a specific string and find all rows containing matches
	ilines = find(~cellfun('isempty', strfind(C{1}, '%TAGS')));
	if ~isempty(ilines)
		tline = C{1}{ilines(1)};
		l = textscan(strrep(tline,'%TAGS',''),'%s','delimiter',',');
		tags_list = l{1};
	else	
		tags_list = {};		
	end% if 


end%function

function tags_list = read_all_tags_v0(varargin)
	
	fname = varargin{1};
	if isa(fname,'function_handle')
		io = functions(fname);
		fname = io.file;
	end% if 
	
	switch exist(fname)
		case 2
			fname = which(fname); % This will return the file even if fname is already the path to it
		otherwise
			error(sprintf('Function %s does not exist !',fname));			
	end% switch 



	fid = fopen(fname,'r');
	if fid < 0
		stophere
		error(sprintf('Cannot read file: %s',fname));
	end% if 
	fseek(fid,0,'bof');
	tags_list = {};
	done = 0;
	il = 0;
	while done ~= 1
		tline = fgetl(fid);
		if ~ischar(tline)
			done = 1;
		else%if ~isempty(tline)
			tl   = strtrim(tline)
			if length(tl) > 5
				if strcmp(tl(1:5),'%TAGS')
					l = textscan(strrep(tl,'%TAGS',''),'%s','delimiter',',');
					tags_list = l{1};
					done = 1;
				end% if 
			else
				done = 1;
			end% if 
		%else
		%	done = 1;			
		end% if 

	end%while	
	
end%function