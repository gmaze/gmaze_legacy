% csvreadargo H1LINE
%
% [] = csvreadargo()
% 
% HELPTEXT
%
% Created: 2009-11-17.
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

function varargout = csvreadargo(varargin)

file = varargin{1};
%file = 'CO05010708.nc';
fid = fopen(file,'r');

%% Read parameters and init output:
tline = fgetl(fid);
[field_list unit_list] = get_fields(fid);
[PLATFORMS var_list] = list_platforms(fid);
DATA       = init_data(PLATFORMS,field_list);

%% Load all datas:
% ii = 0;
% fseek(fid,0,'bof'); tline = fgetl(fid); % Skip the 1st line with params list
% while 1
% 	tline = fgetl(fid);
% 	if ~ischar(tline),break,end;
% 	ii = ii + 1;
% 	var_list(ii,:) = strread(tline,'%s','delimiter',',');
% end
fclose(fid);

%% Update output:
DATA = fill_data(DATA,var_list,field_list,PLATFORMS);


varargout(1) = {DATA};
return 

%fill_data(DATA,var_list);


%% Output
switch nargout
	case 2
		varargout(1) = {field_list};
		varargout(2) = {var_list};
end


end %functioncsvreadargo


function DATA = fill_data(DATA,var_list,field_list,PLATFORMS);

	for ip = 1 : length(PLATFORMS)
		ii = find(ismember(var_list(:,1),PLATFORMS{ip}));
		for iv = 1 : length(field_list)
			C = var_list(ii,iv);		 	
			switch field_list{iv}
				case {'DATE'} % Move from YYYY/MM/DD HH:MI:SS to datenum
					C = cell2mat(C);
					C = datenum(C,'yyyy/mm/dd HH:MM:SS');
				case {'LATITUDE','LONGITUDE','PRES','TEMP','PSAL','DOXY',...
					'PRES_ADJUSTED','TEMP_ADJUSTED','PSAL_ADJUSTED','DOXY_ADJUSTED',...
					'STATION_NUMBER'}
					for ii=1:length(C)
						if ~isempty(C{ii})
							c(ii) = str2num(C{ii});
						else
							c(ii) = NaN;
						end
					end
					C = c;
				otherwise
%					C = NaN;
			end %switch
			DATA = setfield(DATA,sprintf('platform_%s',PLATFORMS{ip}),field_list{iv},C);
		end
	end%for ip

end%function

function data = init_data(platforms,field_list);
	
	for iv = 1 : length(field_list)
		field = field_list{iv};
		if strfind(field,'(') 
			unit  = field(strfind(field,'(')+1:end-1);
			field = field(1:strfind(field,'(')-1);
			field = strrep(field,' ','');
		end
		eval(sprintf('d0.%s = '''';',field));
	end%for iv
	for ip = 1 : length(platforms)
		eval(sprintf('data.platform_%s = d0;',platforms{ip}));		
	end%for ip
	
	
end%function

function [PLATFORMS var_list] = list_platforms(fid);	
	fseek(fid,0,'bof');	
	tline = fgetl(fid); % Skip the 1st line
	ii = 0;
	while 1
		tline = fgetl(fid);
		if ~ischar(tline),break,end;
		ii = ii + 1;
		var_list(ii,:) = strread(tline,'%s','delimiter',',');
%		if ii == 1e4, break;end
	end
	PLATFORMS = unique(var_list(:,1));
end%function

function [field_list unit_list] = get_fields(fid);
	f0 = ftell(fid);
	fseek(fid,0,'bof');	
		ii = 0;
		tline = fgetl(fid);
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
	fseek(fid,f0,'bof');
end%function










