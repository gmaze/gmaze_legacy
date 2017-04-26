% dispt Display a table on prompt
%
% [LINES] = dispt(C,[OPTIONS]);
% 
% Custom matrix display on prompt of double matrix C.
%
% OPTIONS are paired like: OPTION_NAME,OPTION_VALUE
%
% List of OPTIONS:
%	numform (string): Numerical format used to display values of C.
%		Default value: %0.2f
%	rowT: Title of rows to appear in the upper left table.
%	colT: Title of columns to appear in the upper left table.
%	rowl: Row labels.
%	coll: Column labels.
%		About rowl and coll:
%			They can be a string with a char for each column or row.
%			They can be a single char, in this case the rol/col number is added
%			They can be a cell of one string where the key '#r' will be replaced
%				byv the rol/col number
%			Or they can be a cell of strings for each column or row.
%	dohline (logical): Insert a horizontal line between each row.
%		Default value: false
%	col1w (integer): Width of the first column.
%		Default value: 12
%	colw (integer): Width of each columns.
%		Default value: 10
%   verb (integer): Determine how the table should be displayed:
% 			0: no display, a cell array of strings is returned
% 			1: display in the command window 
% 			2: no display, a cell array of LaTeX strings is returned
% 			3: display in the command window as a LaTeX array
%		Default value: 1
%
% Outputs:
%	LINES is a cell with each lines displayed on prompt as a row.
%
% Examples:
%	dispt(randn(4,6),'numform','%0.3f')
%	dispt(randn(4,6),'colT','Columns','rowT','Rows')
%	dispt(randn(4,6),'colT','Columns','rowT','Rows','col1w',20)
%	dispt(randn(4,6),'coll','abcdef')
%	dispt(randn(4,6),'coll',{'Column number #r'})
%	dispt(randn(4,3),'coll',{'Column number #r'},'rowl',{'Row number #r'},'colw',20,'col1w',20)
%
% Created: 2010-06-10.
% Revised: 2014-05-17 (G. Maze) added the 'verb' option
% Copyright (c) 2010, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org
% Revised: 2014-10-17 (G. Maze) Added verb 2/3 for LaTeX tables

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

