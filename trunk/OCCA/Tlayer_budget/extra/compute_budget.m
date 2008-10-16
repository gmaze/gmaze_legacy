%DEF Compute the volume budget in Matlab, this is not the main routine and only gives a guess
%
%
% Created by Guillaume Maze on 2008-10-13.
% Copyright (c) 2008 Guillaume Maze. 
% http://www.guillaumemaze.org/codes

%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    any later version.
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

clear

%%%%%%%%%%%% TUNING SECTION !

patho    = '~/data/OCCA/Tlayer_budget/KESS/r1/130/LRfiles/'; mydomain = [130 180 90 135 1 25];
%patho    = '~/data/OCCA/Tlayer_budget/KESS/r1/122/LRfiles/'; mydomain = [122 180 90 130 1 25];
patho    = '~/data/OCCA/Tlayer_budget/KESS/r1/wholeNP/LRfiles/'; mydomain = [110 260 90 147 1 25]; % Whole North Pacific


% METHOD Used in the computation:
method = 0; % No interpolation
%method = 1; % Interpolation of all fields
method = 2; % Interpolation only of the layer def, keep other term on a medium grid

% Do we compute the budget or just the volume time serie ?
cpt_bdg   = 1;
cpt_bdg3d = 1; % Do we get 3D maps ?

% Interpolation parameters:
Rfact = 12; Rfact_dw = 3; 
%Rfact = 8;  Rfact_dw = 4;
Rfact = 6;  Rfact_dw = 3;
Rfact = 4;  Rfact_dw = 2;
Rfact = 2;  Rfact_dw = 1;

Tc = [16 19]; dTc = 0.25;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nx = diff(mydomain(1:2))+1;
ny = diff(mydomain(3:4))+1;
nz = diff(mydomain(5:6))+1;
recl = nx*ny*nz*4;

% States:
ii = 0;
fil = 'LRtheta.3yV2adv.bin'; ii=ii+1; fid(ii) = fopen(strcat(patho,fil),'r','ieee-be');
fil = 'LRvol.3yV2adv.bin';   ii=ii+1; fid(ii) = fopen(strcat(patho,fil),'r','ieee-be');

% Fields to integrate along the layer boundaries:
ii = 0;
ii = ii+1; fields(ii).name = 'LRadvTOT.3yV2adv.bin';
ii = ii+1; fields(ii).name = 'LRdiffTOT.3yV2adv.bin';  
ii = ii+1; fields(ii).name = 'LRairsea3D.3yV2adv.bin';
ii = ii+1; fields(ii).name = 'LRallotherTOT.3yV2adv.bin';
ii = ii+1; fields(ii).name = 'LRtendARTIF.3yV2adv.bin';
ii = ii+1; fields(ii).name = 'LRtendNATIVE.3yV2adv.bin';
if cpt_bdg, for ifield = 1 : size(fields,2)
	fid_f(ifield) = fopen(strcat(patho,fields(ifield).name),'r','ieee-be');	
end,end 


if cpt_bdg3d
	switch method
		case 0, BDG3D = zeros(size(fields,2),nz,ny,nx); 
				Vvol3d = zeros(nz,ny,nx);
		case 1, BDG3D = zeros(size(fields,2),nz*Rfact,ny*Rfact,nx*Rfact);
				Vvol3d = zeros(nz*Rfact,ny*Rfact,nx*Rfact);
		case 2, BDG3D = zeros(size(fields,2),nz*Rfact./Rfact_dw,ny*Rfact./Rfact_dw,nx*Rfact./Rfact_dw);
				Vvol3d = zeros(nz*Rfact./Rfact_dw,ny*Rfact./Rfact_dw,nx*Rfact./Rfact_dw);
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iti = datenum(2003,11,1,0,0,0);
ite = iti + 1099 - 1;
t   = iti:ite;

