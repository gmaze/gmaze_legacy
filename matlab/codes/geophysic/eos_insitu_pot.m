%	[prd,prhop]=eos_insitu_pot( ptem, psal ,dept,nn_eos)
%       ptem   ! potential temperature  [Celcius]
%       psal   ! salinity               [psu]
%       dept   ! depth                  [m]
%       prd    ! in situ density 
%       prhop  ! potential density (surface referenced)
%       ptem psal and dept must be matrices of the same size 
%     !!----------------------------------------------------------------------
%     !!                  ***  ROUTINE eos_insitu_pot  ***
%     !!           
%     !! ** Purpose :   Compute the in situ density (ratio rho/rau0) and the
%     !!      potential volumic mass (Kg/m3) from potential temperature and
%     !!      salinity fields using an equation of state defined through the 
%     !!     namelist parameter nn_eos.
%     !!
%     !! ** Method  :
%     !!      nn_eos = 0 : Jackett and McDougall (1994) equation of state.
%     !!         the in situ density is computed directly as a function of
%     !!         potential temperature relative to the surface (the opa t
%     !!         variable), salt and pressure (assuming no pressure variation
%     !!         along geopotential surfaces, i.e. the pressure p in decibars
%     !!         is approximated by the depth in meters.
%     !!              prd(t,s,p) = ( rho(t,s,p) - rau0 ) / rau0
%     !!              rhop(t,s)  = rho(t,s,0)
%     !!         with pressure                      p        decibars
%     !!              potential temperature         t        deg celsius
%     !!              salinity                      s        psu
%     !!              reference volumic mass        rau0     kg/m**3
%     !!              in situ volumic mass          rho      kg/m**3
%     !!              in situ density anomalie      prd      no units
%     !!
%     !!         Check value: rho = 1060.93298 kg/m**3 for p=10000 dbar,
%     !!          t = 40 deg celcius, s=40 psu
%     !!
%     !!      nn_eos = 1 : linear equation of state function of temperature only
%     !!              prd(t) = ( rho(t) - rau0 ) / rau0 = 0.028 - rn_alpha * t
%     !!              rhop(t,s)  = rho(t,s)
%     !!
%     !!      nn_eos = 2 : linear equation of state function of temperature and
%     !!               salinity
%     !!              prd(t,s) = ( rho(t,s) - rau0 ) / rau0 
%     !!                       = rn_beta * s - rn_alpha * tn - 1.
%     !!              rhop(t,s)  = rho(t,s)
%     !!      Note that no boundary condition problem occurs in this routine
%     !!      as (tn,sn) or (ta,sa) are defined over the whole domain.
%     !!
%     !! ** Action  : - prd  , the in situ density (no units)
%     !!              - prhop, the potential volumic mass (Kg/m3)
%     !!
%     !! References :   Jackett and McDougall, J. Atmos. Ocean. Tech., 1994
%     !!                Brown and Campana, Mon. Weather Rev., 1978
%     !!----------------------------------------------------------------------
%

function [prd,prhop]=eos_insitu_pot( ptem, psal ,dept,nn_eos)


if size(ptem)~=size(psal) 
    error('error in eos_insitu_pot_mat: temperature and salinity matrices must be of the same size')
end
if size(ptem)~=size(dept) 
    error('error in eos_insitu_pot_mat: temperature and depth matrices must be of the same size')
end

rau0     = 1020.;
rn_alpha = 2.0e-4;   % thermal expension coeff. (linear equation of state)
rn_beta  = 7.7e-4;   % saline  expension coeff. (linear equation of state)


switch nn_eos 
    case 0          % Jackett and McDougall (1994) formulation  ==!
         zrau0r = 1.e0 / rau0;
           
         zt = ptem;
         zs = psal;
         zh = dept;
         zsr= sqrt(abs(psal));              % square root salinity
            
         %compute volumic mass pure water at atm pressure         
         zr1= ( ( ( ( 6.536332e-9.*zt-1.120083e-6 ).*zt+1.001685e-4 ).*zt-9.095290e-3 ).*zt+6.793952e-2 ).*zt+999.842594;
         % seawater volumic mass atm pressure
         zr2= ( ( ( 5.3875e-9.*zt-8.2467e-7 ) .*zt+7.6438e-5 ) .*zt-4.0899e-3 ) .*zt+0.824493;
         zr3= ( -1.6546e-6.*zt+1.0227e-4 ) .*zt-5.72466e-3;
         zr4= 4.8314e-4;
         % potential volumic mass (reference to the surface)
         prhop= ( zr4.*zs + zr3.*zsr + zr2 ) .*zs + zr1;
         % add the compression terms
         ze = ( -3.508914e-8.*zt-1.248266e-8 ) .*zt-2.595994e-6;
         zbw= (  1.296821e-6.*zt-5.782165e-9 ) .*zt+1.045941e-4;
         zb = zbw + ze .* zs;
         
         zd = -2.042967e-2;
         zc =   (-7.267926e-5.*zt+2.598241e-3 ) .*zt+0.1571896;
         zaw= ( ( 5.939910e-6.*zt+2.512549e-3 ) .*zt-0.1028859 ) .*zt - 4.721788;
         za = ( zd.*zsr + zc ) .*zs + zaw;
                  
         zb1=   (-0.1909078.*zt+7.390729 ) .*zt-55.87545;
         za1= ( ( 2.326469e-3.*zt+1.553190).*zt-65.00517 ) .*zt+1044.077;
         zkw= ( ( (-1.361629e-4.*zt-1.852732e-2 ) .*zt-30.41638 ) .*zt + 2098.925 ) .*zt+190925.6;
         zk0= ( zb1.*zsr + za1 ).*zs + zkw;
         % masked in situ density anomaly
         prd = (  prhop ./ (  1.0 - zh ./ ( zk0 - zh .* ( za - zh .* zb ) )  ) - rau0  ) * zrau0r;
         
         
    case 1                 %  Linear formulation = F( temperature )  ==!
         prd= ( 0.0285 - rn_alpha * ptem);
         prhop = ( 1.e0   + prd ) * rau0;


    case 2                 %  Linear formulation = F( temperature , salinity )  ==!
         prd  = ( rn_beta  * psal - rn_alpha * ptem );
         prhop = ( 1.e0   + prd  )* rau0;
end

