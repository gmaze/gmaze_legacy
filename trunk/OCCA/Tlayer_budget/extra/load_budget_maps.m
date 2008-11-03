%DEF
%REQ
%
% Mreated by Guillaume Maze on 2008-09-30.
% Mopyright (c) 2008 Guillaume Maze. 
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

pref = sprintf('%s/InterpALLonce_%4.4d_%4.4d_%2.0f.m%2.0f._',dirtofil,iter0,iter1,THETAlow,THETAhig);
sg = 1/3; % Because fields are cumulated over 3 years

fid = fopen(strcat(pref,'LRvol.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); 
	Mvol = permute(M*sg,[3 2 1]); Mvol(Mvol==0) = NaN;
else
	Mvol = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

fid = fopen(strcat(pref,'LRadvTOT.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Madv = permute(M*sg,[3 2 1]);
else
	Madv = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end
	
fid = fopen(strcat(pref,'LRtendNATIVE.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); MtendN = permute(M*sg,[3 2 1]);
else
	MtendN = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

fid = fopen(strcat(pref,'LRtendARTIF.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); MtendA = permute(M*sg,[3 2 1]);
	MtendA = MtendA*86400;
else
	MtendA = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

fid = fopen(strcat(pref,'LRadvTOT.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Madv = permute(M*sg,[3 2 1]);
else
	Madv = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

fid = fopen(strcat(pref,'LRdiffTOT.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Mdiff = permute(M*sg,[3 2 1]);
else
	Mdiff = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

fid = fopen(strcat(pref,'LRallotherTOT.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Mall = permute(M*sg,[3 2 1]);
else
	Mall = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

fid = fopen(strcat(pref,'LRairsea3D.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Mq = permute(M*sg,[3 2 1]);
else
	Mq = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

fid = fopen(strcat(pref,'LRghat.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Mghat = permute(M*sg,[3 2 1]);
else
	Mghat = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

% Details of the advective term:
fid = fopen(strcat(pref,'LRadvX.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Madvx = permute(M*sg,[3 2 1]);
else
	Madvx = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

fid = fopen(strcat(pref,'LRadvY.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Madvy = permute(M*sg,[3 2 1]);
else
	Madvy = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

fid = fopen(strcat(pref,'LRadvZ.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Madvz = permute(M*sg,[3 2 1]);
else
	Madvz = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

% Details of the diffusive term:
fid = fopen(strcat(pref,'LRdifX.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Mdiffx = permute(M*sg,[3 2 1]);
else
	Mdiffx = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

fid = fopen(strcat(pref,'LRdifY.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Mdiffy = permute(M*sg,[3 2 1]);
else
	Mdiffy = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

fid = fopen(strcat(pref,'LRdifZ.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Mdiffz = permute(M*sg,[3 2 1]);
else
	Mdiffz = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end

fid = fopen(strcat(pref,'LRdifIZ.3yV2adv.bin'),'r','ieee-be');
if fid > 0
	M = fread(fid,[jpi*jpj*nb_out*nb_out jpk*nb_out],'float32');fclose(fid);
	M = reshape(M,[jpi*nb_out jpj*nb_out jpk*nb_out]); Mdiffiz = permute(M*sg,[3 2 1]);
else
	Mdiffiz = zeros(jpk*nb_out,jpj*nb_out,jpi*nb_out).*NaN;
end



clear M

