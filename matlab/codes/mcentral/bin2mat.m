% BIN2MAT - create a 2D matrix from scattered data without interpolation
% 
%   ZG = BIN2MAT(X,Y,Z,XI,YI) - creates a grid from the data 
%   in the (usually) nonuniformily-spaced vectors (x,y,z) 
%   using grid-cell averaging (no interpolation). The grid 
%   dimensions are specified by the uniformily spaced vectors
%   XI and YI (as produced by meshgrid). 
%
%   ZG = BIN2MAT(...,@FUN) - evaluates the function FUN for each
%   cell in the specified grid (rather than using the default
%   function, mean). If the function FUN returns non-scalar output, 
%   the output ZG will be a cell array.
%
%   ZG = BIN2MAT(...,@FUN,ARG1,ARG2,...) provides aditional
%   arguments which are passed to the function FUN. 
%
%   EXAMPLE
%    
%   %generate some scattered data
%    [x,y,z]=peaks(150);
%    ind=(rand(size(x))>0.9);
%    xs=x(ind); ys=y(ind); zs=z(ind);
%
%   %create a grid, use lower resolution if 
%   %no gaps are desired
%    xi=min(xs):0.25:max(xs);
%    yi=min(ys):0.25:max(ys);
%    [XI,YI]=meshgrid(xi,yi);
%
%   %calculate the mean and standard deviation
%   %for each grid-cell using bin2mat
%    Zm=bin2mat(xs,ys,zs,XI,YI); %mean 
%    Zs=bin2mat(xs,ys,zs,XI,YI,@std); %std
%  
%   %plot the results 
%    figure 
%    subplot(1,3,1);
%    scatter(xs,ys,10,zs,'filled')
%    axis image
%    title('Scatter Data')    
%
%    subplot(1,3,2);
%    pcolor(XI,YI,Zm)
%    shading flat
%    axis image
%    title('Grid-cell Average')
%
%    subplot(1,3,3);
%    pcolor(XI,YI,Zs)
%    shading flat
%    axis image
%    title('Grid-cell Std. Dev.')   
%   
% SEE also RESHAPE ACCUMARRAY FEVAL   
%
% Rev. by Guillaume Maze on 2013-11-07: Added output of cell table list
% A. Stevens 3/10/2009
% astevens@usgs.gov

function [ZG blc_ind] = bin2mat(x,y,z,XI,YI,varargin)

%check inputs
error(nargchk(5,inf,nargin,'struct'));

%make sure the vectors are column vectors
x = x(:);
y = y(:);
z = z(:);

if all(any(diff(cellfun(@length,{x,y,z}))));
    error('Inputs x, y, and z must be the same size');
end

%process optional input
fun=@mean;
test=1;
if ~isempty(varargin)
    fun=varargin{1};
    if ~isa(fun,'function_handle');
        fun=str2func(fun);
    end
    
    %test the function for non-scalar output
    test = feval(fun,rand(5,1),varargin{2:end});
    
end

%grid nodes
xi=XI(1,:);
yi=YI(:,1);
[m,n]=size(XI);

%limit values to those within the specified grid
xmin=min(xi);
xmax=max(xi);
ymin=min(yi);
ymax=max(yi);

gind =(x>=xmin & x<=xmax & ...
    y>=ymin & y<=ymax);

%find the indices for each x and y in the grid
[junk,xind] = histc(x(gind),xi);
[junk,yind] = histc(y(gind),yi);

%break the data into a cell for each grid node
blc_ind = accumarray([yind xind],z(gind),[m n],@(x){x},{NaN});

%evaluate the data in each grid using FUN
if numel(test)>1
    ZG=cellfun(@(x)(feval(fun,x,varargin{2:end})),blc_ind,'uni',0);
else
    ZG=cellfun(@(x)(feval(fun,x,varargin{2:end})),blc_ind);
end
