% [] = extract_subdomain(LIST)
%
%   This function extracts a 3D subdomain of OCCA 1x1 fields to be used in the
%	thermal volume budget fortran code
%
% LIST may contain:
%
% 1: theta and volume elements
% 2: Tend. Native
% 3: Tend. Artif
% 4: Air-sea flux
% 5: All others (ssh, gtabt, ghatt)
% 6: total advection
% 7: total diffusion
%
%
% Created by Guillaume Maze on 2008-10-10.
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

% THETA   | 50 |SM|degC            |Potential Temperature
% TENDT   | 50 |SM|degC/d          |Tendency of Potential Temperature
% ZADVT   | 51 |WM|degC.m^3/s      |Vertical   Advective Flux of Pot.Temp
% XADVT   | 50 |UU|degC.m^3/s      |Zonal      Advective Flux of Pot.Temp
% YADVT   | 50 |VV|degC.m^3/s      |Meridional Advective Flux of Pot.Temp
% XDIFT   | 51 |WM|degC.m^3/s      |Vertical   Diffusive Flux of Pot.Temp (Explicit part)
% ZDIFTI  | 51 |WM|degC.m^3/s      |Vertical   Diffusive Flux of Pot.Temp (Implicit part)
% XDIFT   | 50 |UU|degC.m^3/s      |Zonal      Diffusive Flux of Pot.Temp
% YDIFT   | 50 |VV|degC.m^3/s      |Meridional Diffusive Flux of Pot.Temp
% GTABT   | 50 |SM|degC/s          | Tendency of Potential Temp. added by the Adams Bashforth Scheme
% GTFT    | 50 |SM|degC/s          | Tendency of Potential Temp. due to air-sea heat fluxes
% GHATT   | 51 |WM|degC.m^3/s      | Non-local transport term of KPP as a temperature flux
% DSSHT   | 51 |WM|degC.m^3/s      | Vertical flux of Pot.temp due to Sea Level Change

function varargout = extract_subdomain(varargin)

LIST = varargin{1};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERAL PARAMETERS:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  TUNING PART

% Where do we find input fields:
%pathi = abspath('~/data/OCCA/daily_all_r0/'); % release 0
pathi = abspath('~/data/OCCA/daily_all_r1/');  % New advection scheme (less diffusive)
%pathi = '/net/altix3700/raid4/gforget/occa_r1_adv2/daily_v2_all/';

% Sub-domain boundaries:
%subdomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
%subdomain = [122 180 90 130 1 25]; % Western Pacific
%subdomain = [122 200 90 130 1 25]; % Western Pacific extended eastward
%subdomain = [110 260 90 147 1 25]; % Whole North Pacific
%subdomain = [150 180 100 120 1 25]; % A box in the middle of the NP ocean
subdomain = [111   110+75 90 147 1 25]; % Eastern Pacific
%subdomain = [110+75 110+2*75 90 147 1 25]; % Western Pacific

% Where do we put output fields:
patho = abspath(sprintf('~/data/OCCA/Tlayer_budget/KESS/r1/dom_ix%3.3d.%3.3d_iy%3.3d.%3.3d_iz%2.2d.%2.2d/LRfiles/',subdomain));
if ~exist(patho,'dir')
	mkdir(patho);
end
prefi = 'LR';
suffi = '3yV2adv';

% We sweep the complete time serie of OCCA r0/r1
it1 = 1;    % itdep = datenum(2003,11,1,12,0,0); 
it2 = 1099; % itend = datenum(2006,11,3,12,0,0); 
%it2 = 120;

% Create structure of different sets of fields to extract:
filesetlist = create_filesets(LIST);
nsets = size(filesetlist,2);

% Where to find the grid:
switch wherearewe
	case {'csail_mit'} % Hugo/Tolkien/Eddy/Chassiron
		path_grid = '~/data/OCCA/grid_csail/';
	case {'ocean'} % Ross/Weddell
	    path_grid = '~/data/OCCA/grid_ocean/';
	case {'csail_ao'} % AO
		path_grid = '/net/ross/raid0/gforget/1x1_50levels/GRID/';
	case {'beagle'} % Beagle and its nodes
		path_grid = '~/data/OCCA/grid_beagle/';		
end
path_grid = abspath(path_grid);