function varargout = dispt(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Matrix to display:
C = varargin{1};
[nr nc] = size(C);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Default values:
% Numerical format (used by sprintf) to print datas:
numform = '%0.2f';

% Width of content columns:
colw  = 10; 

% Columns labels:
for ic = 1 : nc
	coll(ic) = {sprintf('%i',ic)}; 
end

% Columns title:
colT  = 'col. nb'; % Text in the first column of the 1st line (title of columns)

% 1st column width:
col1w = 12; % Default width of the first column with labels

% Rows labels:
for ir = 1 : nr
	rowl(ir) = {sprintf('%i',ir)};
end

% Rows title:
rowT = 'row nb';

% Insert a horizontal line between each rows:
dohline = false;

% Really print result ?
verb = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Load user custom values:
if nargin > 1
	for iv = 2 : 2 : nargin
		arginlist(iv) = varargin(iv);
		eval(sprintf('%s = varargin{iv+1};',varargin{iv}));
	end%for iv
end

%%%%%%%%%%%%%%%%%%%% Process specific options:
if nargin > 1

	if ~isempty(intersect(arginlist(2:2:end),'rowl'))
%		disp('using your rowl');
		switch class(rowl)
			case 'cell'
				if length(rowl) == 1					
					r0 = rowl{1};
					if ~ischar(r0)
						error('Row labels must a cell of string');
					end
					% Try to identify the row number key:
					for ir = 1 : nr
						rowl(ir) = {strrep(r0,'#r',sprintf('%i',ir))};							
					end
				elseif length(rowl) ~= nr
					error('Row labels size doesn''t match matrix size');
				else
					for ir = 1 : length(rowl)
						rowl(ir) = {strrep(rowl{ir},'#r',sprintf('%i',ir))};
					end
				end
			case 'char'
				if length(rowl) >= nr
					% Use one char per row
					r0 = rowl; clear rowl
					for ir = 1 : nr
						rowl(ir) = {r0(ir)};
					end
				elseif length(rowl) == 1
					r0 = rowl; clear rowl
					for ir = 1 : nr
						rowl(ir) = {sprintf('%s %i',r0,ir)};
					end	
				elseif length(rowl) < nr
					error('Row labels string must match number of rows or be of length 1');								
				end	
			case 'double'
				error('Row labels must be a string or a cell of strings');
		end
	end
	
	if ~isempty(intersect(arginlist(2:2:end),'coll'))
%		disp('using your coll');
		switch class(coll)
			case 'cell'
				if length(coll) == 1					
					r0 = coll{1};
					if ~ischar(r0)
						error('Column labels must a cell of string');
					end
					% Try to identify the col number key:
					for ir = 1 : nc
						coll(ir) = {strrep(r0,'#r',sprintf('%i',ir))};							
					end
				elseif length(coll) ~= nc
					error('Column labels size doesn''t match matrix size');
				else
					for ic = 1 : length(coll)
						coll(ic) = {strrep(coll{ic},'#r',sprintf('%i',ic))};
					end
				end
			case 'char'
				if length(coll) >= nc
					% Use one char per col
					r0 = coll; clear coll
					for ic = 1 : nc
						coll(ic) = {r0(ic)};
					end
				elseif length(coll) == 1
					r0 = coll; clear coll
					for ic = 1 : nc
						coll(ic) = {sprintf('%s %i',r0,ic)};
					end	
				elseif length(coll) < nc
					error('Column labels string must match number of columns or be of length 1');
				end	
			case 'double'
				error('Column labels must be a string or a cell of strings');
		end
	end
	
end%if

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
if isempty(colT) & isempty(rowT)
	notitles = true;
else
	notitles = false;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Init output
iline = 0;
tablstr = {};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create hline:
hline = '-'; 
for ic = 1 : col1w + 2, hline = sprintf('%s-',hline); end
for ic = 1 : nc*colw + nc-1
	hline = sprintf('%s-',hline);
end

if notitles
	hline2 = ' '; 
	for ic = 1 : col1w, hline2 = sprintf('%s ',hline2); end
	for ic = 1 : nc*colw + nc + 1
		hline2 = sprintf('%s-',hline2);
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TABLE HEADER:
switch notitles
	case false
		tablstr = dispp(verb,hline,tablstr); % Start with a horizontal line
	
		%%%%%% First line is the columns title
		str = sprintf('|\\%s',algn(colT,'','center',col1w-1)); % First row
		for ic = 1 : nc
			str = sprintf('%s|%s',str,algn('','','center',colw));
		%	str = sprintf('%s|%s',str,algn(coll{ic},'','center',colw));
		end,
		str = sprintf('%s|',str);
		tablstr = dispp(verb,str,tablstr); 
	
		%%%%%% Second line is columns labels
		% First col:
		str = '| \';
		for ii = 1 : col1w-4
			str = sprintf('%s-',str);
		end,str = sprintf('%s\\ ',str);
		% other cols:
		for ic = 1 : nc
			str = sprintf('%s|%s',str,algn(coll{ic},'','center',colw));
		end,
		str = sprintf('%s|',str);
		tablstr = dispp(verb,str,tablstr); ;

		%%%%%% Third line is rows title:
		str = sprintf('|%s\\',algn(rowT,'','center',col1w-1)); % First row
		for ic = 1 : nc
			str = sprintf('%s|%s',str,algn('','','center',colw));
		end,
		str = sprintf('%s|',str);
		tablstr = dispp(verb,str,tablstr); ;

		tablstr = dispp(verb,hline,tablstr); ; % End with a horizontal line
		
	case true
		tablstr = dispp(verb,hline2,tablstr); ; % Start with a horizontal line
	
		%%%%%% First line is the columns title
		if 0
			str = sprintf('  %s',algn('','','center',col1w-1)); % First row
			for ic = 1 : nc
				str = sprintf('%s|%s',str,algn('','','center',colw));
			%	str = sprintf('%s|%s',str,algn(coll{ic},'','center',colw));
			end,
			str = sprintf('%s|',str);
			tablstr = dispp(verb,str,tablstr);
		end
		
		%%%%%% Second line is columns labels
		% First col:
		str = '   ';
		for ii = 1 : col1w-4
			str = sprintf('%s ',str);
		end,str = sprintf('%s  ',str);
		% other cols:
		for ic = 1 : nc
			str = sprintf('%s|%s',str,algn(coll{ic},'','center',colw));
		end,
		str = sprintf('%s|',str);
		tablstr = dispp(verb,str,tablstr); ;

		%%%%%% Third line is rows title:
		if 0
			str = sprintf(' %s ',algn('','','center',col1w-1)); % First row
			for ic = 1 : nc
				str = sprintf('%s|%s',str,algn('','','center',colw));
			end,
			str = sprintf('%s|',str);
			tablstr = dispp(verb,str,tablstr); 
		end
		tablstr = dispp(verb,hline,tablstr); ; % End with a horizontal line
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TABLE CONTENT:
%% Now display each rows
for ir = 1 : nr
	str = sprintf('|%s',algn(rowl{ir},'','center',col1w));
	for ic = 1 : nc
		if isa(C,'cell')
			v = eval(sprintf('sprintf(''%s'',C{ir,ic})',numform));
		else
			v = eval(sprintf('sprintf(''%s'',C(ir,ic))',numform));
		end% if 
		str = sprintf('%s|%s',str,algn(v,'','center',colw));		
	end%for ic
	str = sprintf('%s|',str);
	tablstr = dispp(verb,str,tablstr); ;	
	if dohline,tablstr = dispp(verb,hline,tablstr); ;end
end%for it
if ~dohline,tablstr = dispp(verb,hline,tablstr); ;end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
if nargout == 1
	varargout(1) = {tablstr};
end


end %functiondispt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function tablstr = dispp(verb,str,tablstr);
	% All the printing comes here !
	switch verb
		case 0 % No display, return matlab string
		case 1 % Matlab Display
			disp(str)
		case {2,3} % LaTeX 
			str = strrep(str,'\',' ');
			if strcmp(str(end),'|') % Standard line
				str(end) = '';
				str = sprintf('%s\\\\',str(1:end-1));
			end% if
			if strcmp(str(1),'|') % Standard line
				str(1) = ' ';
			end% if 
			if strcmp(unique(str),'-') % Horizontal line
				str = '\hline';
			end% if 
			str = strrep(str,'|','&');
			if verb == 2
				% No display, return LaTeX string
			else
				% LaTeX display
				disp(str);
			end% if 
	end% if 
	tablstr = cat(1,tablstr,str);
	
	
end%fcuntion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function str = algn(str,sep,aln,n)
	if length(str) > n
		str = [str(1:n-3) '...'];
	end
	str = [sep eval(sprintf('strjust(sprintf(''%%%is'',str),aln)',n)) sep];
end %function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 