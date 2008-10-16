% CREATE A BIN FILES WITH ITERATIONS TO PERFORM WITH INTERPBUDGETALLINONCE.F90
% ALLOW TO PERFORM SINGLE MONTHS COMPUTATION

%
% Created by Guillaume Maze on 2008-09-30.
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



nt = 1099;
t = datenum(2003,11,1,0,0,0); t = t(1):t(1)+nt-1;
patho = '~/data/OCCA/Tlayer_budget/timeline/';

% 
for im = 1 : 12
	list = find(str2num(datestr(t,'mm'))==im);
	tokeep(im).value = list;
end

ii = 0;
for iy = 2003:2006
	ii = ii + 1;
	list = find(str2num(datestr(t,'yyyy'))==iy);
	tokeepY(ii).value = list;
end


% CREATE A BIN FILES OF LENGTH NT, WITH 1 WHERE TO COMPUTE BUDGET AND 0 ELSEWHERE

wm = [1 2 3];
list = zeros(1,nt);
for im = 1 : length(wm)
	list(tokeep(wm(im)).value) = 1;
end
fid = fopen(strcat(patho,'TIMESERIE_JFM.bin'),'w','ieee-be');
fwrite(fid,list,'integer*4');
fclose(fid);

wm = [6 7 8];
list = zeros(1,nt);
for im = 1 : length(wm)
	list(tokeep(wm(im)).value) = 1;
end
fid = fopen(strcat(patho,'TIMESERIE_JJA.bin'),'w','ieee-be');
fwrite(fid,list,'integer*4');
fclose(fid);


wm = [1:12];
list = zeros(1,nt);
for im = 1 : length(wm)
	list(tokeep(wm(im)).value) = 1;
end
fid = fopen(strcat(patho,'TIMESERIE_YEAR.bin'),'w','ieee-be');
fwrite(fid,list,'integer*4');
fclose(fid);


wm = [7];
wy = 2;
list = zeros(1,nt);
list(tokeep(wm).value) = 1;
list(tokeepY(wy).value) = list(tokeepY(wy).value) + 1;
list(list~=2) = 0;
list(list~=0) = 1;
fid = fopen(strcat(patho,'TIMESERIE_Jul2004.bin'),'w','ieee-be');
fwrite(fid,list,'integer*4');
fclose(fid);


wm = [11:12];
wy = 1;
list = zeros(1,nt);
for im = 1 : length(wm)
	list(tokeep(wm(im)).value) = 1;
end
list(tokeepY(wy).value) = list(tokeepY(wy).value) + 1;
list(list~=2) = 0;
list(list~=0) = 1;
fid = fopen(strcat(patho,'TIMESERIE_2003.bin'),'w','ieee-be');
fwrite(fid,list,'integer*4');
fclose(fid);



for im = 1 : 12
	toto = monthlabs(im);
	list = zeros(1,nt); list(tokeep(im).value) = 1;
	fid = fopen(sprintf('%s/TIMESERIE_%s.bin',patho,toto.noblank),'w','ieee-be');
	fwrite(fid,list,'integer*4');
	fclose(fid);

end %for im


