disp(pathi)
disp(patho)
% Check routine time ?
ctim = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN THE FILE LOOP
% To allow multi processing we insert a loop on the 
% different set of fields to extract:
for isetfile = 1 : length(filesetlist)
	subset = filesetlist(isetfile);
	REQUIREDfields = list2cell(subset.fields);	% DEVEL
	for iv = 1 : size(REQUIREDfields,1),eval(['global ' REQUIREDfields{iv}]);end % DEVEL
	t00 = clock;
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN THE TIME LOOP
for it = it1 : it2
	disp(['it=' num2str(it) ' : ' subset.outname])
	t0 = clock;
	
	% Load fields (they are in global):
	if ctim,tic;end
	load_fields(path_grid,pathi,subset.fields,it);
%	global THETA, fprintf('%f\n',THETA(1:2,100,130));
%	global XADVT, fprintf('%f\n',XADVT(1:5,100,130));
%	global YADVT, fprintf('%f\n',YADVT(1:5,100,130));
	if ctim,toc;end
	
	% Process fields:
	% (note that the processing depends on the subset)
	if ctim,tic;end
	FIELD_REC = process_fields(path_grid,subset);
	if ctim,toc;end
	
	% Extract subdomain:
	if ctim,tic;end
	FIELD_REC = extract(FIELD_REC,subdomain);
	if ctim,toc;end
	
	% Record the output:
	if ctim,tic;end
	record_output(patho,FIELD_REC,subdomain,it,prefi,suffi);
	if ctim,toc;end

	disp(sprintf('         => %2.2g sec(s)',etime(clock,t0)));
end %for it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END THE TIME LOOP
disp(sprintf('Total time this set => %2.2g sec(s)',etime(clock,t00)));


end %for ifile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END THE FILE LOOP










%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUB FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% % Create structure of different sets of fields to extract:
function varargout = create_filesets(varargin);
	% XDIFT;YDIFT;ZDIFT;ZDIFTI;XADVT;YADVT;ZADVT;TENDT;GTABT;GTFT;GHATT;DSSHT;THETA;QNET;
	
	% Note that the last ";' in the field list is important !
	
	sets = varargin{1};
	ii = 0;
	
	for ij = 1 : length(sets)
		iset = sets(ij);
		switch iset
			case 1
				ii=ii+1;
				output(ii).outname = 'theta';
				output(ii).fields  = 'THETA;';

			case 2
				ii=ii+1;
				output(ii).outname = 'tendNATIVE';
				output(ii).fields  = 'TENDT;';  
	
			case 3
				ii=ii+1;
				output(ii).outname = 'tendARTIF';
				output(ii).fields  = 'TENDTA;'; 

			case 4
				ii=ii+1;
				output(ii).outname = 'airsea3D';
				output(ii).fields  = 'GTFT;';	

			case 5
				ii=ii+1;
				output(ii).outname = 'allotherTOT';
				output(ii).fields  = 'GHATT;DSSHT;GTABT;';

			case 6		
				ii=ii+1;
				output(ii).outname = 'advTOT';
				output(ii).fields  = 'XADVT;YADVT;ZADVT;';

			case 7
				ii=ii+1;
				output(ii).outname = 'diffTOT';
				output(ii).fields  = 'XDIFT;YDIFT;ZDIFT;ZDIFTI;';

		end %switch
	end %for ii
	
	if ~exist('output')
		disp('Can''t find what set of files you want !');
	else
		varargout(1) = {output};
	end
	
	
% end subfunction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% % 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% load_fields(path_grid,path_input,subset.fields,it)

function varargout = load_fields(varargin);
	
path_grid = varargin{1};
pathi     = varargin{2};
tline     = varargin{3};	
it        = varargin{4};

REQUIREDfields = list2cell(tline);

[fids suff_cur iternum] = open_files(pathi,it,tline);
for iv = 1 : size(REQUIREDfields,1)
	eval(['fid_' REQUIREDfields{iv} '=fids(iv);'])
end

NLON = 360;
NLAT = 160;
NDPT = 50;
recl = NLON*NLAT*4;
iX = [1 360]; iY = [1 160]; iZ = [1 50];
nx = diff(iX)+1; ny = diff(iY)+1; nz = diff(iZ)+1;
iXg= [1:360 1]; iYg = [1:160 1]; iZg=[1:50+1];

% We need c,u,v,w masks:
global LSmask3D LSmask3D_u LSmask3D_v LSmask3D_w % Mask are in global to avoir reloading each time step
if isempty(LSmask3D)
	[LSmask3D LSmask3D_u LSmask3D_v LSmask3D_w] = load_mask(path_grid);
end

% We put loaded fields in global
for iv = 1 : size(REQUIREDfields,1)
	eval(['global ' REQUIREDfields{iv}]);
end

