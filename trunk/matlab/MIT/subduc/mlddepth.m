function [mld,rho] = mldepth(T,S,depth,epsilon)
%function [mld,rho] = mldepth(T,S,depth,epsilon)
%
% Solve for mixed layer depth on a 1-meter resolution grid.
% 
% Handles input temperature and salinity of any dimension, i.e. 2-D, 3-D,
% 4-D, with time and space in any order.
% 
% Returns mixed layer depth in same dimension as T,S, except without 
% the vertical dimension.
%
% depth = depths on which theta and S are defined.
% epsilon = threshold for density difference, surface to mixld.
%
% Method: Solve for potential density with the surface reference pressure.
%         Interpolate density onto a 1-meter resolution grid.
%         Search for the depth where surface density differs by some
%         threshold. This depth is the mixed layer depth.
%
% G. Gebbie, MIT-WHOI, August 22, 2001. on board the R/V Oceanus.
%
% Vectorized for Matlab, November 2003. GG. MIT-WHOI.
%
% required: seawater toolbox. WARNING: SEAWATER TOOLBOX SYNTAX
%  MAY HAVE CHANGED.

 mldlimit = 500 ;%  a priori maximum limit of mixed layer depth

 S( S == 0) = NaN;
 T( T == 0) = NaN;

% mldlimit is the limit of mixed layer depth here.
 grrid = (2*depth(1)):1:mldlimit;
 
% Set reference pressure to zero. Should not make a difference if mixld < 500.
 pr =0;

%%  The vertical direction is special. Its dimension is specified by "depth". 
 nz = length(depth);

 nn = size(T);

%% Find vertical dimension.
 zindex = find(nn==nz);

 oindex = 1:ndims(T);
 oindex(oindex==zindex)=[];
 nx = prod(nn(oindex));

%% Put the vertical direction at the end. Squeeze the rest.
 temp = permute(T,[oindex zindex]);
 temp = reshape(temp,nx,nz);
% temp (temp==0) = nan;

 salt = permute(S,[1 2 4 3]);
 salt = reshape(salt,nx,nz);
% salt (salt==0) = nan;
  
 pden = sw_pden(salt,temp,depth,pr);

 if nargout ==2
   rho = reshape(pden,[nn(oindex) nz]) ;  
   rho = permute(rho,[1 2 4 3]);
 end
  
 temphi = interp1( depth', pden', grrid);
 differ = cumsum(diff(temphi));

 %% preallocate memory.
 mld = zeros(nx,1);
 
 % how would one vectorize this section?
 for i = 1:nx
    index =find(differ(:,i)> epsilon);
   if( isempty ( index) ==1)
     tmpmld  = NaN;
   else
     tmpmld = grrid( index(1));
   end 
   mld(i) = tmpmld;
 end

 % Make the user happy. Return mixed layer depth in the same form as the
 % input T,S, except vertical dimension is gone.
 
 mld = reshape(mld,[nn(oindex) 1]);
 mld = squeeze(mld);

 mld(isnan(mld)) = 0;
 
 return
