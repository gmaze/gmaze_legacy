%
%  LIST = get_plotlist(MASTER,SUBDIR)
%
% This function determines the list of pre-defined plots
% available with the MASTER.m in the folder SUBDIR
% LIST is a structure with name and description of each modules.
%

function LIST = get_plotlist(MASTER,SUBDIR)

global sla

% Define suffixe of plot module:
suff = '_pl';

d = dir(strcat(SUBDIR,sla));

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

for il = 1 : size(l,2)
  fil = l(il).name;
  pref = strcat(MASTER,suff);
  iM =  findstr( strcat(SUBDIR,sla,fil) , pref ) ;
  
  if ~isempty(iM)
    ii = ii + 1; 
    LIST(ii).name = l(il).name;
    LIST(ii).index = ii;
    
    % Recup description of plot module:
    fid = fopen(strcat(SUBDIR,sla,fil));
    if fid < 0
      sprintf('Problem with file: %s',strcat(SUBDIR,sla,fil))
      return
    end
    thatsit = 0;
    while thatsit ~= 1
       tline = fgetl(fid);
       if tline ~= -1
       if length(tline)>4 & tline(1:4) == '%DEF'
          LIST(ii).description = tline(5:end);
          thatsit = 1;
       end %if
       else
          LIST(ii).description = 'Not found';
          thatsit = 1;
       end %if
    end %while
    
  end %if
  
end %for il
    
if ~exist('LIST')
  LIST= NaN;
end
