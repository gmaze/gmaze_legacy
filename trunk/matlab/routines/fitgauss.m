% fitgauss Fit a Gaussian to a distribution plot
%
% [H,MOM] = fitgauss([MEAN,STD])
% 
% Plot a gaussian curve on a distribution plot.
%
% Inputs:
%	MEAN, STD (optional): mean and standar deviation of the distribution
%		If not specified, they are computed from the distribution and give
%		back into output MOM
%
% Outputs:
%	H: plot handle of the gaussian curve
%	MOM = [MEAN,STD] of the distribution.
%
% Example:
%	y = randn(1,1e4);
%	hist(y,100);
%	hold on;fitgauss;
%
% Created: 2009-11-23.
% Copyright (c) 2009, Guillaume Maze (Laboratoire de Physique des Oceans).
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

function varargout = fitgauss(varargin)


%% Get the distribution from the distribution plot:
[X Y] = get_datas;

for idistrib = 1 : length(X)
	xdata = X(idistrib).xdata;
	ydata = Y(idistrib).ydata;

	%%%%%%%%%%%%%%%%%%%%%% Get moments:
	if nargin == 0
		nonul = find(ydata~=0); % Keep only no-null values
		nonul = 1:length(ydata);
		P = ydata(nonul)./sum(ydata(nonul)); % Probability
		mom(1) = sum(xdata(nonul).*P); % Mean
		mom(2) = sum(xdata(nonul).^2.*P)-mom(1).^2; % STD

	else
		% Get moments from input:
		mom(1) = varargin{1};
		mom(2) = varargin{2};
	
	end

	%%%%%%%%%%%%%%%%%%%%%% Fit a gaussian curve:	
	g0 = max(ydata).*exp(-(xdata-mom(1)).^2 /2/mom(2).^2);
	c  = find_optm(g0,ydata);
	gauss = c.*g0;

	%%%%%%%%%%%%%%%%%%%%%% Plot the curve:
	hold on
	p(idistrib) = plot(xdata,gauss,'r');
	set(p(idistrib),'Tag','fitgauss')
	MOM(idistrib,:) = mom;
	
end%for idistrib

%%%%%%%%%%%%%%%%%%%%%% Outputs:
switch nargout
	case 1
		varargout(1) = {p};
	case 2
		varargout(1) = {p};
		varargout(2) = {MOM};
end

%%%%%%%%%%%%%%%%%%%%%%
end %functionfitgauss


%%%%%%%%%%%%%%%%%%%%%%
function c  = find_optm(g0,ydata);
	c = -2:.1:2;
	for ii =  1 : length(c)
		r(ii) = sum((c(ii)*g0-ydata).^2);
	end
	[r ic] = min(r);
	c = c(ic);
end

%%%%%%%%%%%%%%%%%%%%%%
function [X Y] = get_datas;
	ch  = get(gca,'children');
	gau = findobj(gca,'-regexp','Tag','fitgauss');
	ch = setdiff(ch,gau);
	
	for ich = 1 : length(ch)
		switch get(ch(ich),'type')
			case 'patch' % This was probably plotted using hist
				ydata = get(ch(ich),'ydata');
				ydata = ydata(2,:);
				xdata = get(ch(ich),'xdata');
				xdata = mean(xdata);
			case 'line' % This is a classic plot
				xdata = get(ch(ich),'xdata'); 
				ydata = get(ch(ich),'ydata'); 
			case 'hggroup'
				ch2 = get(ch(ich),'children');
					ydata = get(ch2,'ydata');
					ydata = ydata(2,:);
					xdata = get(ch2,'xdata');
					xdata = mean(xdata);
				
		end %switch
		X(ich).xdata = xdata;
		Y(ich).ydata = ydata;
	end%for ich
end%function









