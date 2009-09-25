% figures2htm Writes all open figures to .png files and integrates them in a html file
% or
% figures2htm(reportdir,basename)
%
% 1) Writes all open figures to .png files and integrates them in a html file
% which opens the figure to full screen if clicked. If the figure has a
% name rather than a number, this will be part of the filename
% 2) and creates an index.htm for easy acces of several results
% Especially handy when a function has to be run often and produces quite
% some images.
% 3) writes relative links, so the entire dir can be copied and links still
% work
% 4) Works NOT in Firefox, sorry for that. The generated .htm code is quite
% crude, IE does render this.
%
% An index.htm is built for easy access of several reports, made for
% rerunning this code from different functions and datasources. The same
% reportdir should be used.
% and
% write variables to this htm-file with relevant images in same dir.
% 
% USAGE : 
%  'reportdir'  = Directory where to write, should end with a backslash
%  'basename'   = name of dataset which is being plotted
% 'functionname'= name of function that calls figure_report, if none given
%                 'unknown_' will be used.
% the 2 last mentioned names will be incorporated in the filenames and/or 
% sub-dir names, which is handy for browsing results
% base
% 
% EXAMPLE :
% figure
% set(gcf,'NumberTitle','off','Name','Sinewave');
% plot(sin(0:0.1:6.3));
% 
% figure
% plot(rand(40,1));
% 
% figure
% set(gcf,'Name','Peaks'); 
% surf(peaks);
% 
% figures2htm('C:\figdemo\','demo','function') 
% figures2htm('C:\figdemo\','demo')
%
%
% N.J.de Grooth
%  2006

function figures2htm(varargin)

reportpath=varargin{1}; basename=varargin{2};
if length(varargin)==3
    functionname=varargin{3};
else 
    functionname=('unknown_');
end

% UNIX/WINDOWS PATHNAME COMPATIBILITY
sla='/';if(ispc),sla='\';end;

reportdir2=(strcat(basename,'_',functionname));
wd=pwd; % working dir
mkdir(reportpath,reportdir2);
reportdir=strcat(reportpath,reportdir2,sla);
 
% writing of HTML file:
filename=strcat(reportdir,basename,'_report.htm');
fid = fopen(filename,'w'); 

% writing of entry in index.htm
indexname=strcat(reportpath,'index.htm');
findex=fopen(indexname,'a');
fprintf(findex,strcat('<A HREF=".',sla,reportdir2,sla,basename,'_report.htm"> ', reportdir2, ' </A> <br>\n'));
fclose(findex);

tdready=fix(clock);
try
    % use this part to write your text report.
    fprintf(fid,'Rapport mbt %s <br>\n', basename);
    fprintf(fid,'Working dir %s <br>\n', wd);
   fprintf(fid,'------ %s ------<br>\n', functionname);
    fprintf(fid,'Made at: %d %d %d \n<br>\n Tijd: %d : %d \n<br>\n', tdready(3),tdready(2),tdready(1), ...
        tdready(4),tdready(5));
    fprintf(fid,'<br>' );
    % --- endof text part of report.
    
    openFigures=findobj(allchild(0),'flat');

    % embed images
    for ifig=1:size(openFigures)
        figname=get(openFigures(ifig),'Name');
        if size(figname,2)==0,        figname=strcat('figure',num2str(openFigures(ifig)));    end
        figfile=strcat(reportdir,basename,'_',figname,'.png');
        fig_htm=strcat(reportdir,basename,'_',figname,'.htm');
        img = getframe(openFigures(ifig));
        imwrite(img.cdata, figfile);
%        figfile=strrep(figfile,'\','\\');
        fig_htm2=strcat('.',sla,basename,'_',figname,'.htm'); % double slashes needed for presenting slashes in file
        fprintf(fid,strcat('<A HREF="',fig_htm2,'"><IMG src="',basename,'_',figname,'.png','" ALT="',figname,'" WIDTH="30%%" HEIGHT="30%%"></A> \n'));
        % write htm that shows img big (=100% of the screen)
        imghtm=strcat(reportdir,basename,'_report.htm');
        fidfig = fopen(fig_htm,'w'); %create fullscreen htm-file for image
        a=sprintf('writing %s', fig_htm); disp(a);
        fprintf(fidfig,strcat('<IMG src="',basename,'_',figname,'.png','" ALT="',figname,'" WIDTH="100%%" HEIGHT="100%%">\n'));
        fclose(fidfig);
     end
    
    fclose(fid);
catch
    fprintf(fid,'error @ figurereport' );
    disp('error @ figurereport');
    fclose(fid);
end

