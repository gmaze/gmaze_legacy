function [out] = cshift(in,DIM,shift)
%function [out] = cshift(in,DIM,shift)
%
% Replicate the CSHIFT function in F90 (?). 
%
% G. Gebbie, MIT-WHOI, Dec 2003.

 totaldims = ndims(in);
 index = 1: totaldims;
 index(index==DIM) = [];
 index = [DIM index];
 sizin = size(in);
 in = permute(in,index);
 in = reshape(in,sizin(DIM),prod(sizin)./sizin(DIM));

 if shift>=0
   shift = shift - size(in,1);
 end  

 out = [in(shift+1+size(in,1):size(in,1),:);in(1:size(in,1)+shift,:)];
 out = reshape(out,sizin(index));
 out = ipermute(out,index);
