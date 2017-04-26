%
% Fonction
% Application de la methode SPLIT & MERGE pour definir la MLD
%
% [mld,nb_pb,a,nb_seg_merge] = SandM_gm(phi,deph,eps,plt)
% 
% En entrée:
%       - phi  (nz,1) : profil sur lequel on travaille (densité, salinité, température)
%       - deph (nz,1): profondeur (> 0)
%       - eps: choix la norme d'erreur qu'on ne veut pas dépasser
%       - plt: 'yes' or 'no' (trace les différentes étapes de la fonction)
% 
% En sortie:
%       - mld: profondeur de la couche de mélange (> 0)
%       - nb_pb: vecteur de 3 colonnes (nb_pb = [nb_pbz0 nb_pbM1 nb_pbzmax])
%                nb_pbz0, nb_pbM1, nb_pbzmax = 0 s'il n'y a pas eu de pb pour définir M0, M1 ou Mmax
%                                              1 sinon 
%       - a: le coefficient directeur de tous les segments d'approximation
%       - nb_seg_merge: nombre de segments à la fin de l'étape merge

function [mld,nb_pb,a,nb_seg_merge] = SandM_gm(phi,deph,eps,plt)
  
%% Choix des paramètres
% ---------------------
pz0     = 10;                    % Premier point du profil en surface (en m)  
% pzmax   = max(dephmldDBM)+300;   % Dernier point du profil en profondeur (en m) 
epsilon = eps;                   % critère norme d'erreur à ne pas dépasser
% eps = 0.002 ou 0.003 = meilleur critère?
epsilon = epsilon*epsilon;
% !!  IMPORTANT !!
% If you specify an error norm of 0.003-0.005, you will obtain the 
% mixing depth for a diurnal-type mixed layer. However, for 
% seasonal or interannual scale analyses, we advise you to use a larger
% value of the error norm (up to 0.015)
% ------------------------
%% FIN Choix des paramètres
pz0 = deph(1);
%% Initialisation
% ---------------
%
% Identifier z0 et zmax tels que:
%   - z0 soit la plus petite valeur entre pz0 (10m) et pz0+10 (20m): Cf
%     choix paramètres
%   - zmax soit (la plus grande valeur de MLD trouvée dans la zone d'étude)
%     + 300m. On utilise pour ça les estimations de MLD via la méthode
%     threshold de De Boyer Montegut 
% Identifier les coordonnées des 2 premiers break points tels que:
%   - M1(phi1,z1) soit la MLD calculée par la méthode de 
%     De Boyer Montegut
%   - M2(phi2,z2) soit arbitrairement choisi à la moitié de la distance 
%     entre le premier point de rupture et zmax.

% Determination de M0(phi0,z0), Mmax(phimax,zmax) et M1(phi1,z1)
% --------------------------------------------------------------

indices_z0   = find((pz0 <= deph) &  (deph <= (pz0+10)));
if ( (isempty(indices_z0)==1) && (min(deph) <= 40) )
    indices_z0 = find(deph == min(deph));
end

if ( max(deph) >= 800 ) 
%mat%    indices_zmax = find(deph == max(deph));
    indices_zmax = find(deph == max(deph));
else
    indices_zmax = [];
end

indices_M1 = floor(max(find(isfinite(deph)==1)) / 2 );

nb_pbz0   = 0;
nb_pbzmax = 0;   
nb_pbM1   = 0; 

if ((isempty(indices_z0)==0) && (isempty(indices_zmax)==0) && (isempty(indices_M1)==0))
    indz0   = indices_z0(1);                         % On prend la plus petite valeur (choix arbitraire) 
    indzmax = indices_zmax(size(indices_zmax,1));    % On prend la plus grande valeur (choix arbitraire)
    indM1   = indices_M1(size(indices_M1,1));        % On prend la plus grande valeur (choix arbitraire)
         
    z0      = deph(indz0);
    zmax    = deph(indzmax);
    z1      = deph(indM1);
    
    phi0    = phi(indz0);
    phimax  = phi(indzmax);   
    phi1    = phi(indM1);
    
    % Tableau des indices des break points
    % ------------------------------------
    indBP(1) = indz0;
    indBP(2) = indM1;    
    indBP(3) = indzmax;
        
    % Nombre de segments et de break points (initiaux)
    % ------------------------------------------------
    nb_BP  = 3; 
    nb_seg = nb_BP-1;
    
    % ------------------ 
    %% FIN initialisation

    %% Tracé INIT
    switch plt
        case 'yes'
            tabcol = hsv(nb_seg);
            figure(1)
            plot(phi,-deph,'-k','linewidth',2)
            hold on
            for ins = 1:nb_seg
              [phii,phik,ind_profil,zk] = construct_segk(indBP(ins),indBP(ins+1),phi,deph); 
              plot(phii,-zk,'color',tabcol(ins,:),'linewidth',2) 
            end
            grid
            title('INITIALISATION')
    end
    %%
    
    %% SPLIT
    % -----
   
    indic = 1;
    while (indic ~= 0)
        indic = 0;
        
        for iBP = 1:nb_seg
            
            % Rmq: indeik = indices dans le repère du profil
            [phii,phik,indeik] = construct_segk(indBP(iBP),indBP(iBP+1),phi,deph);
            [ek,eik]           = err_norm(phii,phik);  
            
            if ek > epsilon     % si (ek > eps) alors trouver les coordonnées du nouveau BP
                indic       = indic + 1;
                nb_BP       = nb_BP + 1;
                ind_eiksup  = find(eik > epsilon); % indices dans le repère du segment
                
                % Localisation de l'indice du max de diff entre l'ajustement et la courbe
                max_eik     = eik(ind_eiksup(1));
                ind_max_eik = indeik(ind_eiksup(1)); 
                for ii = 1:(size(ind_eiksup,2)-1)
                    if (eik(ind_eiksup(ii+1)) > max_eik);
                        max_eik     = eik(ind_eiksup(ii+1));
                        ind_max_eik = indeik(ind_eiksup(ii+1));   % Indice du nouveau BP
                    end
                end
                indBP(nb_BP)  = ind_max_eik;
                ind_eiksup(:) = nan;
            end
            phii(:)    = nan;
            phik(:)    = nan;
            ek         = nan;
            eik(:)     = nan;          
        
        end
        nb_seg = nb_BP - 1;
        indBP  = sort(indBP);   
  
    end
    nb_seg_split = nb_seg;

    % ---------
    %% FIN SPLIT

    %% Tracé SPLIT
    switch plt
        case 'yes'
            tabcol = hsv(nb_seg);
            figure(2)
            plot(phi,-deph,'-k','linewidth',2)
            hold on
            for ins = 1:nb_seg
              [phii,phik,ind_profil,zk] = construct_segk(indBP(ins),indBP(ins+1),phi,deph); 
              plot(phii,-zk,'color',tabcol(ins,:),'linewidth',2) 
            end
            grid
            title('SPLIT')
    end
    %%
    
    %% MERGE
    % -----

    % Calcul de la norme d'erreur si on mergeait tous les segments 2 à 2
    indic2 = 1;
    while (indic2 ~= 0)    
    indic2  = 0;
    nb_test = nb_seg - 1;
        for ik = 1:nb_test
            [ek,eik,indeik] = err_norm2(indBP(ik),indBP(ik+2),phi,deph);
            tab_ek(ik,1)    = ek;
        end
        indek = find(tab_ek < epsilon);
        if (isempty(indek) == 0)
           indic2 = indic2 + 1;
           % Localisation du min d'erreur trouvé parmi tous ceux dont l'erreur est < eps
           ind_min_ek = indek(1);
           min_ek     = tab_ek(indek(1));
           for idk = 1:(size(indek,2)-1)
               if tab_ek(indek(idk+1)) < min_ek
                   min_ek     = tab_ek(indek(idk+1));
                   ind_min_ek = indek(idk+1);   % Indice du segment a merger avec le suivant (ind_min_ek+1)
               end
           end
           % Elimination du BP en trop (MERGE)
           for im = (ind_min_ek+1):(size(indBP,2)-1)
               indBP(im) = indBP(im+1);
           end
       
           indBP  = indBP(1:nb_BP-1);
           nb_BP  = nb_BP - 1;
           nb_seg = nb_seg - 1;
        end
        indek(:)  = nan;
        tab_ek(:) = nan;
    
    end
    nb_seg_merge = nb_seg;

    % ---------
    %% FIN MERGE

    %% Calcul des pentes des segments
    for is = 1:nb_seg_merge
       [fonct,segm,indi,zk,a(is)] = construct_segk(indBP(is),indBP(is+1),phi,deph);  
    end    
    aabs    = abs(a); 
    
    mld     = deph(indBP(2));
         
     %% Tracé MERGE
     switch plt	     
	 case 'yes'	
    	    tabcol = hsv(nb_seg);
            figure(3)
            hold on
            plot([min(phi) max(phi)],[-mld -mld],'-m')
            % Profil étudié:
            plot(phi,-deph)
            % Segments:
            for ins = 1:nb_seg
               [phii,phik,ind_profil,zk] = construct_segk(indBP(ins),indBP(ins+1),phi,deph); 
               plot(phii,-zk,'color',tabcol(ins,:),'linewidth',2)          
            end
            grid
            title('MERGE')
     end
     %% FIN Tracé MERGE
     
else

    if (isempty(indices_zmax)==1)
        disp(sprintf('Impossible to compute mld - pb with zmax'));
        nb_pbzmax = nb_pbzmax + 1;
    end
    if (isempty(indices_z0)==1)
        disp(sprintf('Impossible to compute mld - pb with z0'));
        nb_pbz0 = nb_pbz0 + 1;
    end
    if (isempty(indices_M1)==1)
        disp(sprintf('Impossible to compute mld - pb with M1'));
        nb_pbM1 = nb_pbM1 + 1;
    end
    mld          = nan;
    a            = nan;
    nb_seg_merge = nan;
    
end

nb_pb = [nb_pbz0 nb_pbM1 nb_pbzmax];

end% function

%
% Fonction:
% Calcule la norme d'erreur entre une courbe et son approximation
% ---------------------------------------------------------------
% On connaît le premier Mdeb=(phideb,zdeb) et le dernier Mfin=(phifin,zfin) 
% point de la courbe phik(z). 
% L'approximation est un segment passant par ces 2 points Mdeb et Mfin.
% 
% Calcul de la norme d'erreur:
% ek = somme(eki²)
% eki = abs(phii(zi) - phik(zi))  !! phii et phik doivent etre de meme
% dimension
%
% Noter que:
% i = indices des points du segment (approx)
% phii = ordonnees des points du segment d'approximation
% phik = ordonnees des points de la courbe reelle entre Mdeb et Mfin!!
 
function [ek,eik] = err_norm(phii,phik)
ek = 0;
for ip = 1:size(phii,2)
    eik(ip) = abs(phii(ip) - phik(ip));
    ek      = ek + eik(ip)*eik(ip);
end
%stophere
ek = ek/(size(phik,2)-1);

end%function



%
% Fonction:
% Calcule la norme d'erreur entre une courbe et son approximation
% ---------------------------------------------------------------
% 
% [ek,eik,indik] = err_norm2(ind1,ind2,var,zvar)
% 
% En entree:
%   Indices des 2 points (ind1,ind2) entre lesquels  on construit le
%   segment d'approximation et on calcule la norme d'erreur
%
% En sortie
%   ek  = somme(eki²) => Norme d'erreur
%   eki => différence entre courbe et approx en chaque point
%   ind_profil = indices de la portion de courbe qu'on traite dans le
%                repère du profil dans sa totalite. (Exple: profil ayant
%                indices de 0 à 120 et on regarde segment entre indices 12
%                à 52. ind_profil contiendra tous les indices de 12 à 52 et
%                sera de dimension 40).
%
% Noter que:
% i = indices des points du segment (approx)
% phii = ordonnees des points du segment d'approximation
% phik = ordonnees des points de la courbe reelle entre Mdeb et Mfin!!

 
function [ek,eik,indeik] = err_norm2(ind1,ind2,var,zvar)

[phii,phik] = construct_segk(ind1,ind2,var,zvar);


ek = 0;
for ip = 1:size(phii,2)
    eik(ip) = abs(phii(ip) - phik(ip));     % Calcul de la norme d'erreur
    ek      = ek + eik(ip)*eik(ip);         % Calcul de la norme d'erreur
end
%stophere
ek = ek/(size(phik,2)-1);

indeik = [ind1:ind2];

end%function

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

end%function