it0 = 61;
method
figure; hold on; 
tic
for it = 1 : 60
	disp(num2str(it))
	
	% Load ocean state:
	fseek(fid(1),(it+it0-2)*recl,'bof'); c = fread(fid(1),[nx*ny nz],'float32'); c = reshape(c,[nx ny nz]); c = permute(c,[3 2 1]); c(c==-9999) = NaN;
	T = c; clear c
	fseek(fid(2),(it+it0-2)*recl,'bof'); c = fread(fid(2),[nx*ny nz],'float32'); c = reshape(c,[nx ny nz]); c = permute(c,[3 2 1]); c(c==-9999) = NaN;
	dV = c; clear c

	% Compute budget:
	switch method
		case 0
			mask = zeros(nz,ny,nx); mask(T>=Tc(1) & T <=Tc(2)) = 1;
			Vvol(it) = nansum(nansum(nansum(dV.*mask)))/86400/365/1e6;
			if cpt_bdg3d
				Vvol3d = Vvol3d + dV.*mask/86400/365/1e6;
			end
			
			if cpt_bdg			
				mask = zeros(nz,ny,nx); 
				mask(T>=Tc(2)-dTc/2 & T <=Tc(2)+dTc/2) =  1;
				mask(T>=Tc(1)-dTc/2 & T <=Tc(1)+dTc/2) = -1;
				for ifield = 1 : size(fields,2)				
					fseek(fid_f(ifield),(it+it0-2)*recl,'bof'); c = fread(fid_f(ifield),[nx*ny nz],'float32'); c = reshape(c,[nx ny nz]); c = permute(c,[3 2 1]); c(c==-9999) = NaN;				
					BDG(ifield,it) = nansum(nansum(nansum(c.*mask)))/dTc/365/1e6;
					if cpt_bdg3d
						BDG3D(ifield,:,:,:) = squeeze(BDG3D(ifield,:,:,:)) + c.*mask/dTc/365/1e6;
					end
				end %for ifield
			end %if cpt_bdg

		case 1
			Thr    = dinterp3bin(T,Rfact);
			dVhr   = dinterp3bin(dV,Rfact);
			maskhr = zeros(nz*Rfact,ny*Rfact,nx*Rfact); maskhr(Thr>=Tc(1) & Thr <=Tc(2)) = 1;
			Vvol(it) = nansum(nansum(nansum(dVhr.*maskhr)))/86400/365/1e6/Rfact^3;
			if cpt_bdg3d
				Vvol3d = Vvol3d + dVhr.*maskhr/86400/365/1e6;
			end
			
			if cpt_bdg						
			maskhr = zeros(nz*Rfact,ny*Rfact,nx*Rfact);
			maskhr(Thr>=Tc(2)-dTc/2 & Thr <=Tc(2)+dTc/2) =  1;
			maskhr(Thr>=Tc(1)-dTc/2 & Thr <=Tc(1)+dTc/2) = -1;
			for ifield = 1 : size(fields,2)				
				fseek(fid_f(ifield),(it+it0-2)*recl,'bof'); c = fread(fid_f(ifield),[nx*ny nz],'float32'); c = reshape(c,[nx ny nz]); c = permute(c,[3 2 1]); c(c==-9999) = NaN;
				chr   = dinterp3bin(c,Rfact);				
				BDG(ifield,it) = nansum(nansum(nansum(chr.*maskhr)))/dTc/365/1e6/Rfact^3;
				if cpt_bdg3d
					BDG3D(ifield,:,:,:) = squeeze(BDG3D(ifield,:,:,:)) + chr.*maskhr/dTc/365/1e6/Rfact^3;
				end				
			end %for ifield
			end %if cpt_bdg

		case 2
			Thr    = dinterp3bin(T,Rfact);
			maskhr = zeros(nz*Rfact,ny*Rfact,nx*Rfact); maskhr(Thr>=Tc(1) & Thr <=Tc(2)) = 1;
			maskmr = dlowerres(Rfact_dw,maskhr,1)/Rfact_dw^3; clear maskhr
			dVmr   = dinterp3bin(dV,Rfact/Rfact_dw);
			Vvol(it) = nansum(nansum(nansum(dVmr.*maskmr)))/86400/365/1e6/(Rfact/Rfact_dw)^3;
			
			if cpt_bdg			
			maskhr = zeros(nz*Rfact,ny*Rfact,nx*Rfact);
			maskhr(Thr>=Tc(2)-dTc/2 & Thr <=Tc(2)+dTc/2) =  1;
			maskhr(Thr>=Tc(1)-dTc/2 & Thr <=Tc(1)+dTc/2) = -1;
			maskmr = dlowerres(Rfact_dw,maskhr,1)/Rfact_dw^3; clear maskhr
			for ifield = 1 : size(fields,2)				
				fseek(fid_f(ifield),(it+it0-2)*recl,'bof'); c = fread(fid_f(ifield),[nx*ny nz],'float32'); c = reshape(c,[nx ny nz]); c = permute(c,[3 2 1]); c(c==-9999) = NaN;
				cmr   = dinterp3bin(c,Rfact/Rfact_dw);				
				BDG(ifield,it) = nansum(nansum(nansum(cmr.*maskmr)))/dTc/365/1e6/(Rfact/Rfact_dw)^3;
				if cpt_bdg3d
					BDG3D(ifield,:,:,:) = squeeze(BDG3D(ifield,:,:,:)) + cmr.*maskmr/dTc/365/1e6/(Rfact/Rfact_dw)^3;
				end
			end %for ifield
			end %if cpt_bdg
			

	end %switch method
	if cpt_bdg
		plot(1:it,Vvol-Vvol(1),1:it,-cumsum(BDG,2)');
		le(1) = {'Volume census'}; le(2:size(fields,2)+1) = squeeze(struct2cell(fields));
		legend(le',2);
	else	
		plot((Vvol-Vvol(1)),'linewidth',2,'color','r');
	end
	drawnow;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc

fclose('all');





