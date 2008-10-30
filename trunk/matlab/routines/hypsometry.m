% HYPSOMETRY Hypsometric Integral
%
%  [i] = HYPSOMETRY(raster, classes, options, Sa, Sb);
%  PURPOSE: calculate the hypsometric integral of a raster w/ n classes and
%           plot the hypsometry curve.
%  Returns scalar [i] with hypsometric integral
% -------------------------------------------------------------------
% USAGE: [i] = hypsometry(raster, classes, plot);
% where: [raster] is the input (elevation) grid of size (cols,rows)
%        [classes] (optional) is the number of classes to use, default is
%                   total number of elements
%        [options] (optional) vector of form [1 1] specifying whether to
%                  normalize hypsometry (first element) and whether to plot
%                  curve (second element)(1=yes,0=no), default is [1 1]
%        [Sa] (optional) is a character string made from one element
%            from any or all the following 3 columns, eg 'r.':
%
%            b     blue          .     point              -     solid
%            g     green         o     circle             :     dotted
%            r     red           x     x-mark             -.    dashdot
%            c     cyan          +     plus               --    dashed
%            m     magenta       *     star             (none)  no line
%            y     yellow        s     square
%            k     black         d     diamond
%                                v     triangle (down)
%                                ^     triangle (up)
%                                <     triangle (left)
%                                >     triangle (right)
%                                p     pentagram
%                                h     hexagram
%
%        [Sb] (optional) is a vector specifying linewidth and markersize in
%        the form [lw,ms]. To set Sb, all other options have to be set as well.
% -------------------------------------------------------------------------
% OUTPUTS:
%        [i] scalar with the hypsometric integral, based on cellsize 1 and
%            number of classes. For true area, multiply with cellsize.
% -------------------------------------------------------------------
% EXAMPLE: hypsometry(abs(randn(100,100)),20,[1 1],'ro-',[2 2])
%
% NOTES: NaNs are ignored. If class numbers are provided, mean for equal
%        size classes are used for hypsometry calculation.
%
% SEE ALSO: plot, numel
%
% Felix Hebeler, Geography Dept., University Zurich, March 2007

function [i] = hypsometry(raster, classes, options ,Sa,Sb)

if nargin < 1
    error('This function needs some input to work!');
elseif nargin > 5
    error('This is too much information! Please give no more than 5 arguments (raster,classes,plot,Sa,Sb)!');
end


% sort and eliminate NaNs
raster=sort(reshape(raster,1,numel(raster)),'descend');
raster(isnan(raster))=[];
elements=numel(raster);
mr=max(raster);
i=1;
% check if data needs to be resampled to classes
if exist('classes','var') 
    if ischar(classes)
        Sa=classes;
        classes=elements;
    elseif size(classes,2)<2 % check if classes is not the options flag
        isize=floor(elements/classes);
        t=nan(1,classes);
        for c=1:classes
            t(c)=nanmean(raster( ((c-1)*isize)+1:(c*isize) ));
        end
        raster=t;
        clear t;
        i=isize; % set i to number of classes for correct integral
    else
        options = classes;
        classes=elements;
    end
else
    classes=elements;
end
% check if hypsometry curve should be plotted
if ~exist('options','var')
    options=[1 1];
else
    if ischar(options) %make sure its not Sa we have here
        Sa=options;
        options=[1 1];
    elseif max(options)~=1 && min(options)~=0
        options=[1 1];  
    end
end

i=i*sum(raster); % integral is sum of elevation, times classes, if used
if options(1)==1
    i=i/(mr*elements); %normalize
    raster=raster./max(raster);
end
if options(2)==1
    if ~exist('Sa','var')
        Sa='r-'; %set default color here if to override system preferences
    end
    if ~exist('Sb','var')
        Sb=[1,3]; %defaults: LineWidth =1, MarkerSize = 3
    end
    % converting format strings so plot will accept them
    pa=['''LineWidth''',',',num2str(Sb(1)),',','''MarkerSize''',',',num2str(Sb(2))];
    Sa=['''',Sa,''''];

    eval(['plot(linspace(0,100,numel(raster)),raster,',Sa,',',pa,');']);
    title(['Hypsometry curve. Integral i=',num2str(i),', number of classes = ',num2str(classes)]);
    xlabel('Cumulative area [%]')
    if options(1)==1
        ylim([0 1]);
        ylabel('Normalised Altitude')
    else
        ylim([min(raster) (max(raster)+max(raster)/20)])
        ylabel('Altitude')
    end
end
