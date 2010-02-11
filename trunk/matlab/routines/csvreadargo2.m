% csvreadargo2 H1LINE
%
% [] = csvreadargo2()
% 
% HELPTEXT
%
% Created: 2009-11-18.
% Copyright (c) 2009, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specific prior 
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

function varargout = csvreadargo2(varargin)

file = varargin{1};
%file = 'CO05010708.nc';
fid = fopen(file,'r');

%%%%%%%%%%%%%%%%%%%% Read parameters and init output:
tline = fgetl(fid);
ii = 0;
flist = strread(tline,'%s','delimiter',',');
for iv = 1 : length(flist)-1
	field = flist{iv};
	ii = ii + 1;
	if strfind(field,'(') 
		unit  = field(strfind(field,'(')+1:end-1);
		field = field(1:strfind(field,'(')-1);
		field = strrep(field,' ','');
		field_list(ii) = {field};
		unit_list(ii)  = {unit};
	else	
		field_list(ii) = {strrep(field,' ','');};
		unit_list(ii)  = {''};
	end
end%for iv
%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%% Init fields:
N = nlines(file);
for iv = 1 : length(field_list)
	eval(sprintf('%s = zeros(1,%i).*NaN;',field_list{iv},N));
end


%%%%%%%%%%%%%%%%%%%% Read fields from file:
h = waitbar(0,'Reading file ...','Name',mfilename);
ii = 0;
while 1
	tline = fgetl(fid);
	if ~ischar(tline),break,end
	vlist = strread(tline,'%s','delimiter',',');
	if length(vlist) == length(field_list)
		ii = ii + 1;
		waitbar(ii/N,h,sprintf('Reading file ...\n%i/%i',ii,N));
		for iv = 1 : length(field_list)
			C = vlist{iv};
			notacell = 1;
			switch field_list{iv}
				case {'DATE'} % Move from YYYY/MM/DD HH:MI:SS to datenum
					C = datenum(C,'yyyy/mm/dd HH:MM:SS');
				case {'LATITUDE','LONGITUDE','PRES','TEMP','PSAL','DOXY',...
					'PRES_ADJUSTED','TEMP_ADJUSTED','PSAL_ADJUSTED','DOXY_ADJUSTED',...
					'PLATFORM','ARGOS_ID','TEMP_DOXY','TEMP_DOXY_ADJUSTED','BATHY'}
					if isempty(C)
						C = NaN;
					else
						C = str2num(C);
					end
				case {'PLATFORM','PREDEPLOYMENT_CALIB_COEFFICIENT','PREDEPLOYMENT_CALIB_COMMENT',...
						'PREDEPLOYMENT_CALIB_EQUATION','PARAMETER','ARGOS_ID','QC','PARAMETER','BATHY_QC'}	
					if ~isa(field_list{iv},'cell')
						eval(sprintf('%s = cell(1,%i);',field_list{iv},N));
					end
					if isempty(C)
						C = NaN;
					end
					eval(sprintf('%s(ii) = {C};',field_list{iv}));
					notacell = 0;
				otherwise
					C = NaN;
			end %switch						
			if notacell
				try
					eval(sprintf('%s(ii) = C;',field_list{iv}));
				catch
					disp(sprintf('Error with %s at line %i',field_list{iv},ii));
					whos C
					whos(field_list{iv})
					disp([field_list ; vlist']')
					rethrow(lasterror)
				end
			end
		end%for iv
	end%if
%	if ii == 4e3,break;end
end
close(h);
N = min([N ii]);

% Record in mat format:
fil = strcat(file,'.mat');
vari = ['''' field_list{1} ''''];
for iv = 2 : length(field_list)
	vari = sprintf('%s,''%s''',vari,field_list{iv});
end
vari = sprintf('%s,''field_list'',''unit_list''',vari);
eval(sprintf('save(''%s'',%s);',fil,vari));

%%%%%%%%%%%%%%%%%%%% Sort by platforms ids:
if strfind(file,'/')
	pat = file(1:max(strfind(file,'/')))
else
	pat = './';
end
for iv = 1 : length(field_list)
	eval(sprintf('%s_ALL = %s;',field_list{iv},field_list{iv}));
end
vari = ['''' field_list{1} ''''];
for iv = 2 : length(field_list)
	vari = sprintf('%s,''%s''',vari,field_list{iv});
end

UNIQUE_PLATFORMS = unique(PLATFORM_ALL(1:N));
for iplat = 1 : length(UNIQUE_PLATFORMS)
	matfile = sprintf('%splatform_%i.mat',pat,UNIQUE_PLATFORMS(iplat));	
	ii = find(ismember(PLATFORM_ALL(1:N),UNIQUE_PLATFORMS(iplat))); % All belong to 1 platforms	
	for iv = 1 : length(field_list)
		eval(sprintf('%s = %s_ALL(ii);',field_list{iv},field_list{iv}));
	end
	eval(sprintf('save(''%s'',%s);',matfile,vari));
end%for iplat

fclose(fid);
end %functioncsvreadargo2




















