%
% [] = pv_checkpath()
%
% This function detects where the package gmaze_pv is installed
% (the upper level directory where the function volbet2iso
% is found) and ensure that sub-directories are in the path
%

function [] = pv_checkpath()

warning off
% Windows/Linux compatibility
global sla 
sla = '/';
if ispc , sla = '\'; end


% Determine the directory name where the package is installed:
fct_to_find = 'pv_checkpath';
w       = which(fct_to_find);
packdir = w(1:length(w)-(length(fct_to_find)+2));


% Try to found needed subdirectories:

subdir     = struct('name',{'subfct','test','visu','subduc'});

for id = 1 : size(subdir(:),1)
  subdirname = subdir(id).name;
  fullsubdir = strcat(packdir,sla,subdirname);
  if isempty(findstr(path,fullsubdir))
    addpath(fullsubdir)
  end %if
end %for
