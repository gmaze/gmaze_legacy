%
% Fonction 
% --------
%
% NE REQUIERT QUE LES INDICES DU PROFIL DANS SA GLOBALITE
%
% 1) Calcule les coefficients d'une droite à partir de 2 points
% -------------------------------------------------------------
% Equation de la droite: y = a x + b
% On connait: les points (x1,y1) et (x2,y2) repérés par leur indice ind1 et
% ind2 dans l'appel de la fonction
% On cherche: a et b
%
% 2) Construit les points du segment d'ajustement à partir:
% -----------------------------------------------------------
%   - des 1er et dernier points du segment
%   - des coeffients a et b de l'equation de la droite (y=ax+b) passant 
% par ces 2 points
%   - des profondeurs (recuperees du profil de base à approximer)
%   - du profil a approximer
%
% [phii,phik,indeik,zk,a] = const_segk(ind1,ind2,var,zvar)
% En entrée:
%   ind1 = indice du 1er  point du segment k (Mdeb(phideb,zdeb))
%   ind2 = indice du 2eme point du segment k (Mfin(phifin,zfin))
%   var  = variable que l'on regarde. Cela peut être psal, tpot, sig0...
%   zvar = vecteur coordonnees verticales (pression ou z?) de var
% En sortie:
%   phik   = valeur du profil (a approximer) entre les points Mdeb et Mfin
%   phii   = valeur du segment d'approximation entre Mdeb et Mfin
%   indeik = indices des points du profil de base
%   zk     = profondeurs comprises entre Mdeb et Mfin
%   a      = coefficient directeur du segment
%
% REMARQUE: Fait pour un seul profil (et non un tableau de profils...)
%

function [phii,phik,indeik,zk,a] = construct_segk(ind1,ind2,var,zvar)

phideb = var(ind1,1);
zdeb   = zvar(ind1,1);
phifin = var(ind2,1);
zfin   = zvar(ind2,1);

% Calcul des coefficients de la droite d'approximation
% ----------------------------------------------------
a = (zfin-zdeb)/(phifin-phideb);
b = zfin - a*phifin;
%p = polyfit([phideb phifin],[zdeb zfin],1);  %% Inverser z et phi
%a = p(1);
%b = p(2);

% Calcul de la taille du segment k (=nombre de points du segment,
% extremites comprises)
% ---------------------
sizek = (find(zvar==zfin) - find(zvar==zdeb)) + 1;    

% Construction variables en sortie
% --------------------------------
indice_deb = find(zvar==zdeb);
for iz = 1:sizek
    % Construction du vecteur zk: portion de zvar correspondant au segment k
    zk(iz)   = zvar(indice_deb + iz - 1);
    % Recuperation des points du profil compris dans l'intervalle [zdeb zfin]
    phik(iz) = var(indice_deb + iz - 1);
    % Construction des points du segment d'approximation k (les phii)
    phii(iz) = (zk(iz)-b)/a;   %% Utiliser polyval 
end
% construction des indices du profil de base
%ind_profil = [1:size(var,1)];
indeik = [ind1:ind2];  %% cf ERR_NORM2 !!!

% Pour tester:
% ------------
% commencer par: 
% clear all
% load info_float6900240 %%(par exemple)
%
% pour tester sur un profil:
% [phii,phik,zk,ii] = construct_segk2(40,80,psalw(:,135),presw(:,135));
%
% verification graphique:
%  plot(psalw(:,1),-presw(:,1))
%  hold on
%  plot(phii,-zk)





