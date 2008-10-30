% MAILSEND Send an email via the system command 'mail'
%
% [] = mailsend(email,subject,body)
%
% Send an email via the system command 'mail'
%
% For multiple lines, insert \n in the body string chaine
%
% Created by Guillaume Maze on 2008-10-14.
% Copyright (c) 2008 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = mailsend(email,subject,body)


  fid = fopen('./.matlab_email.txt','w');
    if ~iscell(body)
	% Check if we have multiple lines
	ll=findstr(body,'\n');

	if ~isempty(ll)
	  body = ['\n' body '\n'];
  	  ll = findstr(body,'\n');
	  for il = 1 : length(ll)-1
	    fprintf(fid,'%s\n',body(ll(il)+2:ll(il+1)-1));
	  end
	else
          fprintf(fid,'%s',body);
	end
	
    else
      for il = 1 : length(body)
	fprintf(fid,'%s',cell2mat(body(il)));
      end	
    end
  fclose(fid);
  
  chaine = sprintf('mail -s ''%s'' %s < %s',...
		   subject,email,'./.matlab_email.txt');
  system(chaine);
  
  delete('./.matlab_email.txt');

  


