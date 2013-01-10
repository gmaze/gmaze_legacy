% MY CODES: GEOPHYSIC
% Version 1 1 10-Jan-2013
% 
% 		Contents from /Users/gmaze/matlab/codes/geophysic
% 
% Last update: 2013 January 10, 15:02
% 
% 	WOA05_grid                               - Read World Ocean Atlas 2005 grid
% 	compute_air_sea_o2_flux                  - Compute air-sea oxygen flux
% 	constraint_jstar                         - H1LINE
% 	convert_oxygen                           - O2 unit conversion
% 	convert_unit                             - Convert unit of oceanic concentration substance
% 	csvreadargo                              - H1LINE
% 	csvreadargo2                             - H1LINE
% 	densjmd95                                - Density of sea water
% 	dfromo                                   - Compute distances of points from an origin
% 	diagCatH                                 - Compute a 3D field projection on a 2D surface
% 	diagHatisoC                              - Compute iso-surface of a 3D field
% 	diag_PV                                  - PV = diag_PV(LON,LAT,DPT,SIGMATHETA,RHO)
% 	diag_interpallREQ                        - NEWFIELD = diag_interpallREQ(FIELD,LON,LAT,netcdf_domain,resolution,...
% 	dinterp3bin                              - Interpolate a 3D field
% 	dinterp3bin_grid                         - Compute the new grid for DINTERP3BIN interpolated fields
% 	dlowerres                                - Reduce the resolution of a field
% 	drawmpoly                                - drawpoly Draw a polygon on a map (using m_map)
% 	dwn_nao                                  - Download the monthly NAO index
% 	fillgaps                                 - Try to fill gaps in 2D geograpical field
% 	getGRD                                   - Compute horizontal gradient of a geographical field
% 	get_elev_along_track                     - elev_along_track Determine topograpahy along ship track
% 	get_mld                                  - Compute a mixed layer depth
% 	get_mmld_along_track                     - Get Boyer-Montegut MLD climatology along a track
% 	get_occaclim_along_track                 - get_occa_along_track H1LINE
% 	get_ovide_track                          - Load OVIDE track
% 	get_thd                                  - Determine the seasonal and main thermocline depths
% 	get_thdv2                                - H1LINE
% 	get_woa_along_track                      - Interpolate World Ocean Atlas data along a ship track
% 	getdS                                    - Compute 2D surface elements matrix
% 	getdV                                    - Compute 3D volume elements matrix
% 	guiOCCA                                  - GUI to OCCA dataset
% 	lldist                                   - Compute distance in m between two points on Earth
% 	load_climOCCA                            - Load any climatological fields from OCCA
% 	load_maskOCCA                            - Load any mask from OCCA
% 	m_drawbox                                - Draw a rectangular box using m_line
% 	oc_vmodes                                - Compute vertical mode solutions
% 	piston_velocity                          - Compute a gaz air-sea interface transfer velocity (piston velocity)
% 	plotts                                   - Plot Temperature, Salinity on a T,S diag
% 	project3don2d                            - Project a 3D field on a 2D surface
% 	scalprod                                 - Cross or dot product of two 3D scalar fields
% 	schmidt_number                           - Compute a Schmidt number
% 	select_1transect                         - Extract only one transect from a campaign
% 	simplify_unit                            - Simplify unit expression
% 	typicalyear                              - Compute a typical year from a daily volume time serie
% 	udunits                                  - Unidata units library
% 
% This Contents.m file was automatically created using: /Users/gmaze/matlab/codes/inout/tbcont
% 
