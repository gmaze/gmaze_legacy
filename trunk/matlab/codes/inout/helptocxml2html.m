% helptocxml2html H1LINE
%
% [] = helptocxml2html()
% 
% HELPTEXT
%
% Created: 2010-06-12.
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

function varargout = helptocxml2html(varargin)

xmlfile = varargin{1};
if isempty(strfind(xmlfile,'.xml'))
	error('Not an xml file !')
end

fid = fopen(xmlfile);
if fid<0
	error(sprintf('Can''t open xml file: %s',xmlfile));
end

toccell = {}; iline = 0;

done = 0;
while done ~= 1	
	tline = fgetl(fid);
	if ~ischar(tline)
		done = 1;
	end	
	if strfind(tline,'<toc version=')
		intoc = true;
		il    = 0;
		while intoc
			tline = fgetl(fid);
			tline0 = tline;
			if ~ischar(tline)
				done = 1;
			end
			tline = strtrim(tline);
			doit = true;
			
			% Is this a comment ?
			if ~isempty(strfind(tline,'<!--'))
				if ~isempty(strfind(tline,'-->'))					
					%disp(sprintf('COMMENT: %s',tline))
					doit = false;
				else												
					%disp(sprintf('COMMENT: %s',tline))
					tline = fgetl(fid);
					%disp(sprintf('COMMENT: %s',tline))
					while isempty(strfind(tline,'-->'))
						tline = fgetl(fid);
						%disp(sprintf('COMMENT: %s',tline))
					end
					doit = false;
				end
			end
			% Is this an empty line ?
			if isempty(tline)
				doit = false;
			end

			if ~isempty(strfind(tline,'</toc>'))
				il    = il - 1;
				doit  = false;
				intoc = false;				
			end
			
			if doit
				if ~isempty(strfind(tline,'<tocitem'))
					il = il + 1;
					if ~isempty(strfind(tline,'</tocitem>'))
						iline=iline+1;toccell(iline,:) = {il , tline};
						%disp(sprintf('%i: %s',il,tline0))
						il = il - 1;
					else
						%disp(sprintf('%i: %s',il,tline0))
						iline=iline+1;toccell(iline,:) = {il , tline};						
					end
				elseif ~isempty(strfind(tline,'</tocitem>'))	
					%disp(sprintf('%i: %s',il,tline0))					
					iline=iline+1;toccell(iline,:) = {il , tline};					
					il = il - 1;	
				else
					%disp(sprintf('%i: %s',il,tline0))							
					iline=iline+1;toccell(iline,:) = {il , tline};			
				end
			end
		end%while
	end
end%while
fclose(fid);

ilp = 1; % First level
for iline = 1 : size(toccell,1)
	il = toccell{iline,1};
	tt = toccell{iline,2}; ttclean = clean(tt);
	tabs   = gettabs(il);
	tabsli = gettabs(il+1);
	if strfind(tt,'</tocitem>') & isempty(strfind(tt,'<tocitem'))
%		disp(sprintf('%s%i: end',tabsli,ilp))		
	elseif ~isempty(ttclean)		
		if strfind(tt,'target=')
			[tt target] = readt(tt,'target');
		end
		if strfind(tt,'image=')
			[tt img] = readt(tt,'image');
%			img = strrep(img,'$toolbox',fullfile(matlabroot,'toolbox'));
			img = strrep(img,fullfile('$toolbox','matlab','icons'),'images');
		end
%		disp(sprintf('%s%i: %s (%s)',tabs,il,ttclean,target))
%		disp(sprintf('%s <a class="toc%i" href="%s">%s</a><br>',tabs,il,target,ttclean));
		if exist('img','var')
			disp(sprintf('%s <a class="toc%i" href="%s"><img src="%s" class="toc%i"> %s</a><br>',tabs,il,target,img,il,ttclean));
		else
			disp(sprintf('%s <a class="toc%i" href="%s">%s</a><br>',tabs,il,target,ttclean));
		end
	end		
	clear img
	ilp = il;
