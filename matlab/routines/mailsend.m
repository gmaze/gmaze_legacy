% [] = mailsend(email,subject,body)
%
% Send an email via the system command 'mail'
%
% For multiple lines, insert \n in the body string chaine
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

  


