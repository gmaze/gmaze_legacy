function [h ncited]=hindex(name,varargin)
%HINDEX  Computes the h-index of an author from Google Scholar.
%   HINDEX(AUTHORNAME) computes the h-index of the author AUTHORNAME, on
%   the basis of the publications referenced by Google Scholar
%   (http://scholar.google.com). An active internet connection is required.
%
%   The index h is defined as "the number of papers with citation number
%   higher or equal to h", and has been proposed by J.E. Hirsch to
%   "characterize the scientific output of a researcher" [Proc. Nat. Acad.
%   Sci. 46, 16569 (2005)]. Note that the number of citations referenced by
%   Google Scholar may be lower than the actual one (old publications are
%   not available online).
%
%   The string AUTHORNAME should contain the last name, or the initial(s)
%   of the first name(s) followed by the last name, of the author (eg,
%   'A. Einstein'). Do not put the initial(s) after the last name. The scan
%   is not case sensitive. Points (.) and spaces ( ) are not taken into
%   account. See Google Scholar Help for more details about the syntax.
%
%   Example: HINDEX('A. Einstein') returns 43 (ie: 43 papers by A. Einstein
%   have been cited at least 43 times, according to Google Scholar).
%
%   H = HINDEX(AUTHORNAME) only returns the h-index, without display.
%
%   HINDEX(AUTHORNAME, 'Property1',...) specifies the properties:
%     'verb'       also displays the list of papers returned by Google
%                  Scholar, rejecting the ones for which AUTHORNAME is not
%                  one of the authors.
%     'plot'       also plots the 'Cited by' number as a function of the
%                  paper rank.
%
%   HINDEX should be used with care. Many biases exist (homonyms, errors
%   from Google Scholar, old papers are not available online, but
%   unpublished or draft papers are...) For the true h-index of an author,
%   it is recommended to use an official citation index database (eg, ISI).
%   Use HINDEX just for fun.
%
%   Remark: Massive usage of hindex may be considered by the Google
%   Scholar server as a spam attack, and may invalidate the IP number of
%   your computer. If this happens, you get an 'Internet connection failed'
%   error message -- but you still can use Google Scholar from a web
%   browser.
%
%   F. Moisy, moisy@fast.u-psud.fr
%   Revision: 1.11,  Date: 10-jul-2006


% History:
% 22-jan-2006: v1.00-1.10, first versions.
% 07-jul-2006: v1.11, check ML version; help text improved; use properties


% check the matlab version:
if str2double(version('-release'))<14,
    error('hindex requires Matlab 7 (R14) or higher.');
end;

error(nargchk(1,2,nargin));

% clean the input text:
name=lower(name);
name=strrep(name,'.',' ');
name=strrep(name,'  ',' ');

ncit=0;   % total number of citation
ncitinthispage=0; % number of citation in the current page
ncited=[];

seenextpage=1;
numpage=0;
while seenextpage,
    numpage=numpage+1;
    % find the web page:
    pagename=['http://scholar.google.com/scholar?num=100&start=' num2str(100*(numpage-1)) '&q=%22author%3A' strrep(name,' ','+author%3A') '%22'];
    if nargout==0,
        disp(['Scanning: ' pagename]);
    end;
    [s, res]=urlread(pagename);
    if ~res,
        error('Internet connection failed.');        
    end;

    rem=s; % remainder of the string

    while strfind(rem,'Cited by '),
        pauth1 = strfind(rem,'<font color=green>')+18; pauth1=pauth1(1);
        pauth2 = strfind(rem(pauth1:min(end,(pauth1+500))),'</font>')-1; pauth2=pauth2(1);
        authstring = lower(rem(pauth1:(pauth1+pauth2-1))); % list of authors of the paper
        authstring = strrep(authstring,'<b>','');
        authstring = strrep(authstring,'</b>','');
        authstring = strrep(authstring,'&hellip;','...');

        % check that the required name is indeed in the author list.
        paperok=0;
        pos=strfind(authstring,name);
        if length(pos),
            pos=pos(1);
            paperok=1;
            if pos>1,
                % check for wrong initials (eg, 'ga einstein' should not
                % match for 'a einstein')
                pl=authstring(pos-1);
                if ((pl>='a')&&(pl<='z'))||(pl=='-'),
                    paperok=0;
                end;
            end;
            if pos<(length(authstring)-length(name)),
                % check for wrong 'suffix' (eg, 'einstein-joliot' should not
                % match for 'einstein')
                nl=authstring(pos+length(name));
                if ((nl>='a')&&(nl<='z'))||(nl=='-'),
                    paperok=0;
                end;
            end;
        end;

        if paperok, % if the required name is indeed in the author list
            ncit = ncit+1;
            ncitinthispage = ncitinthispage +1;
            p=strfind(rem,'Cited by ')+9; p=p(1);
            substr=rem(p:(p+5));
            pend=strfind(substr,'<'); pend=pend(1);
            ncited(ncit)=str2double(substr(1:(pend-1)));
            rem=rem((p+2):end);
            if any(strncmpi(varargin,'verb',1))
            	disp(['#' num2str(ncit) ': (' num2str(ncited(ncit)) '), ' authstring]);
            end;
        else
            if any(strncmpi(varargin,'verb',1))
                disp(['rejected: ' authstring]);
            end;
            p=strfind(rem,'Cited by ')+9; p=p(1);
            rem=rem((p+2):end);
        end;
    end;
    if any(strncmpi(varargin,'verb',1))
        disp(' ');
    end;
    if ncit==0,
        seenextpage=0;
    else
        if ((ncited(ncit)<2)||(~length(findstr(rem,'<span class=b>Next</span>')))),
            seenextpage=0;
        end;
    end;
end; % while seenextpage

if length(ncited),
    % sort the list (it should be sorted, but sometimes GS produces unsorted results)
    ncited=sort(ncited); ncited=ncited(ncit:-1:1);

    % computes the H-factor:
    h=sum(ncited>=(1:ncit));

    % plot the 'Cited by' number:
    if any(strncmpi(varargin,'plot',1))
        loglog(1:ncit,ncited,'.-',1:ncit,1:ncit,'--',h,h,'o');
        xlabel('Paper rank'); ylabel('Number of citations');
        title(['h-index plot for ''' name ''' (h=' num2str(h) ')']);
    end;

    % some displays if no output argument:
    if nargout==0,
        disp(['Number of cited papers: ' num2str(length(ncited))]);
        disp(['''Cited by'' list: ' num2str(ncited)]);
        disp(['Total number of citations: ' num2str(sum(ncited))]);
        disp(['h-index = ' num2str(h)]);
        clear h;
    end;
else
    h=0;
    if nargout==0,
        disp('No result found');
        clear h;
    end;
end;
