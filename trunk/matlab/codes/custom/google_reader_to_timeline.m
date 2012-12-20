% google_reader_to_timeline Google reader opml file to be used in Google Timeline
%
% [] = google_reader_to_timeline()
% 
% Read the opml Google Reader file in routines/data and create a url to be
% feed in the Google Timeline.
%
% Not working !
%
%
% Created: 2009-06-16.
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = google_reader_to_timeline(varargin)


%%%%%%%% Sparse the full ompl file:
fid=fopen(abspath('~/matlab/routines/data/google-reader-subscriptions.xml'));
il = 0;
while 1
	tline = fgetl(fid);
	if ~ischar(tline), 
		break, 
	elseif strfind(tline,'<outline title="publications" text="publications">')
		while 1
            tline = fgetl(fid);
            if ~ischar(tline), 
				break, 
			elseif strfind(tline,'</outline>')
				break
			elseif strfind(tline,'xmlUrl=')
				il = il + 1;
				TEXT(il).line = tline;
			end
        end
	end
end
fclose(fid);

%%%%%%%% Now create the string for http://newstimeline.googlelabs.com
% http://newstimeline.googlelabs.com/?subs=blog.<Feed-A>%2Cblog.<Feed-B>%2Cblog.<Feed-C>
% http://newstimeline.googlelabs.com/?subs=blog.http%3A%2F%2Ffeeds.labnol.org%2Flabnol%2Cblog.http%3A%2F%2Fwww.techmeme.com%2Findex.xml%2Cblog.http%3A%2F%2Ftwitter.com%2Fstatuses%2Fuser_timeline%2F724473.rss%2Cblog.http%3A%2F%2Ffeeds.digg.com%2Fdigg%2Fcontainer%2Ftechnology%2Fpopular.rss%2Cblog.http%3A%2F%2Fnews.ycombinator.com%2Frss&date=2009-06-05&zoom=0

url = 'http://newstimeline.googlelabs.com/?subs=blog';
for ixml = 1 : size(TEXT,2)
%for ixml = 1 : 10
	xml = strrep(TEXT(ixml).line,'xmlUrl="','');
	xml = xml(1:min(strfind(xml,'"'))-1);
	xml = strrep(xml,' ','');
%	xml = strrep(xml,'?','');
%	disp(xml)
%	disp(url_code(xml))
	if ixml == 1
		url = sprintf('%s.%s',url,xml);
	else
		url = sprintf('%s%%2Cblog.%s',url,xml);
	end
end %for ixml
disp(url)

%system(sprintf('openurl %s',url));
%web(url,'-browser');

end %function







