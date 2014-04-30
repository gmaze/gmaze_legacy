% MAILSEND Send an email via the system command 'mail'
%
% [] = mailsend(email,subject,'body string')           % Use a string
% [] = mailsend(email,subject,'body line1 \nline 2')   % Use \n in string to add new lines
% [] = mailsend(email,subject,{'body line1','line 2'}) % Use cell array of strings
% [] = mailsend(email,subject,{'body line1',132})      % Use cell array of strings or not
% [] = mailsend(email,subject,'body_file_content.txt') % Use a text file content 
%
% Send an email via the system command 'mail'
%
% Created by Guillaume Maze on 2008-10-14.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org
% Revised: 2014-04-30 (G. Maze) Added support for file content in the body

% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = mailsend(email,subject,body)

email_file = sprintf('.matlab_email_%s.txt',datestr(now,30));
fid = fopen(email_file,'w');
switch class(body)
	case 'char'
		% Check if this is a file name ?
		isfile = exist(body,'file') == 2;
		
		switch isfile
			case 0
				% Check if we have multiple lines
				ll = findstr(body,'\n');
				if ~isempty(ll)
					body = ['\n' body '\n'];
					ll = findstr(body,'\n');
					for il = 1 : length(ll)-1
						fprintf(fid,'%s\n',body(ll(il)+2:ll(il+1)-1));
					end% for il
				else
					fprintf(fid,'%s',body);
				end% if
				
			case 1
				fidi = fopen(body,'r');
				while 1
					tline = fgetl(fidi);
					if ~ischar(tline), break, end
					fprintf(fid,'%s\n',tline);			
				end
				fclose(fidi);
		end% switch 		 
	
	case 'cell'	
		for il = 1 : length(body)
			tline = body{il};
			if isnumeric(tline)
				tline = num2str(tline);
			end% if 			
			fprintf(fid,'%s\n',tline);
		end% for il
	
end% switch
fclose(fid);

chaine = sprintf('mail -s ''%s'' %s < %s',subject,email,email_file);
unix(chaine);

delete(email_file);

  
end%function


