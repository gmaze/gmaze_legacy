function [sann,stot,latind,wmstar] = diag_sann(umean,vmean,wmean,maxmld,Z,delZ,dxc,dyc,raw,mask);
%function [sann,stot,latind,wmstar] = diag_sann(umean,vmean,wmean,maxmld,Z,delZ,dxc,dyc,raw,mask)
%
% Diagnose annual subduction rate of Marshall et al 1993.
% S_ann = -w_H - u_H . del H, [m/yr]
%
% Also, diagnose S_tot, total subduction estimated from
%  annual subduction rate.
% S_tot = \int S_ann dt dA, [Sv]
%
% intermediate terms of calculation:
% latind = u_H . del H = lateral induction
% wmstar = w_H = vertical velocity at h = maxmld.
%
% mask = 2D mask for calculation of subrate.
%
% Z     < 0
% delZ  < 0
% h     < 0 
%
% Started: D. Jamous 1996, Fortran diagnostics.
% Updated: G. Gebbie, 2003, MIT-WHOI for Matlab.

 %% map the mean velocity onto the maxmld surface.
 [umstar,vmstar,wmstar] = get_mldvel(umean,vmean,wmean,Z,delZ,maxmld);

 %% compute mean lateral induction.
 [latind] = diag_induction(umstar,vmstar,maxmld,dxc,dyc);

 sann = -wmstar - latind;

 sann = sann .*86400 .*365; %convert to meters/year.
 
 sanntmp = sann;
 sanntmp(isnan(sanntmp))=0;
 stot=nansum(nansum(sanntmp.*raw.*mask))./(86400)./365 
 
 return
