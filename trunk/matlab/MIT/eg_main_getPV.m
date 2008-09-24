% 
% THIS IS NOT A FUNCTION !
%
% Here is the main program to compute the potential vorticity Q
% from the flow (UVEL,VVEL), potential temperature (THETA) and
% salinity (SALTanom), given snapshot fields.
% 3 steps to do it:
%   1- compute the potential density SIGMATHETA (also called ST)
%      from THETA and SALTanom: 
%      ST = SIGMA(S,THETA,p=0)
%   2- compute the 3D relative vorticity field OMEGA (called O)
%      without vertical velocity terms:
%      O = ( -dVdz ; dUdz ; dVdx - dUdy )
%   3- compute the potential vorticity Q:
%      Q = Ox.dSTdx + Oy.dSTdy + (f+Oz).dSTdz
%      (note that we only add the planetary vorticity at this last
%      step).
%      It's also possible to add a real last step 4 to compute PV as:
%      Q = -1/RHO * [Ox.dSTdx + Oy.dSTdy + (f+Oz).dSTdz]
%      Note that in this case, program loads the PV output from the
%      routine C_compute_potential_vorticity (step 3) and simply multiply 
%      it by: -1/RHO.
%      RHO may be computed with the routine compute_density.m
%
%
% Input files are supposed to be in a subdirectory called: 
% ./netcdf-files/<snapshot>/
%
% File names id are stored in global variables:
%    netcdf_UVEL, netcdf_VVEL, netcdf_THETA, netcdf_SALTanom
% with the format:
%    netcdf_<ID>.<netcdf_domain>.<netcdf_suff>
% where netcdf_domain and netcdf_suff are also in global
% THE DOT IS ADDED IN SUB-PROG, SO AVOID IT IN DEFINITIONS
%
% Note that Q is not initialy defined with the ratio by -RHO.
%
% A simple potential vorticity (splQ) computing is also available.
% It is defined as: splQ = f. dSIGMATHETA/dz
% 
% 30Jan/2007
% gmaze@mit.edu
%
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   SETUP:
pv_checkpath


% File's name:
global netcdf_UVEL netcdf_VVEL netcdf_THETA 
global netcdf_SALTanom is_SALTanom
global netcdf_TAUX netcdf_TAUY netcdf_SIGMATHETA 
global netcdf_RHO netcdf_EKL netcdf_Qnet netcdf_MLD
global netcdf_JFz netcdf_JBz
global netcdf_suff netcdf_domain sla
netcdf_UVEL     = 'UVEL';
netcdf_VVEL     = 'VVEL';
netcdf_THETA    = 'THETA';
netcdf_SALTanom = 'SALTanom'; is_SALTanom = 1;
netcdf_TAUX     = 'TAUX';
netcdf_TAUY     = 'TAUY';
netcdf_SIGMATHETA = 'SIGMATHETA';
netcdf_RHO      = 'RHO';
netcdf_EKL      = 'EKL';
netcdf_MLD      = 'KPPmld'; %netcdf_MLD      = 'MLD';
netcdf_Qnet     = 'TFLUX';
netcdf_JFz      = 'JFz'; 
netcdf_JBz      = 'JBz'; 
netcdf_suff     = 'nc';
netcdf_domain   = 'north_atlantic'; % Must not be empty !



% FLAGS:
% Turn 0/1 the following flag to determine which PV to compute:
wantsplPV = 0; % (turn 1 for simple PV computing)
% Turn 0/1 this flag to get online computing informations:
global toshow
toshow = 0;

% Get date list:
ll = dir(strcat('netcdf-files',sla));
nt = 0;
for il = 1 : size(ll,1)
  if ll(il).isdir & findstr(ll(il).name,'00')
    nt = nt + 1;
    list(nt).name = ll(il).name;
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TIME LOOP
for it = 1 : nt
  % Files are looked for in subdirectory defined by: ./netcdf-files/<snapshot>/
  snapshot = list(it).name;
  disp('********************************************************')
  disp('********************************************************')
  disp(snapshot)
  disp('********************************************************')
  disp('********************************************************')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   COMPUTING PV:
% STEP 1:
% Output netcdf file is:
%       ./netcdf-files/<snapshot>/SIGMATHETA.<netcdf_domain>.<netcdf_suff>
A_compute_potential_density(snapshot)
compute_density(snapshot)


% STEP 2:
% Output netcdf files are:
%       ./netcdf-files/<snapshot>/OMEGAX.<netcdf_domain>.<netcdf_suff>
%       ./netcdf-files/<snapshot>/OMEGAY.<netcdf_domain>.<netcdf_suff>
%       ./netcdf-files/<snapshot>/ZETA.<netcdf_domain>.<netcdf_suff>
% No interest for the a splPV computing
if ~wantsplPV
   B_compute_relative_vorticity(snapshot)
end %if

% STEP 3:
% Output netcdf file is:
%       ./netcdf-files/<snapshot>/PV.<netcdf_domain>.<netcdf_suff>
C_compute_potential_vorticity(snapshot,wantsplPV)

% STEP 4:
% Output netcdf file is (replace last one):
%       ./netcdf-files/<snapshot>/PV.<netcdf_domain>.<netcdf_suff>
global netcdf_PV
if wantsplPV == 1
  netcdf_PV = 'splPV';
else
  netcdf_PV = 'PV';
end %if
D_compute_potential_vorticity(snapshot,wantsplPV)


% OTHER computations:
if 0
 compute_alpha(snapshot)
 compute_MLD(snapshot)
 compute_EKL(snapshot)
 compute_JFz(snapshot);
 compute_JBz(snapshot);
 compute_Qek(snapshot);
end %if 1/0


fclose('all');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THAT'S IT !
end %for it


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THAT'S IT !

% Keep clean workspace:
clear wantsplPV toshow netcdf_*
clear global wantsplPV toshow netcdf_*