end%for iline
%disp(sprintf('%s%i: end',gettabs(il),ilp))

return

%%%%%%%%%%%%%%%%%%%%%%%%%
htmlcell = {}; iline2 = 0;
%stophere

ilp = 1; % First level
dl = 0;
iline2 = iline2+1; htmlcell(iline2,1) = {'<ol>'}; htmlcell(iline2,2) = {ilp}; htmlcell(iline2,3) = {''};
disp(sprintf('<ol>'));
for iline = 1 : size(toccell,1)
	il = toccell{iline,1};
	tt = toccell{iline,2}; tt0=tt;
	tabs   = gettabs(il);
	tabsli = gettabs(il+1);
	if iline < size(toccell,1)
		iln = toccell{iline+1,1};
		tabsln = gettabs(il-1);
	end
	
	if strfind(tt,'tocitem')
		tt = strrep(tt,'tocitem','li');
		if strfind(tt,'target=')
			[tt target] = readt(tt,'target');
		end
		if strfind(tt,'image=')
			[tt img] = readt(tt,'image');
		end		
	end

	% if il > ilp
	% 	tline = sprintf('<ol>\n%s',tt);
	% elseif iln < il
	% 	tline = sprintf('%s\n</ol>',tt);	
	% else
	% 	tline = sprintf('%s',tt);			
	% end
	if il > ilp
		dl = dl + 1;
		iline2 = iline2+1; htmlcell(iline2,1) = {'<ol>'};htmlcell(iline2,2) = {il}; htmlcell(iline2,3) = {target};
		iline2 = iline2+1; htmlcell(iline2,1) = {tt};	 htmlcell(iline2,2) = {il}; htmlcell(iline2,3) = {target};
		tline = sprintf('%s<ol>\n%s%s',gettabs(il),gettabs(il+dl),tt);
	elseif iln < il
		dl = dl - 1;
		tline = sprintf('%s%s\n%s</ol>',gettabs(il),gettabs(il-dl),tt);
		iline2 = iline2+1; htmlcell(iline2,1) = {tt};	  htmlcell(iline2,2) = {il}; htmlcell(iline2,3) = {target};
		iline2 = iline2+1; htmlcell(iline2,1) = {'</ol>'};htmlcell(iline2,2) = {il}; htmlcell(iline2,3) = {target};		
	else
		tline = sprintf('%s%s',gettabs(il+dl),tt);
		iline2 = iline2+1; htmlcell(iline2,1) = {tt};		
	end
	
	if strfind(tline,'<li') & 0
		if strfind(tline,'</li>') 
			tline = sprintf('<li><a href="%s">%s</a></li>',target,clean(tline));
		else
			tline = sprintf('<li><a href="%s">%s</a>',target,clean(tline));
		end
	end
	
%	stophere
	disp(tline)
%	disp(sprintf('%s%s',gettabs(il),tline))

	
	ilp = il;
end%for iline
disp(sprintf('</ol>'))		
iline2 = iline2+1; htmlcell(iline2,1) = {'</ol>'};htmlcell(iline2,2) = {il}; htmlcell(iline2,3) = {''};

stophere

end %functionhelptocxml2html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
function [tt value] = readt(tt,param);

	param = [' ' param '='];
	i1 = strfind(tt,param);
	s1 = tt(i1+length(param):end);	
	i2 = strfind(s1,'"');
	value = s1(i2(1)+1:i2(2)-1);	
	tt = strrep(tt,sprintf('%s"%s"',param,value),'');
	
end%function
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
function tt = clean(tt);
	done = 0 ;
	while done ~= 1
		io = strfind(tt,'<');
		ic = strfind(tt,'>');
		if isempty(io)
			done = 1;
		else
			tt = strrep(tt,tt(io(1):ic(1)),'');
		end
	end

end%function
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
function tabs = gettabs(nt);
	tabs = sprintf('\t');
	if nt > 1
		for ii = 1 : nt-1
			tabs = sprintf('\t%s',tabs);
		end
	end
end%fucntion
%%%%%%%%%%%%%%%%%%%%%%%%%














