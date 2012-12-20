% tex2html LaTeX to Html converter for intranet
%
% [] = tex2html(file)
% 
% LaTeX to Html converter for intranet
%
%
% Created: 2009-07-18.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = tex2html(varargin)

file = varargin{1};
fid = fopen(file,'r');

fidtmp = fopen('temp.tex','w');
while 1
	tline = fgetl(fid);
	if ~ischar(tline), break, end
	com = strfind(tline,'%');
	if ~isempty(com);
		tline = tline(1:com(1)-1);
	end
	fprintf(fidtmp,'%s\n',tline);
end
fclose(fid);
fclose(fidtmp);

fid = fopen('temp.tex','r');
ii=0;il=0;
while 1
	tline = fgetl(fid);
	if ~ischar(tline), break, end
	if strfind(tline,'\begin{document}')
		while 1
			tline = fgetl(fid);
			if ~ischar(tline), break, end
			if isempty(strfind(tline,'\end{document}'))			
				if ~isempty(strtrim(tline))

%%%%%%%%%%%%%%%%%%%%				
	
		if strfind(tline,'\begin{equation}')
			tline = strrep(tline,'\begin{equation}','<br>[tex]\begin{equation*}');
		end
		if strfind(tline,'\end{equation}')
			tline = strrep(tline,'\end{equation}','\end{equation*}[/tex]<br>');
		end
		if strfind(tline,'\begin{eqnarray}')
			tline = strrep(tline,'\begin{eqnarray}','<br>[tex]\begin{eqnarray*}');
		end
		if strfind(tline,'\end{eqnarray}')
			tline = strrep(tline,'\end{eqnarray}','\end{eqnarray*}[/tex]<br>');
		end					
		if strfind(tline,'\begin{abstract}')
			tline = strrep(tline,'\begin{abstract}','<abstract>');						
		end
		if strfind(tline,'\end{abstract}')
			tline = strrep(tline,'\end{abstract}','</abstract>');						
		end

		if strfind(tline,'\begin{figure*}')
			tline = strrep(tline,'\begin{figure*}','<br><figure><p>Figure start</p>');
		end
		if strfind(tline,'\end{figure*}')
			tline = strrep(tline,'\end{figure*}','<p>Figure stop</p></figure><br>');
		end
		if strfind(tline,'\begin{figure}')
			tline = strrep(tline,'\begin{figure}','<br><figure><p>Figure start</p>');
		end
		if strfind(tline,'\end{figure}')
			tline = strrep(tline,'\end{figure}','<p>Figure stop</p></figure><br>');
		end

		if strfind(tline,'\begin{center}')
			tline = strrep(tline,'\begin{center}','<center>');						
		end
		if strfind(tline,'\end{center}')
			tline = strrep(tline,'\end{center}','</center>');						
		end

		if strfind(tline,'\amstitle')
			tline = strrep(tline,'\amstitle','');
		end
		if strfind(tline,'\newpage')
			tline = strrep(tline,'\newpage','<hr>');
		end
		if strfind(tline,'\tableofcontents')
			tline = strrep(tline,'\tableofcontents','<?php TableOfContents(3,__FILE__); ?>');
		end

		if strfind(tline,'\label{')
			val = extract_val('label',tline);
			tline = strrep(tline,strcat('\label{',val,'}'),...
							strcat('<a name="#',val,'"></a>'));
		end
		if strfind(tline,'\caption{')
			val = extract_val('caption',tline);
			tline = strrep(tline,strcat('\caption{',val,'}'),...
							strcat('<caption>',val,'</caption>'));
		end		
		if strfind(tline,'\section{')
			val = extract_val('section',tline);
			tline = strrep(tline,strcat('\section{',val,'}'),...
							strcat('<h2 class="section"><a name="',strrep(val,' ','_'),'">',val,'</a></h2>'));
			ii=ii+1;TOC(ii).class = 2;TOC(ii).name = val;TOC(ii).anchor = strrep(val,' ','_');
		end
		if strfind(tline,'\subsection{')
			val = extract_val('subsection',tline);
			tline = strrep(tline,strcat('\subsection{',val,'}'),...
							strcat('<h3 class="subsection"><a name="',strrep(val,' ','_'),'">',val,'</a></h3>'));
			ii=ii+1;TOC(ii).class = 3;TOC(ii).name = val;TOC(ii).anchor = strrep(val,' ','_');
							
		end	
		if strfind(tline,'\subsubsection{')
			val = extract_val('subsubsection',tline);
			tline = strrep(tline,strcat('\subsubsection{',val,'}'),...
							strcat('<h4 class="subsubsection"><a name="',strrep(val,' ','_'),'">',val,'</a></h4>'));
			ii=ii+1;TOC(ii).class = 4;TOC(ii).name = val;TOC(ii).anchor = strrep(val,' ','_');
							
		end
		if strfind(tline,'\begin{appendix}')
			tline = strrep(tline,'\begin{appendix}','<appendix>');
		end
		if strfind(tline,'\end{appendix}')
			tline = strrep(tline,'\end{appendix}','</appendix>');
		end
		
		if strfind(tline,'\section*{')
			val = extract_val('section*',tline);
			tline = strrep(tline,strcat('\section*{',val,'}'),...
							strcat('<h2 class="section">',val,'</h2>'));
		end
		if strfind(tline,'\subsection*{')
			val = extract_val('subsection*',tline);
			tline = strrep(tline,strcat('\subsection*{',val,'}'),...
							strcat('<h3 class="subsection">',val,'</h3>'));
		end	
		if strfind(tline,'\subsubsection*{')
			val = extract_val('subsubsection*',tline);
			tline = strrep(tline,strcat('\subsubsection*{',val,'}'),...
							strcat('<h4 class="subsubsection">',val,'</h4>'));
		end						

		if strfind(tline,'\bibliographystyle{')
			val = extract_val('bibliographystyle',tline);
			tline = strrep(tline,strcat('\bibliographystyle{',val,'}'),...
							strcat('<bibliography class="style">',val,'</bibliography>'));
		end
		if strfind(tline,'\bibliography{')
			val = extract_val('bibliography',tline);
			tline = strrep(tline,strcat('\bibliography{',val,'}'),...
							strcat('<bibliography class="file">',val,'</bibliography>'));
		end

