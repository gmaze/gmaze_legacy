% ECCO2: potential vorticity toolbox
%
% This package tries to provide some useful and simple routines to compute, visualize and 
% analyze Potential Vorticity from the global high resolution (1/8deg) simulation of the 
% MITgcm.
% Routines are as general as possible for extended applications, but note that they were
% developped to focus on the Western Atlantic region for the CLIMODE project.
% Enjoy !
%
% gmaze@mit.edu
% Last update: Feb1/2007
%
% ---------------------------------------------------------------------------------------------
% PROGRAMS LIST (NOT A FUNCTIONS):
%
% eg_main_getPV
%                             This program is an example of how to define global setup and 
%                             to launch the PV computing.
% eg_write_bin2cdf_latlongrid_subdomain
%                             This program is an example of how to extract a subdomain from 
%                             a lat/lon grid (1/8) binary file and write it into netcdf. A 
%                             directory is created for each time step.
% eg_write_bin2cdf_csgrid_subdomain
%                             This program is an example of how to extract a subdomain from 
%                             a cube sphere grid (CS510) binary file and write it into netcdf
%                             and lat/lon grid (1/4). A directory is created for each time step.
% eg_write_UVbin2cdf_csgrid_subdomain
%                             Idem, except adapted to U and V fields.
%
% ---------------------------------------------------------------------------------------------
% FUNCTIONS LIST 1: NETCDF FILES DIAGNOSTICS
% From netcdf files contained into SNAPSHOT sub-directory of the
% ./netcdf-files/ home folder, these functions ...
%
% A_compute_potential_density(SNAPSHOT)
%                             Computes potential density SIGMATHETA from potential 
%                             temperature THETA and anomalous salinity SALTanom.
% B_compute_relative_vorticity(SNAPSHOT)
%                             Computes the 3 components of the relative vorticity from the
%                             horizontal flow. Take care to the (U,V) grid !
% C_compute_potential_vorticity(SNAPSHOT,[WANT_SPL_PV])
%                             Computes the potential vorticity field from the relative 
%                             vorticity components and the potential density. Option 
%                             WANT_SPL_PV turned 1 (0 by default) makes the function only 
%                             computing the PV based on the planetary vorticity.
% D_compute_potential_vorticity(SNAPSHOT,[WANT_SPL_PV])
%                             Multiplies the potential vorticity computed with 
%                             C_COMPUTE_POTENTIAL_VORTICITY by the coefficient: -1/RHO
%                             Optional flag WANTSPLPV is turned to 0 by default. Turn it to 1
%                             if the PV computed was the simple one (f.dSIGMATHETA/dz). It's 
%                             needed for the output netcdf file informations.
% compute_JBz(SNAPSHOT)
%                             Computes the surface PV flux due to diabatic processes.
% compute_JFz(SNAPSHOT)
%                             Computes the surface PV flux due to frictionnal forces.
% compute_density(SNAPSHOT)
%                             Computes density RHO from potential temperature THETA 
%                             and anomalous salinity SALTanom.
% compute_alpha(SNAPSHOT)
%                             Computes the thermal expansion coefficient ALPHA from potential 
%                             temperature THETA and salinity anomaly SALTanom.
% compute_QEk(SNAPSHOT)
%                             Computes QEk, the lateral heat flux induced by Ekman currents
%                             from JFz, the PV flux induced by frictional forces.
% compute_EKL(SNAPSHOT)
%                             Compute the Ekman Layer Depth from the wind stress and the density
%                             fields.
% compute_MLD(SNAPSHOT)
%                             Compute the Mixed Layer Depth from the SST, SSS and potential
%                             density fields.
%
% ---------------------------------------------------------------------------------------------
% FUNCTIONS LIST 2: ANALYSIS FUNCTIONS
%
% volbet2iso(TRACER,LIMITS,DEPTH,LAT,LONG)
%                             This function computes the volume embedded between two
%                             iso-TRACER values and limited eastward, westward and southward
%                             by fixed limits.
% surfbet2outcrops(TRACER,LIMITS,LAT,LONG)
%                             This function computes the horizontal surface limited
%                             by two outcrops of a tracer.
% intbet2outcrops(TRACER,LIMITS,LAT,LONG)
%                             This function computes the horizontal surface integral
%                             of the field TRACER on the area limited by two outcrops.
% subfct_getisoS(TRACER,ISO)
%                             This function determines the iso-surface ISO of the 
%                             3D field TRACER(Z,Y,X).
%
% ---------------------------------------------------------------------------------------------
% LOWER LEVEL AND SUB-FUNCTIONS LIST:
%
% pv_checkpath
%                             This function, systematicaly called by the others, ensures that 
%                             all needed sub-directories of the package are in the path.
%
% ---------------------------------------------------------------------------------------------
% PS:
%
% > Functions name are case sensitive.
% > See sub-directory "subfct" for further functions.
% > Following packages are required: 
%   M_MAP:    http://www.eos.ubc.ca/~rich/map.html
%   SEAWATER: http://www.marine.csiro.au/datacentre/processing.htm
%
% ---------------------------------------------------------------------------------------------
%
