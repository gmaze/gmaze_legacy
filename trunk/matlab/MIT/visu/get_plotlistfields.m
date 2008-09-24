%
%  get_plotlistfields(MASTER,SUBDIR)
%
% This function returns the list of fields required by
% the modules of MASTER file in SUBDIR
% 
% 06/05/2007
% gmaze@mit.edu

function LIST = get_plotlistfields(MASTER,SUBDIR)

global sla

% Define suffixe of module:
suff = '_pl';


d = dir(SUBDIR);
ii = 0;
% Select Matlab files:
for id = 1 : length(d)
  en = length( d(id).name );
  if en~=1 & (d(id).name(en-1:en) == '.m') &  ~d(id).isdir
    ii = ii + 1;
    l(ii).name = d(id).name;
  end
end

% Select Matlab files with MASTER as prefix
ii = 0;
for il = 1 : length(l)
  fil = l(il).name;
  pref = strcat(MASTER,suff);
  iM =  findstr( strcat(SUBDIR,sla,fil) , pref );
  
  if ~isempty(iM)
    ii = ii + 1; 
    LIST(ii).name = l(il).name;
    LIST(ii).index = ii;
    
    % Recup list of fields required by the module:
    fid = fopen(strcat(SUBDIR,sla,fil));
    thatsit = 0;
    clear fiel
    while thatsit ~= 1
       tline = fgetl(fid);
       if tline ~= -1
       if length(tline)>4 & tline(1:4) == '%REQ'
	  tl = strtrim(tline(5:end));
	  if strmatch(';',tl(end)), tl = tl(1:end-1);end
	  tl = [';' tl ';'];
	  pv = strmatch(';',tl');
	  for ifield = 1 : length(pv)-1
	    fiel(ifield).name = tl(pv(ifield)+1:pv(ifield+1)-1);
	  end
          LIST(ii).nbfields = size(fiel,2);
          LIST(ii).required = fiel;
          thatsit = 1;
       end %if
       else
	  fiel.name = 'Not found';
          LIST(ii).required = fiel;
          thatsit = 1;
       end %if
    end %while
    %disp(strcat( num2str(LIST(ii).index),': Module extension :',fil(length(MASTER)+2:end-2)));
    %disp(strcat('|-----> description :'  , LIST(ii).description ));
    %disp(char(2))
    
  end %if
  
end %for il
    
if ~exist('LIST')
  LIST= NaN;
end

