% getpeaks Determine peak(s) of function X
%
% ipeaks = getpeaks(X,[N])
%
% Determine peaks of function X. N is the 'order' of the peak selection
% criteria (By default, N=2). The 'order' of the peak indicates the number 
% of points on each side of the peak to which X(ipeaks) is superior to:
% X(ipeak) is the maximum in the interval: X(ipeak-N:ipeak+N)
%
% Created: 2007.
% Rev. by Guillaume Maze on 2009-08-31: Fix a bug with find
% Copyright (c) 2009 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software Foundation, 
% either version 3 of the License, or any later version. This program is distributed 
% in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
% implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. You should have received a copy of 
% the GNU General Public License along with this program.  
% If not, see <http://www.gnu.org/licenses/>.
%

function pics = getpeaks(X,varargin)

method = 1;

switch method
	case 1

		X=X(:);
		n=length(X);
		gr=gradient(X);
		pics=NaN;
		%sign(gr)
		%whos X gr

		if nargin==2
		  N=varargin{1};
		  if N<=1
		    disp('Sorry, expected N>1, I move it to 2 the default value !');
		    N=2;
		  end
		else
		  N=2;
		end  


		checkfig=0;
		if checkfig
		   figure(60);hold on;set(gcf,'position',[5 470 481 256]);
		   plot(X);grid on;title('signal');
		   drawnow;refresh;
		   figure(61);hold on;set(gcf,'position',[5 156 481 230]);
		   plot(gr);grid on;title('Signal gradient');
		   ll=line([1 1],get(gca,'ylim'));
		end   

		ip=0;
		if checkfig
		 disp('OK')
		end
		for it=N+1:n-N-1
		% $$$     if checkfig
		% $$$       figure(61);
		% $$$       set(ll,'visible','off');
		% $$$       ll=line([1 1]*it,get(gca,'ylim'));
		% $$$     end
    
		    % Cas d'une derivee nulle, pic 'parfait': gr = 1 1 0 -1 -1 
		    if (sign(gr(it))==0)
		       % On garde le pic par defaut:
		       ok=1; 
		       % Mais on le rejette s'il ne satisfait pas a l'ordre:  
		       p1=sign(gr(it-N:it-1)); % Avant
		       p2=sign(gr(it+1:it+N)); % Apres
		       if find(p1~=1) | find(p2~=-1)
		             ok=0;
		       end

		       if ok
		         ip=ip+1;
		         pics(ip)=it;
		         if checkfig
		          line([1 1]*pics(ip),get(gca,'ylim'),'color','r');refresh
		          figure(60);
		          line([1 1]*pics(ip),get(gca,'ylim'),'color','r');refresh
		         end
		       end %if ok
       
		    % Cas d'un changement de signe classique: gr=  1 1 1 -1 -1 -1
		    elseif((sign(gr(it))>0)&(sign(gr(it+1))<0))
				% On garde le pic par defaut:
				ok=1;
				% Mais on le rejette s'il ne satisfait pas a l'ordre:
				p1=sign(gr(it-N:it-1)); % Avant
				p2=sign(gr(it+1:it+N)); % Apres
				if ~isempty(find(p1~=1)) | ~isempty(find(p2~=-1))
					ok=0;
				end
				% if find(p1~=1) | find(p2~=-1)
				% 	ok=0;
				% end
       
		       if ok
		         ip=ip+1;
		         pics(ip)=it+1;
		         if checkfig
		          line([1 1]*pics(ip),get(gca,'ylim'),'color','r');refresh
		          figure(60);
		          line([1 1]*pics(ip),get(gca,'ylim'),'color','r');refresh
		         end %if checkfig
		       end %if ok
    
		    end %if derivee nul ou changement de signe
    	end%for it

	case 2
		if nargin==2
		  N=varargin{1};
		  if N<=1
		    disp('Sorry, expected N>1, I move it to 2 the default value !');
		    N=2;
		  end
		else
		  N=2;
		end
		
		% Move to only positive values:
		x = X + nanmin(X);
		
		% 
		nx = length(x); ii = 0;
		for ix = 1 : N : nx
			ii = ii + 1;
			ma(ii) = nanmax(x(max([1 ix-N]):min([nx ix+N])));			
		end%for ix
		pics = ma - nanmin(X);
	
	
end %switch

if isnan(pics)
	pics = [];
end% if 

end %for it
