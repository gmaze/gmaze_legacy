% fnote Add a text note box to a figure
%
% [] = fnote()
% 
% Add a text note box to a figure
%
% Created: 2011-02-18.
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

function varargout = fnote(varargin)

%- Options
switch nargin
	case 0
		try
			%-- Delete the note
			delete(findall(gcf,'tag','note'));
			%-- Set initial plot positions:
			fnote = getappdata(gcf,'fnote');
			for ii = 1 : length(fnote.ax)
				set(fnote.ax(ii),'position',fnote.initial_position(ii,:),'outerposition',fnote.initial_outerposition(ii,:));
			end% for ii
			return
		catch
			disp('Please provide at least a string !');return		
		end
	case 1
		% Only provide text:
		notetext = varargin{1};
		hfig = gcf;
	case 2
		hfig     = varargin{1};
		notetext = varargin{2};
end

if isempty(findall(gcf,'type','axes','tag','note'))
	update = false;
else
	update = true;
end

switch update 	
	case false %- Create the note box:
		figure_tall;
		%-- Identify Plots to resize on this figure:
		ax = findall(hfig','type','axes');
		ax = setdiff(ax,findall(hfig','tag','footnote')); % Remove the footnote from the list
		ax = setdiff(ax,findall(hfig','tag','suptitle')); % Remove the suptitle from the list

		%-- Determine the distribution of subplots (how many rows/cols)
		if length(ax) > 1
			pos  = cell2mat(get(ax,'Position'));
			outp = cell2mat(get(ax,'OuterPosition'));
		else	
			pos  = get(ax,'Position');
			outp = get(ax,'OuterPosition');
		end% if 
		jw = length(unique(pos(:,1)));
		iw = length(unique(pos(:,2)));
		% Store in the figure datas the initial positions of the plots:
		fnote.ax = ax;
		fnote.initial_position = pos;
		fnote.initial_outerposition = outp;
		setappdata(hfig,'fnote',fnote)
		
		%-- Reshape axes handles to fit plot positions:
		AX = zeros(iw,jw);
		li = sort(unique(pos(:,1)));
		bi = sort(unique(pos(:,2)),1,'descend');
		for ix = 1 : length(ax)
			AX(find(bi==pos(ix,2)),find(li==pos(ix,1))) = ax(ix);
		end% for ix
		[AX,iw,jw] = fixe(AX,iw,jw);
		
		%-- Create the Note box:
		% set(findall(hfig','tag','footnote'),'visible','on')
		% set(findall(hfig','tag','footnotetext'),'edgecolor','r')
		% set(findall(hfig','tag','suptitle'),'visible','on')
		% set(findall(hfig','tag','suptitleText'),'edgecolor','r')

		%--- Determine the exact position of the top of the footnotetext:
		ex = get(findall(hfig','tag','footnotetext'),'extent');
		a  = get(findall(hfig','tag','footnote'),'position');
		b  = sum(ex([2 4]))*sum(a([2 4]))/diff(get(findall(hfig','tag','footnote'),'ylim'));
		h = 5*11; % height of the note box, roughly 5 lines of 8pts font size.

		%--- Create axes
		fig_pos = get(hfig,'position');% To Convert to relative:
		hnote_bot = b+8/fig_pos(4); % Position from hthe figure bottom
		hnote_hgt = h/fig_pos(4); % Height
		hnote = axes('position',[0 hnote_bot 1 hnote_hgt],'box','on','xticklabel','','yticklabel','','color','none','tag','note');
		set(hnote,'xtick',[],'ytick',[])
		set(hnote,'color',[1 1 .7],'box','off','xcolor','w','ycolor','w');
%		drawbox([0 1],[1 0],'tag','notebox')
		
		%-- Eventually rescale other plots
%		stophere

		if min(outp(:,2)) < hnote_bot+hnote_hgt
	
			%--- Determine the height we need to remove	
			DH = hnote_bot+hnote_hgt-min(outp(:,2));
			DH = DH*1.2;
			
			for ix = 1 : length(ax)
				set(ax(ix),'position',pos(ix,:));
			end
	
			% Height of ploting frame box
			H = max(outp(:,4)+outp(:,2)); % Maximum height of subplots spaces
			% Single plot height, pick max height for maximum downscaling
			h = max(outp(:,4)); 
			% Vertical distance between plots so that: H = iw*h + (iw-1)*d
			if iw==1
				d = 0;
			else
				d = (H-iw*h)/(iw-1);
			end
	
			% Move up lower plots:
			for il = iw : iw
				for ic = 1 : jw			
					ix = find(ax==AX(il,ic));
					try
						set(AX(il,ic),'outerPosition',[outp(ix,1) outp(ix,2)+DH outp(ix,3:4)]);
					catch
						disp('error')
						stophere
					end
				end% for ic
			end% for il
		
			% Update new plot height:
			for il = 1 : iw
				for ic = 1 : jw			
					ix = find(ax==AX(il,ic));
					try,	p  = get(AX(il,ic),'outerPosition');			
					catch, stophere,end
					if il==1 & iw ~= 1
						% First line must preserve their top postion:
						set(AX(il,ic),'outerPosition',[p(1) p(2)+p(4)*(1-(H-DH)/H) p(3) (H-DH)/H*p(4)]);							
					else % Not the others:
						set(AX(il,ic),'outerPosition',[p(1) p(2) p(3) (H-DH)/H*p(4)]);
					end% if il
				end% for ic	
			end% for il
		
			if iw*jw ~= 1
				for ic = 1 : jw			
					align(AX(:,ic),'center','distribute');
				end% for ic
			end% if 
					
		else
			%--- No need to rescale anything, the note box doesn't overlap any subplots !
		end

		%- Insert new Text
%		notetext = '';for ii=1:100,notetext=sprintf('%s%i',notetext,mod(ii,10));end
		writenote(hfig,notetext)

%		stophere

	case true %- Update the text in the note box:

	if strcmp(notetext,'del')
		%-- Delete the note
		delete(findall(hfig,'tag','note'));
		%-- Set initial plot positions:
		fnote = getappdata(hfig,'fnote');
		for ii = 1 : length(fnote.ax)
			set(fnote.ax(ii),'position',fnote.initial_position(ii,:),'outerposition',fnote.initial_outerposition(ii,:));
		end% for ii
		
	else	
		%-- Delete the note
		delete(findall(hfig,'tag','notetext'));
		%-- Update the note
%		notetext = sprintf('%s\n%s',notetext,get(findall(hfig,'tag','notetext'),'string')');
%		delete(findall(hfig,'tag','notetext'));
		writenote(hfig,notetext)
		
	end% if 
	
end% switch update


end %functionfnote
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function writenote(hfig,notetext)

axes(findall(hfig,'tag','note'))
maxnl = 4; % Max nb of lines
if usejava('jvm')
	fn = 'FixedWidth'; % Font name
	fs = 10;% Font size
	maxch = 67; % Max nb of char per line
	maxch = 93; % This is about 1 line of small caps characters
else
	fn = 'courrier';
	fs = 10;
	maxch = 88; % Max nb of char per line
end
x0 = 0.01;
y0 = 1;

switch class(notetext)
	case 'cell'
		nl = length(notetext);
		for il = 1 : nl
			if nl > maxnl
				warning(['Your note has too many lines, extra lines are not displayed but stored in the figure']);
			end
			str = sprintf('%s',notetext{1});
			for il = 2 : min([maxnl nl])
				if nl > maxnl & il == maxnl
					str = sprintf('%s\n%s [...]',str,notetext{il});
				elseif length(notetext{il}) > maxch
					s = notetext{il};
					str = sprintf('%s\n%s...',str,s(1:maxch-3));
				else
					str = sprintf('%s\n%s',str,notetext{il});						
				end% if 
			end%for il
			text(x0,y0,sprintf('%s',str),'tag','notetext');
		end% for il
	case 'char'
		re = strfind(notetext,'\n');
		if isempty(re)
			if length(notetext) > maxch
				text(x0,y0,sprintf('%s...',notetext(1:maxch)),'tag','notetext');						
				warning(sprintf('Please cut your note after %i characters',maxch));
			else
				text(x0,y0,sprintf(' %s',notetext),'tag','notetext');
			end% if 
			nl = 1;
		else
			%stophere
			ll = split(notetext);					
			nl = length(ll);
			
			if nl > maxnl
				warning(['Your note has too many lines, extra lines are not displayed but stored in the figure']);
			end
			str = sprintf('%s',ll{1});
			for il = 2 : min([maxnl nl])
				if nl > maxnl & il == maxnl
					str = sprintf('%s\n%s [...]',str,ll{il});
				elseif length(ll{il}) > maxch
					s = ll{il};
					str = sprintf('%s\n%s...',str,s(1:maxch-3));
				else
					str = sprintf('%s\n%s',str,ll{il});						
				end% if 
			end%for il
			text(x0,y0,sprintf('%s',str),'tag','notetext');
		end
end% switch 
set(findall(hfig,'tag','notetext'),'verticalalignment','top')
set(findall(hfig,'tag','notetext'),'fontsize',fs,'fontname',fn);

end%function


function ll = split(txt)
	txt = ['  ' txt];
	re = strfind(txt,'\n');
	re = [1 re length(txt)];
	for ii = 1 : length(re)-1
		ll(ii) = {txt(re(ii)+2:re(ii+1)-1)};
	end% for ii
end%function

function varargout = frame(ax)

	delete(findall(get(ax(1),'parent'),'tag','subplotboxes'));
	for ix = 1 : length(ax)	
		outp = get(ax(ix),'outerposition');	
		axes('position',outp,'box','on','yticklabel','','xticklabel','','color','none','tag','subplotboxes');
	end% for ix
	
end%function


function [AX,iw,jw] = fixe(AX,iw,jw);

	try
		for ic = 1 : size(AX,2)
			ax(:,ic) = AX(AX(:,ic)~=0,ic);
		end% for ic
		iw = size(ax,1);
		jw = size(ax,2);
		AX = ax;
	end
	
end%fucntion






























