%
%  get_plotlistdef(MASTER,SUBDIR)
%
% This function display description of pre-defined plots
% available with the MASTER.m in the folder SUBDIR
% 
% 07/12/06
% gmaze@mit.edu

function LIST = get_plotlistdef(MASTER,SUBDIR)

global sla

% Define suffixe of plot module:
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
  iM =  findstr( strcat(SUBDIR,sla,fil) , pref ) ;
  
  if ~isempty(iM)
    ii = ii + 1; 
    LIST(ii).name = l(il).name;
    LIST(ii).index = ii;
    
    % Recup description of plot module:
    fid = fopen(strcat(SUBDIR,sla,fil));
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
    disp(sprintf('%3s: DIAGNOSTIC %10s // %s',...
		 num2str(LIST(ii).index),...
		 fil(length(MASTER)+2:end-2),...
		 LIST(ii).description));
%    disp(strcat( num2str(LIST(ii).index),': Module extension: ',fil(length(MASTER)+2:end-2)));
%    disp(strcat('|-----> description :'  , LIST(ii).description ));
%    disp(char(2))
    
  end %if
  
end %for il
    
if ~exist('LIST')
  LIST= NaN;
end