% Load fields:
for ifield = 1 : size(REQUIREDfields,1)
	switch REQUIREDfields{ifield}
	
case 'THETA'
  c = fread(fid_THETA,[NLON*NLAT NDPT],'float32');
  c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]);
  THETA = c(iZ(1):iZ(2),iY(1):iY(2),iX(1):iX(2)).*LSmask3D; % degC
  clear c
  
case 'TENDT' 
  c = fread(fid_TENDT,[NLON*NLAT NDPT],'float32');
  c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]);
  TENDT = c(iZ(1):iZ(2),iY(1):iY(2),iX(1):iX(2)).*LSmask3D; % ^oC/days
  clear c

case 'GTABT' 
  c = fread(fid_GTABT,[NLON*NLAT NDPT],'float32');
  c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]);
  GTABT = c(iZ(1):iZ(2),iY(1):iY(2),iX(1):iX(2)).*LSmask3D; % ^oC/s
  clear c

case 'GTFT' 
  c = fread(fid_GTFT,[NLON*NLAT NDPT],'float32');
  c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]);
  GTFT = c(iZ(1):iZ(2),iY(1):iY(2),iX(1):iX(2)).*LSmask3D; % ^oC/s
  clear c

case 'XADVT'
  c = fread(fid_XADVT,[NLON*NLAT NDPT],'float32');
  c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]);
  XADVT = c(iZ(1):iZ(2),iY(1):iY(2),iXg).*LSmask3D_u; % ^oC.m3/s
%  fprintf('%f\n',XADVT(1:5,100,130));
  clear c
  

case 'XDIFT'
  c = fread(fid_XDIFT,[NLON*NLAT NDPT],'float32');
  c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]);
  XDIFT = c(iZ(1):iZ(2),iY(1):iY(2),iXg).*LSmask3D_u; % ^oC.m3/s
  clear c
  

%%%%%%% C-grid, V loc:
case 'YADVT'
	c = fread(fid_YADVT,[NLON*NLAT NDPT],'float32');
	c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]);
	YADVT = c(iZ(1):iZ(2),iYg,iX(1):iX(2)).*LSmask3D_v; % ^oC.m3/s
%	fprintf('%f\n',YADVT(1:5,100,130));
	clear c


case 'YDIFT' % V grid
  c = fread(fid_YDIFT,[NLON*NLAT NDPT],'float32');
  c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]);
  YDIFT = c(iZ(1):iZ(2),iYg,iX(1):iX(2)).*LSmask3D_v; % ^oC.m3/s
  clear c
 


%%%%%%% C-grid, W loc:
case 'ZADVT' 
  c = fread(fid_ZADVT,[NLON*NLAT NDPT],'float32');
  c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]); % Only 50 levels
  c = cat(1,c,zeros(1,NLAT,NLON)); % add the 51st one !
  ZADVT = c(iZg,iY(1):iY(2),iX(1):iX(2)).*LSmask3D_w; % ^oC.m3/s
%  fprintf('%f\n',ZADVT(1:5,100,130));
  clear c
  
  
case 'ZDIFT' 
  c = fread(fid_ZDIFT,[NLON*NLAT NDPT],'float32');
  c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]); % Only 50 levels
  c = cat(1,c,zeros(1,NLAT,NLON)); % add the 51st one !
  ZDIFT = c(iZg,iY(1):iY(2),iX(1):iX(2)).*LSmask3D_w; % ^oC.m3/s
  clear c
  
  
case 'ZDIFTI' 
  c = fread(fid_ZDIFTI,[NLON*NLAT NDPT],'float32');
  c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]); % Only 50 levels
  c = cat(1,c,zeros(1,NLAT,NLON)); % add the 51st one !
  ZDIFTI = c(iZg,iY(1):iY(2),iX(1):iX(2)).*LSmask3D_w; % ^oC.m3/s
  clear c
  
  

case 'GHATT' 
  c = fread(fid_GHATT,[NLON*NLAT NDPT],'float32');
  c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]); % Only 50 levels
  c = cat(1,c,zeros(1,NLAT,NLON)); % add the 51st one !
  GHATT = c(iZg,iY(1):iY(2),iX(1):iX(2)).*LSmask3D_w; % ?
  clear c
  
  
case 'DSSHT' 
  c = fread(fid_DSSHT,[NLON*NLAT NDPT],'float32');
  c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]); % Only 50 levels
  c = cat(1,c,zeros(1,NLAT,NLON)); % add the 51st one !
  DSSHT = c(iZg,iY(1):iY(2),iX(1):iX(2)).*LSmask3D_w; % ?
  clear c
  
  
