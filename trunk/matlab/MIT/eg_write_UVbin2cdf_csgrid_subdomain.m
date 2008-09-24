% Script to extract a subdomain from a CS510 simulation
% and write in netCDF format on a regular lat/lon grid (1/4)
% SPECIAL U V FIELDS !!
%
clear
global sla
pv_checkpath


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Global setup:
% Restrict global domain to:
subdomain = 3; % North Atlantic

% Path to find input binary Cube sphere files:
pathi = './bin_cube49';

% Path where the netcdf outputs will be stored:
patho = './ecco2_cube49_netcdf';
patho = strcat(patho,sla,'monthly');
%patho = strcat(patho,sla,'six_hourly');

% Time step (for date conversion):
dt = 1200;

% Variables to analyse (index into otab):
otab = cs510grid_outputs_table; % from the 1/8 latlon definition
wvar = [];
dimen = 3;
switch dimen
  case 3 % 3D fields:
    wvar = [wvar 39]; % UVEL
    wvar = [wvar 47]; % VVEL
  case 2 % 2D fields:
end %switch number of dimensions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pre-process
% Get the grid:
path_grid = './grid';
XC = readrec_cs510(sprintf('%s.data',strcat(path_grid,sla,'XC')),1,'float32');
YC = readrec_cs510(sprintf('%s.data',strcat(path_grid,sla,'YC')),1,'float32');
XG = readrec_cs510(sprintf('%s.data',strcat(path_grid,sla,'XG')),1,'float32');
YG = readrec_cs510(sprintf('%s.data',strcat(path_grid,sla,'YG')),1,'float32');
dxG = readrec_cs510(sprintf('%s.data',strcat(path_grid,sla,'DXG')),1,'float32');
dyG = readrec_cs510(sprintf('%s.data',strcat(path_grid,sla,'DYG')),1,'float32');
RAC = readrec_cs510(sprintf('%s.data',strcat(path_grid,sla,'RAC')),1,'float32');
GRID_125;
ZC = - [0 cumsum(thk125(1:length(thk125)-1))];
clear dpt125 lat125 lon125 thk125

% How to move to a lat/lon grid:
% CS510 is about 22km average resolution, ie: 1/4 degree
XI =   -180 : 1/4 : 180; 
YI = -90 : 1/4 : 90;
ZI = ZC;
if ~exist('CS510_to_LATLON025.mat','file')
   del = cube2latlon_preprocess(XC,YC,XI,YI);
   save('CS510_to_LATLON025.mat','XI','YI','XC','YC','del','-v6');
else
   load('CS510_to_LATLON025.mat')
end

% Set subrange - Longitude given as degrees east 
% (exact values come from the 1/8 lat-lon grid)
switch subdomain
  case 3
   sub_name = 'north_atlantic';
   lonmin = 276.0625;
   lonmax = 359.9375;
   latmin = 12.0975;
   latmax = 53.2011;
   depmin = 1;    % !!! indices
   depmax = 29;   % !!! indices
   if dimen == 3, depmax = 29;
   else, depmax = 1;end
   LIMITS = [lonmin lonmax latmin latmax depmin depmax]
   if 0
     m_proj('mercator','long',[270 365],'lat',[0 60]);
     clf;hold on;m_coast;m_grid;
     m_line(LIMITS([1 2 2 1 1]),LIMITS([3 3 4 4 3]),'color','k','linewidth',2);
     title(sub_name);
   end %if 1/0
end

% Get subdomain horizontal axis:
xi = XI(max(find(XI<=LIMITS(1))):max(find(XI<=LIMITS(2))));
yi = YI(max(find(YI<=LIMITS(3))):max(find(YI<=LIMITS(4))));
zi = ZI(LIMITS(5):LIMITS(6));

 filU = otab{39,1}; ifield = 39;
 filV = otab{47,1};
 
%                                                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Get info over the time loop
 % Get the file list:
 fildU = filU; % Insert condition here for special files:
 lU = dir(strcat(pathi,sla,fildU));
 fildV = filV; % Insert condition here for special files:
 lV = dir(strcat(pathi,sla,fildV));
 
 % Get the U files list:
 it = 0;
 clear ll
 for il = 1 : size(lU,1)
   if ~lU(il).isdir & ...
	 findstr(lU(il).name,strcat(filU,'.')) % is'it the file type we want ?
     it = it + 1;
     ll(it).name = lU(il).name;
   end %if
 end %for il
 % Create the timetable of U:
 for il = 1 : size(ll,2)
   filin = ll(il).name;
   % Now extract the stepnum from : %s.%10.10d.data
   ic = findstr(filin,filU)+length(filU)+1; i = 1; clear stepnum
   while filin(ic) ~= '.'
      stepnum(i) = filin(ic); i = i + 1; ic = ic + 1;
   end
   ID = str2num(stepnum);
   TIME(il,:) = datestr(datenum(1992,1,1)+ID*dt/60/60/24,'yyyymmddHHMM');
 end
 nt = size(TIME,1);
 
 % Then we check if we have V when we have U:
 for it = 1 : nt
   snapshot = TIME(it,:);
   filUs = ll(it).name;
   filVs = strcat(filV,filUs(findstr(filUs,filU)+length(filU):end));
   if ~exist(strcat(pathi,sla,fildV,sla,filVs),'file')
     TIME(it,:) = NaN;
   end
 end
 itt = 0;
 for it = 1 : nt
   if find(isnan(TIME(it,:))==0)
     itt = itt + 1;
     TI(itt,:) = TIME(it,:);
   end
 end
 TIME = TI; clear TI
 nt = size(TIME,1);
 
 