%%%%%%%%%%%%%%%%%%%%						
%					fprintf(fidtmp,'%s\n',tline);
					il = il + 1;
					TL(il).val = tline;					
				end
			else
				break
			end
		end
	end
end
fclose(fid);
whos TL TOC

if exist('TOC')
	fidtmp = fopen('temp2.php','w');
	for il = 1 : size(TL,2)
%		if strfind(TL(il).val,'<?php TableOfContents(3,__FILE__); ?>')
		if il==1
			fprintf(fidtmp,'%s\n','<div id="toc">    <p id="toc-header">Contents</p><ul>');
			for il = 1 : size(TOC,2)
				fprintf(fidtmp,'%s\n',strcat('<li class="toc',num2str(TOC(il).class),'"><a href="#',TOC(il).anchor,'">',TOC(il).name,'</a></li>'));
			end
			fprintf(fidtmp,'%s\n','</ul></div>');
		else
			fprintf(fidtmp,'%s\n',TL(il).val);
		end
	end%for il	
	fclose(fidtmp);	
end	






return

t = textscan(fid,'%s');
t = cell2struct(t{1}','val');
ALL = '';
for it = 1 : size(t,1)
	ALL = [ALL ' ' t(it).val];
end
fclose(fid);
disp(ALL)




if 0
fido = fopen('toto.php','w');
while 1
	tline = fgetl(fid);
	if ~ischar(tline), break, end
	if strfind(tline,'<!-- MATH')
		tline = strrep(tline,'<!-- MATH','[tex]');
		fprintf(fido,'%s\n','<p>Equation:</br>');
		fprintf(fido,'%s',tline);
		done=0;
		while done ~=1
			tline = fgetl(fid);
			if strfind(tline,'-->'), 
				tline = strrep(tline,'-->','[/tex]');
				fprintf(fido,'%s</p>\n\n',tline);
				done = 1;
			else
%				tline = strrep(tline,'\begin{equation}','');
%				tline = strrep(tline,'\end{equation}','');
				fprintf(fido,'%s',tline);
			end
			disp(tline);		
		end
%		fprintf(fido,'%s\n','');
	else
		%fprintf(fido,'%s\n',tline);
	end
end
fclose(fid);
fclose(fido);
end %if 0/1



end %function






function val = extract_val(name,tline);
	
	t = strcat('\',name,'{');
	is = strfind(tline,t);
	if isempty(is)
		disp('Error, this context is not in the line');
	else
		sub = tline(is(1)+length(t):end);
		brack = strfind(sub,'}');
		if isempty(brack)
			disp('Error, this context is not in the line');
		else
			val = sub(1:brack(1)-1);
		end
	end
	
end