% special case: load the artificial term
case 'TENDTA'
	c = fread(fid_TENDTA,[NLON*NLAT NDPT],'float32');
	c = reshape(c,NLON,NLAT,NDPT); c = permute(c,[3 2 1]);
	eval(['load ' pathi 'CoeffForDiff.mat;']);
	eval(['coeff_TENDTartif=CoeffForDiff' suff_cur(1:end-1) '(iternum+1);']);
	%fprintf('%f / %f\n',coeff_TENDTartif,c(1:5,100,130));
	TENDTA = coeff_TENDTartif*c(iZ(1):iZ(2),iY(1):iY(2),iX(1):iX(2)).*LSmask3D; % ^oC/days
	clear c
	

	end %switch
end %for ifield





% Close all the files:
tmp1=who('fid_*'); for tmp2=1:length(tmp1); eval(['fclose(' char(tmp1(tmp2)) ');']); end;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = load_mask(varargin);

disp('Loading masks...')
path_grid = varargin{1};

iX = [1 360]; iY = [1 160]; iZ = [1 50];
nx = diff(iX)+1; ny = diff(iY)+1; nz = diff(iZ)+1;
iXg= [1:360 1]; iYg = [1:160 1]; iZg=[1:50+1];


fid    = fopen(strcat(path_grid,'maskCtrlC.data'),'r','ieee-be');
MASKCC = fread(fid,[nx*ny nz],'float32')'; fclose(fid);
MASKCC = reshape(MASKCC,[nz nx ny]); MASKCC = permute(MASKCC,[1 3 2]);

fid    = fopen(strcat(path_grid,'maskCtrlS.data'),'r','ieee-be');
MASKCS = fread(fid,[nx*ny nz],'float32')'; fclose(fid);
MASKCS = reshape(MASKCS,[nz nx ny]); MASKCS = permute(MASKCS,[1 3 2]);

fid    = fopen(strcat(path_grid,'maskCtrlW.data'),'r','ieee-be');
MASKCW = fread(fid,[nx*ny nz],'float32')'; fclose(fid);
MASKCW = reshape(MASKCW,[nz nx ny]); MASKCW = permute(MASKCW,[1 3 2]);

LSmask3D   = MASKCC(iZ(1):iZ(2),iY(1):iY(2),iX(1):iX(2));
LSmask3D_u = MASKCW(iZ(1):iZ(2),iY(1):iY(2),iXg);
LSmask3D_v = MASKCS(iZ(1):iZ(2),iYg,iX(1):iX(2));
c = MASKCC; c = cat(1,c,zeros(1,ny,nx));
LSmask3D_w = c(iZg,iY(1):iY(2),iX(1):iX(2));

LSmask3D(LSmask3D==0) = NaN;
LSmask3D_u(LSmask3D_u==0) = NaN;
LSmask3D_v(LSmask3D_v==0) = NaN;
LSmask3D_w(LSmask3D_w==0) = NaN;


varargout(1) = {LSmask3D};
varargout(2) = {LSmask3D_u};
varargout(3) = {LSmask3D_v};
varargout(4) = {LSmask3D_w};

disp('Done')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fid_list = open_files(pathi,it,subset.fields);

function varargout = open_files(varargin)
	
pathname = varargin{1};
iternum  = varargin{2};
tline    = varargin{3};

REQUIREDfields = list2cell(tline);

recl2D = 360*160*4; 
recl3D = recl2D*50;

if iternum >= 61
	suff_cur = '0406daily.'; 
	iternum = iternum-61; 
else; 
	suff_cur = '03novdec.'; 
end

% Init fids:
for ifield = 1 : size(REQUIREDfields,1)
	switch REQUIREDfields{ifield}
	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% THETA:
case 'THETA'
  fil = strcat('DDtheta.',suff_cur,'data');
  fid_THETA = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_THETA,iternum*recl3D,'bof'); 


% TFLUX:
case 'QNET'
  fil = strcat('DFOtflux.',suff_cur,'data');
  fid_TFLUX = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_TFLUX,(iternum)*recl2D,'bof'); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BUDGET TERMS:
% THETA Tency:
%   88 |TOTTTEND| 50 |SM      MR      |degC/s          |Tency of Potential Temperature
case 'TENDT'
  fil = strcat('DTRtendt.',suff_cur,'data');
  fid_TENDT  = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_TENDT,iternum*recl3D,'bof'); 