%                                                 %%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Loop over time
 for it = 1 : nt
   snapshot = TIME(it,:);
   ID = 60*60*24/dt*( datenum(snapshot,'yyyymmddHHMM') - datenum(1992,1,1) );
   filin = ll(it).name;
   disp('')
   disp(strcat('Processing: ',num2str(ID),'//',snapshot))
   dirout = strcat(patho,sla,TIME(it,:),sla);
   filUout = sprintf('%s.%s.nc',filU,sub_name);
   filVout = sprintf('%s.%s.nc',filV,sub_name);
   
   if ~exist(strcat(dirout,sla,filUout),'file') % File already exists ?
   
%%%% READ FILES U AND V
   switch otab{ifield,6}
    case 4, flt = 'float32';
    case 8, flt = 'float64';
   end
   t0 = clock;
   for iC = 1 : 2 
   if iC == 1, fild = fildU; end
   if iC == 2, fild = fildV; filin = strcat(filV,filin(findstr(filin,filU)+length(filU):end)); end
   if findstr(filin,'.gz') % Gunzip file, special care !     
      disp('|----> Find a file with gz extension, work on uncompressed file ...')
      
      % 1: copy the filename with it path into gunzip_1_file.txt
      fid1 = fopen('gunzip_1_file.txt','w');
      fprintf(fid1,'%s',strcat(pathi,sla,fild,sla,filin));fclose(fid1);

      % 2: uncompress the file into a temporary folder:
      disp('|------> uncompressing the file ...')
      ! ./gunzip_1_file.bat
      disp(strcat('|--------: ',num2str(etime(t0,clock))))
      
      % 3: Read the uncompress file:
      disp('|--> reading it ...')
      C = readrec_cs510(strcat('gunzip_1_file',sla,'tempo.data'),LIMITS(6),flt);
      disp(strcat('|----: ',num2str(etime(t0,clock))))
      
      % 4: Suppress it
      ! \rm ./gunzip_1_file/tempo.data
      
   else % Simply read the file:
      disp('|--> reading it ...')
      C = readrec_cs510(strcat(pathi,sla,fild,sla,filin),LIMITS(6),flt);
      disp(strcat('|----: ',num2str(etime(t0,clock))))
   end
   if iC == 1, CU = C; end
   if iC == 2, CV = C; end
   end %for iC
   clear C   
   
%%%% RESTRICT TO SUBDOMAIN
   disp('|--> get subdomain ...')
   % Restrict vertical to subdomain:
   if LIMITS(5) ~= 1
      disp('|----> vertical ...');
      CU = CU(:,:,LIMITS(5):end);
      CV = CV(:,:,LIMITS(5):end);
   end
   % Clean the field:
   CU(find(CU==0)) = NaN; 
   CV(find(CV==0)) = NaN; 
   % Move the field into lat/lon grid:
   disp('|----> Move to lat/lon grid ...');
   [CU CV] = uvcube2latlon_fast3(del,CU,CV,XG,YG,RAC,dxG,dyG);
   
   % And then restrict horizontal to subdomain: 
   disp('|----> horizontal ...');  
   CU = CU(max(find(XI<=LIMITS(1))):max(find(XI<=LIMITS(2))),...
	 max(find(YI<=LIMITS(3))):max(find(YI<=LIMITS(4))),:);
   CV = CV(max(find(XI<=LIMITS(1))):max(find(XI<=LIMITS(2))),...
	 max(find(YI<=LIMITS(3))):max(find(YI<=LIMITS(4))),:);
   
   
%%%% RECORD
   disp('|--> record netcdf file ...')
   
   if 1 % Realy want to record ?
     
   if ~exist(dirout,'dir')
       mkdir(dirout);
   end
   
   for iC = 1 : 2
     if iC==1, ifield=39; C = CU; fil = filU; filout = filUout; end
     if iC==2, ifield=47; C = CV; fil = filV; filout = filVout; end
     fid1 = fopen('inprogress.txt','w');
     fprintf(fid1,'%s',strcat(dirout,sla,filout));fclose(fid1);
   
     nc = netcdf('inprogress.nc','clobber');

     nc('X') = length(xi);
     nc('Y') = length(yi);
     nc('Z') = length(zi);

     nc{'X'}='X';
     nc{'Y'}='Y';
     nc{'Z'}='Z';

     nc{'X'}.uniquename='X';
     nc{'X'}.long_name='longitude';
     nc{'X'}.gridtype=ncint(0);
     nc{'X'}.units='degrees_east';
     nc{'X'}(:) = xi;

     nc{'Y'}.uniquename='Y';
     nc{'Y'}.long_name='latitude';
     nc{'Y'}.gridtype=ncint(0);
     nc{'Y'}.units='degrees_north';
     nc{'Y'}(:) = yi;

     nc{'Z'}.uniquename='Z';
     nc{'Z'}.long_name='depth';
     nc{'Z'}.gridtype=ncint(0);
     nc{'Z'}.units='m';
     nc{'Z'}(:) = zi;

     ncid = fil;
     nc{ncid}={'Z' 'Y' 'X'};
     nc{ncid}.missing_value = ncdouble(NaN);
     nc{ncid}.FillValue_ = ncdouble(0.0);
     nc{ncid}(:,:,:) = permute(C,[3 2 1]);
     nc{ncid}.units = otab{ifield,5};

     close(nc);
     ! ./inprogress.bat
     
   end %if 1/0 want to record ?
   disp(strcat('|--: ',num2str(etime(t0,clock))))
   
   else
     disp(strcat('|--> Skip file (already done):',dirout,sla,filout))
   end %if %file exist
 
   
 end %for iC
 
 end %for it
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END Loop over time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
