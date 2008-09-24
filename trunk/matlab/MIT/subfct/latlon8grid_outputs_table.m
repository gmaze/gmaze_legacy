function otab = latlon8grid_outputs_table

% otab = latlon8grid_outputs_table()
% Output Fields from 1/8 simulations
% 1 - file prefix
% 2 - dimensions
% 3 - grid location
% 4 - id string (defaults to file prefix if unknown)
% 5 - units
% 6 - bytes per value


otab=[{'AREAtave'},   {'xy'}, {'c'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'ETAN'},       {'xy'}, {'c'}, {'ssh'}, {'m'}, {4},
      {'ETANSQ'},     {'xy'}, {'c'}, {'ssh_squared'}, {'m^2'}, {4},
      {'EXFhl'},      {'xy'}, {'c'}, {'latent_heat_flux'}, {'W/m^2'}, {4},
      {'EXFhs'},      {'xy'}, {'c'}, {'sensible_heat_flux'}, {'W/m^2'}, {4},
      {'EXFlw'},      {'xy'}, {'c'}, {'longwave_radiation'}, {'W/m^2'}, {4},
      {'EXFsw'},      {'xy'}, {'c'}, {'shortwave_radiation'}, {'W/m^2'}, {4},
      {'EmPmRtave'},  {'xy'}, {'c'}, {'net_evaporation'}, {'m/s'}, {4},
      {'FUtave'},     {'xy'}, {'c'}, {'averaged_zonal_stress'}, {'N/m^2'}, {4},
      {'FVtave'},     {'xy'}, {'c'}, {'averaged_meridional_stress'}, {'N/m^2'}, {4},
      {'HEFFtave'},   {'xy'}, {'c'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'KPPhbl'},     {'xy'}, {'c'}, {'thermocline_base'}, {'m'}, {4},
      {'KPPmld'},     {'xy'}, {'c'}, {'mixed_layer_depth'}, {'m'}, {4},
      {'PHIBOT'},     {'xy'}, {'c'}, {'bottom_pressure'}, {'Pa'}, {4},
      {'QNETtave'},   {'xy'}, {'c'}, {'averaged_net_heatflux'}, {'W/m^2'}, {4},
      {'QSWtave'},    {'xy'}, {'c'}, {'averaged_shortwave_heatflux'}, {'W/m^2'}, {4},
      {'SFLUX'},      {'xy'}, {'c'}, {'salinity_flux'}, {'psu/s'}, {4},
      {'SRELAX'},     {'xy'}, {'c'}, {'salinity_relaxation'}, {'psu/s'}, {4},
      {'SSS'},        {'xy'}, {'c'}, {'sea_surface_salinity'}, {'psu'}, {4},
      {'SST'},        {'xy'}, {'c'}, {'sea_surface_temperature'}, {'degrees_centigrade'}, {4},
      {'TAUX'},       {'xy'}, {'c'}, {'zonal_wind_stress'}, {'N/m^2'}, {4},
      {'TAUY'},       {'xy'}, {'c'}, {'meridional_wind_stress'}, {'N/m^2'}, {4},
      {'TFLUX'},      {'xy'}, {'c'}, {'temperature_flux'}, {'W/m^2'}, {4},
      {'TICE'},       {'xy'}, {'c'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'UICEtave'},   {'xy'}, {'u'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'UVEL_k2'},    {'xy'}, {'u'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'VICEtave'},   {'xy'}, {'v'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'VVEL_k2'},    {'xy'}, {'v'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'DRHODR'},    {'xyz'}, {'w'}, {'vertical_density_gradient'}, {'kg/m^4'}, {4},
      {'RHOANOSQ'},  {'xyz'}, {'c'}, {'density_anomaly_squared'}, {'(kg/m^3-1000)^2'}, {4},
      {'RHOAnoma'},  {'xyz'}, {'c'}, {'density_anomaly'}, {'kg/m^3-1000'}, {8},
      {'SALTSQan'},  {'xyz'}, {'c'}, {'salinity_anomaly_squared'}, {'(psu-35)^2'}, {4},
      {'SALTanom'},  {'xyz'}, {'c'}, {'salinity_anomaly'}, {'psu-35'}, {8},
      {'THETA'},     {'xyz'}, {'c'}, {'potential_temperature'}, {'degrees_centigrade'}, {8},
      {'THETASQ'},   {'xyz'}, {'c'}, {'potential_temperature_squared'}, {'degrees_centigrade^2'}, {8},
      {'URHOMASS'},  {'xyz'}, {'u'}, {'zonal_mass_transport'}, {'kg.m^3/s'}, {4},
      {'USLTMASS'},  {'xyz'}, {'u'}, {'zonal_salt_transport'}, {'psu.m^3/s'}, {4},
      {'UTHMASS'},   {'xyz'}, {'u'}, {'zonal_temperature_transport'}, {'degrees_centigrade.m^3/s'}, {4},
      {'UVEL'},      {'xyz'}, {'u'}, {'zonal_flow'}, {'m/s'}, {4},
      {'UVELMASS'},  {'xyz'}, {'u'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'UVELSQ'},    {'xyz'}, {'u'}, {'zonal_flow_squared'}, {'(m/s)^2'}, {4},
      {'UV_VEL_Z'},  {'xyz'}, {'u'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'VISCA4'},    {'xyz'}, {'c'}, {'biharmonic_viscosity'}, {'m^4/s'}, {4},
      {'VRHOMASS'},  {'xyz'}, {'v'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'VSLTMASS'},  {'xyz'}, {'v'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'VTHMASS'},   {'xyz'}, {'v'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'VVEL'},      {'xyz'}, {'v'}, {'meridional_velocity'}, {'m/s'}, {4},
      {'VVELMASS'},  {'xyz'}, {'v'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'VVELSQ'},    {'xyz'}, {'v'}, {'meridional_velocity_squared'}, {'(m/s)^2'}, {4},
      {'WRHOMASS'},  {'xyz'}, {'w'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'WSLTMASS'},  {'xyz'}, {'w'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'WTHMASS'},   {'xyz'}, {'w'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'WU_VEL'},    {'xyz'}, {'w'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'WVELMASS'},  {'xyz'}, {'w'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'WVELSQ'},    {'xyz'}, {'w'}, {'unknown_id'}, {'unknown_units'}, {4},
      {'WV_VEL'},    {'xyz'}, {'w'}, {'unknown_id'}, {'unknown_units'}, {4}];