% THETA tency added by the Adams Bashforth Scheme (degree/s)
case 'GTABT'
  fil = strcat('DTRgtABT.',suff_cur,'data');
  fid_GTABT  = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_GTABT,iternum*recl3D,'bof'); 

% THETA tency added by Air-Sea Forcing (degree/s). 
%		-> DTRgtFT can be 3D due to short wave penetration
case 'GTFT'
  fil = strcat('DTRgtFT.',suff_cur,'data');
  fid_GTFT  = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_GTFT,iternum*recl3D,'bof'); 

		
%%%%%%%%%%%%%%%
% Zonal      Advective Flux of Pot.Temperature
%  91 |ADVx_TH | 50 |UU   092MR      |degC.m^3/s      |Zonal      Advective Flux of Pot.Temperature
case 'XADVT'
  fil = strcat('DTRadvxt.',suff_cur,'data');
  fid_XADVT  = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_XADVT,iternum*recl3D,'bof'); 


% Meridional Advective Flux of Pot.Temperature
%   92 |ADVy_TH | 50 |VV   091MR      |degC.m^3/s      |Meridional Advective Flux of Pot.Temperature
case 'YADVT'
  fil = strcat('DTRadvyt.',suff_cur,'data');
  fid_YADVT  = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_YADVT,iternum*recl3D,'bof');


% Vertical   Advective Flux of Pot.Temperature
%  90 |ADVr_TH | 50 |WM      LR      |degC.m^3/s      |Vertical   Advective Flux of Pot.Temperature
case 'ZADVT'
  fil = strcat('DTRadvrt.',suff_cur,'data');
  fid_ZADVT  = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_ZADVT,iternum*recl3D,'bof');



%%%%%%%%%%%%%%%
% Zonal      Diffusive Flux of Pot.Temperature
%   94 |DFxE_TH | 50 |UU   095MR      |degC.m^3/s      |
case 'XDIFT'
  fil = strcat('DTRdifxt.',suff_cur,'data');
  fid_XDIFT  = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_XDIFT,iternum*recl3D,'bof');


% Meridional Diffusive Flux of Pot.Temperature
%   95 |DFyE_TH | 50 |VV   094MR      |degC.m^3/s      |
case 'YDIFT'
  fil = strcat('DTRdifyt.',suff_cur,'data');
  fid_YDIFT  = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_YDIFT,iternum*recl3D,'bof');


% Vertical Vertical Diffusive Flux of Pot.Temperature (Implicit part)
%   96 |DFrI_TH | 50 |WM      LR      |degC.m^3/s      |
case 'ZDIFTI'
  fil = strcat('DTRdifIt.',suff_cur,'data');
  fid_ZDIFTI  = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_ZDIFTI,iternum*recl3D,'bof');


% Vertical Vertical Diffusive Flux of Pot.Temperature (Explicit part)
%   93 |DFrE_TH | 50 |WM      LR      |degC.m^3/s      |
case 'ZDIFT'
  fil = strcat('DTRdifrt.',suff_cur,'data');
  fid_ZDIFT  = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_ZDIFT,iternum*recl3D,'bof');


% Vertical Flux of Pot.Temperature due to KPP (KPP ghat vertical flux)
case 'GHATT'
  fil = strcat('DTRghatT.',suff_cur,'data');
  fid_GHATT  = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_GHATT,iternum*recl3D,'bof');


% Vertical Flux of Pot.Temperature due to Sea Level change
case 'DSSHT'
  fil = strcat('DTRdsshT.',suff_cur,'data');
  fid_DSSHT  = fopen(strcat(pathname,fil),'r','ieee-be');
  fseek(fid_DSSHT,iternum*recl3D,'bof');


case 'TENDTA'
	% THETA Tency: artificial term, computed as the product of the DIFF and CoeffForDiff
	fil = strcat('DDtheta.',suff_cur(1:end-1),'diff.data');
	fid_TENDTA  = fopen(strcat(pathname,fil),'r','ieee-be');
	fseek(fid_TENDTA,iternum*recl3D,'bof');

	
	end %switch
end %for

%%%%% CHECK IF ALL FID OK :
% Flag to say if it passes the test:
passed_check = 1;
% Check the fields:
for iv = 1 : size(REQUIREDfields,1)
	fie = cell2mat(REQUIREDfields(iv));
	fidval = eval('caller',sprintf('fid_%s',fie));
	if fidval < 0
		disp(sprintf('The binary file of %s is not properly open !',fie));
		passed_check = 0 ;
	else
		fid_out(iv) = fidval;
	end
end

%
if passed_check == 0
  disp('WARNING: You should stop running this script !!!!');
