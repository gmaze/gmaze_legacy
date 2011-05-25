% stickynote H1LINE
%
% [] = stickynote()
% 
% HELPTEXT
%
% Created: 2011-03-04.
% Copyright (c) 2011, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specific prior 
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

function varargout = stickynote(textnote)

ax0 = gca;

%- Create background axis:
%axB = place_sticker;
%-- Create sticky note axes
if isempty(findall(gcf,'tag','stickynote_background'))
	axB = axes('position',[0 0 1 1]);
	set(axB,'tag','stickynote_background');
else
	axB = findall(gcf,'tag','stickynote_background');
	axes(axB);
end

a  = imread('~/Documents/Postit.png','png');		
ii = image(a,'tag','stickynote');

amap = ones(size(a,1),size(a,2));
amap(double( sum(a,3)/3 ) >= 245) = 0;
alpha(ii,amap/2);
axis([0 1000 0 1000]);
set(axB,'visible','off')	
draggable(ii);

ht1 = uicontrol('Style','Text','units',get(axB,'units'),...
	'Position',[30/1000 1-size(a,2)/1000 .75*size(a,1)/1000 .8*size(a,2)/1000]);
textnote = textwrap(ht1,textnote);
delete(ht1);	
t = text(30,20,textnote,'verticalAlignment','top','tag','stickynote');

if isappdata(gcf,'stickynote')
	stickynotes = getappdata(gcf,'stickynote');
	stickynotes.bg = [stickynotes.bg ii];
	stickynotes.tt = [stickynotes.tt t ];
	setappdata(gcf,'stickynote',stickynotes);
else
	stickynotes.bg = ii;
	stickynotes.tt = t;
	setappdata(gcf,'stickynote',stickynotes);
end


return


s='Some figure properties are changed by the function, but previous properties are restored as soon as the drag is stopped. The behavior of the object can be reverted to its original, non-draggable state, by issuing';

%- Create axis for the text:
% posB = get(axB,'position');
% ax = axes('position',[posB(1:2)*1.05 posB(3:4)*.8]);
% set(ax,'tag','stickynote');
% set(ax,'visible','off')
%set(ax,'visible','on','xtick',[],'ytick',[],'box','off','color','b')

ht1 = uicontrol('Style','Text','units',get(ax,'units'),'Position',get(ax,'position'));
textnote = textwrap(ht1,textnote);
delete(ht1);
%textnote = fitin(ii,textnote);
t = text(0,1,textnote,'tag','stickynote','verticalAlignment','top');
%draggable(t)

%stophere
set(gcf,'currentaxes',ax0);
end %functionisticky



function textnote = fitin(ax,textnote);

	ht1 = uicontrol('Style','Text','units',get(ax,'units'),'Position',get(ax,'position'));
	textnote = textwrap(ht1,textnote);
	delete(ht1);

end

function axB = place_sticker;
	
	%-- Create sticky note axes
	if isempty(findall(gcf,'tag','stickynote_background'))
		axB = axes('position',[0 0 1 1]);
		set(axB,'tag','stickynote_background');
	else
		axB = findall(gcf,'tag','stickynote_background');
		axes(axB);
	end
	
	a  = imread('~/Documents/Postit.png','png');		
	ii = image(a,'tag','stickynote_bg');
	amap = ones(size(a,1),size(a,2));
	amap(double( sum(a,3)/3 ) >= 245) = 0;
	alpha(ii,amap/2);
	axis([0 1000 0 1000]);
	set(axB,'visible','off')	
	draggable(ii);
	
end % end everything

	










