% DIAG_SCREEN Same as DISP but allow to print in a log file
%
% [] = DIAG_SCREEN(MESSAGE,PID,[FIDLOGFILE],[FORMAT])
%
% Print to the screen and/or in a log file
% PID = 1 : Print to screen
% PID = 2 : Print to file LOGFILE (fid pointer)
%
% May also use: PID = [1 2]
% To make to implementation easier in big routines, a default set
% is available in global variables:
% DEFAULT IS:
% global 
% PID = [1 2]; % Screen and log file
% [LOGFILE] = fid_logfile; % 
% [FORMAT] = '%s\n';
%
% EG OF USE:
% global diag_screen_default
% diag_screen_default.PIDlist = [1 2];
% fid = fopen('myrun.log','w');
% diag_screen_default.fid = fid;
% diag_screen_default.forma = '%s\n';
% diag_screen('Hello world');
%
% Copyright (c) 2006 Guillaume Maze. 
% http://codes.guillaumemaze.org

%
% This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any later version.
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

function varargout = diag_screen(varargin)

if nargin == 1 & isempty(whos('global','diag_screen_default'))
    error('diag_screen');
    return
end

if nargin == 1 & ~isempty(whos('global','diag_screen_default'))
  % Use default set in global
  global diag_screen_default
  PIDlist = diag_screen_default.PIDlist;
  fid     = diag_screen_default.fid;
  forma   = diag_screen_default.forma;
  messa   = varargin{1};
  for ipid = 1 : length(PIDlist)
    PID = PIDlist(ipid);
    
  switch PID
   case 1
    disp(messa);
   case 2
    if isa(messa,'cell')
		for il = 1 : length(messa)
			fprintf(fid,strcat(forma),cell2mat(messa(il)));
		end		
	else
        fprintf(fid,forma,messa);
    end
  end % switch
  end %for ipid
  
end 


if nargin >= 2
  
  PIDlist = varargin{2};
  for ipid = 1 : length(PIDlist)
    PID = PIDlist(ipid);
    
  switch PID
   case 1
    disp(varargin{1});
   case 2
    messa = varargin{1};
    fid   = varargin{3};
    forma = varargin{4};
    if isa(messa,'cell')
		for il = 1 : length(messa)
			fprintf(fid,strcat(forma),cell2mat(messa(il)));
		end		
	else
        fprintf(fid,forma,messa);
    end
  end
  
  end %for ipid
end


    