end


switch nargout
	case 1
		varargout(1) = {fid_out};
	case 2
		varargout(1) = {fid_out};
		varargout(2) = {suff_cur};
	case 3
		varargout(1) = {fid_out};
		varargout(2) = {suff_cur};
		varargout(3) = {iternum};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function REQUIREDfields = list2cell(tline);

tl = strtrim(tline);
if strmatch(';',tl(end)), tl = tl(1:end-1);end
tl = [';' tl ';']; pv = strmatch(';',tl');
for ifield = 1 : length(pv)-1
field(ifield).name = tl(pv(ifield)+1:pv(ifield+1)-1);
end
REQUIREDfields = squeeze(struct2cell(field));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  pathname  = abspath(pathname)
%
% Replace any occurence of a "~" into input path
% by the absolute home directory given by shell
% variable $HOME
%
%
function newpath = abspath(varargin)

pathname = varargin{1};

[a hom] = dos('echo $HOME');
clear a

if ~isempty(hom)
        newpath = strrep(pathname,'~',strtrim(hom));
else
        newpath = pathname;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = process_fields(varargin);
	
path_grid = varargin{1};	
subset    = varargin{2};	
thisset   = subset.outname;

global dV, if isempty(dV),	dV = get_thisone(path_grid,1); end

switch thisset
	case 'theta' % THETA
		% Here we have to store theta by itself
		% and the matrix of volume elements
		process_thisfield('THETA',path_grid); % We just load dV here, nothing is done to THETA
		global THETA dV
		FIELD_REC(1).name = 'theta';
		FIELD_REC(1).val  = THETA; clear global THETA
		FIELD_REC(2).name = 'vol';
		FIELD_REC(2).val  = dV; 
		
	case 'tendNATIVE' % TENDANCE NATIVE
		% Here we have to perform the operation:
		% TENDT = TENDT./86400.*dV_3D.*mask;
		process_thisfield('TENDT',path_grid);
		global TENDT
		FIELD_REC(1).name = 'tendNATIVE';
		FIELD_REC(1).val  = TENDT; clear global TENDT

	case 'tendARTIF' % TENDANCE ARTIFICIEL
		% Here we have to perform the operation:
		% TENDTA = TENDTA.*dV_3D.*mask;
		process_thisfield('TENDTA',path_grid);		
		global TENDTA
		FIELD_REC(1).name = 'tendARTIF';
		FIELD_REC(1).val  = TENDTA; clear global TENDTA
		
	case 'airsea3D' % 3D HEAT FLUX TERM
		% We need to transform it into a vertical temp flux
		process_thisfield('GTFT',path_grid);
		global GTFT
		FIELD_REC(1).name = 'airsea3D';
		FIELD_REC(1).val  = GTFT; clear global GTFT
		
	case 'allotherTOT' % BLEND OF TERMS:
		% We need to put together: GHATT, DSSHT and GTABT
		% DSSHT and GHATT are vertical terms, we need their vertical divergence
		% GTABT need to be move to: C2 = GTABT.*dV_3D.*mask;		
		process_thisfield('GHATT');	
		process_thisfield('DSSHT');
		process_thisfield('GTABT');
		global GHATT DSSHT GTABT
		FIELD_REC(1).name = 'allotherTOT';
		FIELD_REC(1).val  = GHATT+DSSHT+GTABT; clear global GHATT DSSHT GTABT		
		
	case 'advTOT' % TOTAL ADVECTIVE TERMS:
		% We need their divergence and sum them	
		process_thisfield('XADVT');
		process_thisfield('YADVT');
		process_thisfield('ZADVT');
		global XADVT YADVT ZADVT
		FIELD_REC(1).name = 'advTOT';
		FIELD_REC(1).val  = XADVT+YADVT+ZADVT; clear global XADVT YADVT ZADVT

	case 'diffTOT' % TOTAL DIFFUSIVE TERMS
		% We need their divergence and sum them
		process_thisfield('XDIFT');
		process_thisfield('YDIFT');
		process_thisfield('ZDIFT');
		process_thisfield('ZDIFTI');
		global XDIFT YDIFT ZDIFT ZDIFTI
		FIELD_REC(1).name = 'diffTOT';
		FIELD_REC(1).val  = XDIFT+YDIFT+ZDIFT+ZDIFTI; clear global XDIFT YDIFT ZDIFT ZDIFTI
		
end %switch
	
if nargout == 1
	varargout(1) = {FIELD_REC};
end

	
	
	
	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = process_thisfield(varargin);

thisfield = varargin{1}; % char
if nargin==2,path_grid = varargin{2};end

iX = [1 360]; iY = [1 160]; iZ = [1 50];
nx = diff(iX)+1; ny = diff(iY)+1; nz = diff(iZ)+1;
iXg= [1:360 1]; iYg = [1:160 1]; iZg=[1:50+1];

% Most of the time, we transform temperature fluxes across grid cell
% into divergence of fluxes

switch thisfield
	case 'THETA'
		% Nothing to do here
		
	case 'TENDT'
		global TENDT dV
		TENDT = TENDT./86400.*dV;
		
	case 'TENDTA'
		global TENDTA dV
		TENDTA = TENDTA./86400.*dV;
		
	case 'GTFT'
		global GTFT dV
		C = -GTFT;
		C(isnan(C)) = 0;
		Nqz(nz+1,:,:) = zeros(1,ny,nx);
		for iz = nz : -1 : 1
			c = cumsum(C(iz:nz,:,:),1);
			Nqz(iz,:,:) = squeeze(c(end,:,:).*dV(iz,:,:)); % degC/s * m3
		end
		GTFT = get_div(Nqz,1);
%		GTFT = ( Nqz(2:nz+1,:,:) - Nqz(1:nz,:,:) );
		
	case 'GHATT'
		global GHATT
		GHATT = get_div(GHATT,1);
		
	case 'DSSHT'
		global DSSHT
		DSSHT = get_div(DSSHT,1);
		
	case 'GTABT'
		global GTABT dV
		GTABT = GTABT.*dV;		
		
	case 'XADVT'
		global XADVT
		XADVT = get_div(XADVT,3);
		
	case 'YADVT'
		global YADVT
		YADVT = get_div(YADVT,2);
		
	case 'ZADVT'
		global ZADVT
		ZADVT = get_div(ZADVT,1);
		
	case 'XDIFT'
		global XDIFT
		XDIFT = get_div(XDIFT,3);
		
	case 'YDIFT'
		global YDIFT
		YDIFT = get_div(YDIFT,2);
		
	case 'ZDIFT'
		global ZDIFT
		ZDIFT = get_div(ZDIFT,1);
				
	case 'ZDIFTI'
		global ZDIFTI
		ZDIFTI = get_div(ZDIFTI,1);				
		
end %switch		
	


	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function varargout = get_div(varargin)
	
	% Note that, this is in fact the -div !
	
	C  = varargin{1};
	ax = varargin{2};
	switch ax
		case 1
			C = C(2:end,:,:) - C(1:end-1,:,:);
		case 2
			C = C(:,1:end-1,:) - C(:,2:end,:);
		case 3
			C = C(:,:,1:end-1) - C(:,:,2:end);
	end
	varargout(1) = {C};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function varargout = get_thisone(varargin);
	
path_grid = varargin{1};
thisone   = varargin{2};

iX = [1 360]; iY = [1 160]; iZ = [1 50];
nx = diff(iX)+1; ny = diff(iY)+1; nz = diff(iZ)+1;

switch thisone
	case 1
		fid = fopen(strcat(path_grid,'DRF.data'),'r','ieee-be');
		DDPTW = fread(fid,[1 nz],'float32')'; fclose(fid);
		fid = fopen(strcat(path_grid,'RAC.data'),'r','ieee-be');
		SURFA_C = fread(fid,[nx ny],'float32')';
		for iz = 1 : nz
		  dV(iz,:,:) = DDPTW(iz).*SURFA_C;
		end
		if nargout == 1,varargout(1) = {dV};end

	case 2
		fid = fopen(strcat(path_grid,'DRF.data'),'r','ieee-be');
		DDPTW = fread(fid,[1 nz],'float32')'; fclose(fid);
		if nargout == 1,varargout(1) = {DDPTW};end

	case 3
		fid = fopen(strcat(path_grid,'RAC.data'),'r','ieee-be');
		SURFA_C = fread(fid,[nx ny],'float32')';
		if nargout == 1,varargout(1) = {SURFA_C};end
	
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function varargout = extract(varargin);
	
fieldin  = varargin{1};
mydomain = varargin{2}; % x,y,z
global LSmask3D LSmask3D_u LSmask3D_v LSmask3D_w domMASK
if isempty(domMASK)
	disp('Domain mask')
	domMASK = LSmask3D(mydomain(5):mydomain(6),mydomain(3):mydomain(4),mydomain(1):mydomain(2)); % 1/NaN
	domMASK = LSmask3D + get_div(LSmask3D_u,3) + get_div(LSmask3D_v,2) + get_div(LSmask3D_w,1);
	domMASK = domMASK(mydomain(5):mydomain(6),mydomain(3):mydomain(4),mydomain(1):mydomain(2)); 
%	load(abspath('~/MITgcm_mycontrib/gmaze_pv/visu/LSmask_KESS_OCCA.mat'));
%	domMASK = mask_KESS(mydomain(5):mydomain(6),mydomain(3):mydomain(4),mydomain(1):mydomain(2));clear mask_KESS
%	domMASK(domMASK==0) = NaN;

	%%%% THIS IS WHERE YOU CAN TUNE THE MASK OF THE SUBDOMAIN

	global domMASK
end

% All fields to record are on the C grid, so we use the same mask
for ifield = 1 : size(fieldin,2)
	c = fieldin(ifield).val(mydomain(5):mydomain(6),mydomain(3):mydomain(4),mydomain(1):mydomain(2));
	c = c.*domMASK;
	c(isnan(c)) = -9999;
	c(:,[1 end],:) = -9999;
	c(:,:,[1 end]) = -9999;
	fieldin(ifield).val = c;
end
	
varargout(1) = {fieldin};	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [] = record_output(patho,FIELD_REC,subdomain,it,'LR','3yV2adv');

function varargout = record_output(varargin);
	
patho = varargin{1};
field = varargin{2}; 
mydom = varargin{3};	
itern = varargin{4};
prefi = varargin{5};
suffi = varargin{6};

nx = diff(mydom(1:2))+1;
ny = diff(mydom(3:4))+1;
nz = diff(mydom(5:6))+1;

recl2D = nx*ny*4; 
recl3D = recl2D*nz;	
	
for ifield = 1 : size(field,2)
	
	filo = sprintf('%s/%s%s.%s.bin',patho,prefi,field(ifield).name,suffi);
%	disp(filo);
	
	if itern == 1
		fid = fopen(filo,'w','ieee-be');
	else
		fid = fopen(filo,'a','ieee-be');
	end
	if fid > 0
		c = field(ifield).val;
		c = permute(c,[3 2 1]); % x,y,z
		c = reshape(c,[nx*ny nz]);
		fseek(fid,(itern-1)*recl3D,'bof');
		fwrite(fid,c,'float32');
		fclose(fid);
	else
		disp('Error with output file in record_output');
	end

	
end
	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOCATION = wherearewe()
%
% Determine on which system of machine we are
% LOCATION could be:
%       csail_mit
%       ocean
%       altix
%       csail_ao
%       beagle
%

function varargout = wherearewe(varargin)


thisnam = getcomputername;
thisnam = lower(thisnam);
 
weare = '';

if strfind(thisnam,'hugo') 
        weare = 'csail_mit';
end
if strfind(thisnam,'tolkien') 
        weare = 'csail_mit';
end
if strfind(thisnam,'eddy') 
        weare = 'csail_mit';
end
if strfind(thisnam,'chassiron')
        weare = 'csail_mit';
end

if strfind(thisnam,'ocean') 
        weare = 'ocean';
end
if strfind(thisnam,'ross') 
        weare = 'ocean';
end
if strfind(thisnam,'weddell')
        weare = 'ocean';
end
        
if strfind(thisnam,'altix')
        weare = 'altix';
end
                
if strfind(thisnam,'ao')                
        weare = 'csail_ao';
end
if thisnam(1)=='a' & length(strfind(thisnam,'-')) == 2
        weare = 'csail_ao';
end
                
if strfind(thisnam,'beagle') 
        weare = 'beagle';
end
if strfind(thisnam,'darwin') 
        weare = 'beagle';
end
if strfind(thisnam,'compute') 
        if strfind(thisnam,'local') 
                weare = 'beagle';
        end
end

if isempty(weare)
        error('Can''t find where we are !');
else
        varargout(1) = {weare};
end	
	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function name = getcomputername()
% GETCOMPUTERNAME returns the name of the computer (hostname)
% name = getComputerName()
%
% WARN: output string is converted to lower case
%
%
% See also SYSTEM, GETENV, ISPC, ISUNIX
%
% m j m a r i n j (AT) y a h o o (DOT) e s
% (c) MJMJ/2007
%

[ret, name] = system('hostname');   

if isempty('name')
   if ispc
      name = getenv('COMPUTERNAME');
   else      
      name = getenv('HOSTNAME');
      if strcmp(name,'hostname')
                name = getenv('HOST');
      end       
   end
end
name = lower(name);