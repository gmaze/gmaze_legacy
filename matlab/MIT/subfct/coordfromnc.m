% [X,Y,Z] = COORDFROMNC(NC)
%
% Given a netcdf file, return 3D coordinates values 
% in X, Y and Z
%


function varargout = coordfromnc(nc)

co = coord(nc);


switch nargout
 case 1
  varargout(1) = {co{1}(:)};
 case 2
  varargout(1) = {co{1}(:)};
  varargout(2) = {co{2}(:)};
 case 3
  varargout(1) = {co{1}(:)};
  varargout(2) = {co{2}(:)};
  varargout(3) = {co{3}(:)};
 case 4
  varargout(1) = {co{1}(:)};
  varargout(2) = {co{2}(:)};
  varargout(3) = {co{3}(:)};
  varargout(4) = {co{4}(:)};
end
