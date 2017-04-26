function FIELD = shiftxORCA025(FIELD)
% shiftxORCA025 Shift an ORCA025 2/3D field for 0-360 longitude convention
%
% FIELD = shiftxORCA025(FIELD) 
% 	Shift an ORCA025 2/3D field for 0-360 longitude convention
%
% REQUIRED INPUTS:
%	FIELD: a (1442x1021xZ) array from the original grid
% OUTPUTS:
%	FIELD (1442x1021xZ) shifted
% 
% Copyright (c) 2016, Guillaume Maze (Ifremer, Laboratoire d'Océanographie Physique et Spatiale).
% Created: 2016,-11-25 (G. Maze)

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Ifremer, Laboratoire d'Océanographie Physique et Spatiale nor the names of its contributors may be used 
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

%- Check field
[nx,ny,nz] = size(FIELD);
if nx ~= 1442 | ny ~= 1021
	error('This function is only for 1442x1021 global ORCA025 fields');
end% if 

%- Construct the circshift index table:
dx = ones(1,1021);
dx(1:580)   = -1150;
dx(581:679) = -1149;
dx(680:700) = -1148;
dx(701:715) = -1147;
dx(716:end) = [-1146,-1146 ,-1146 ,-1146 ,-1146 ,-1146 ,-1146 ,-1146 ,-1146 ,-1146 ,-1146 ,-1145 ,-1145 ,-1145 ,-1145 ,-1145 ,-1145 ,-1145 ,-1145 ,-1145 ,-1145 ,-1144 ,-1144 ,-1144 ,-1144 ,-1144 ,-1144 ,-1144 ,-1144 ,-1144 ,-1143 ,-1143 ,-1143 ,-1143 ,-1143 ,-1143 ,-1143 ,-1142 ,-1142 ,-1142 ,-1142 ,-1142 ,-1142 ,-1142 ,-1141 ,-1141 ,-1141 ,-1141 ,-1141 ,-1141 ,-1141 ,-1140 ,-1140 ,-1140 ,-1140 ,-1140 ,-1140 ,-1139 ,-1139 ,-1139 ,-1139 ,-1139 ,-1139 ,-1138 ,-1138 ,-1138 ,-1138 ,-1138 ,-1137 ,-1137 ,-1137 ,-1137 ,-1137 ,-1136 ,-1136 ,-1136 ,-1136 ,-1136 ,-1135 ,-1135 ,-1135 ,-1135 ,-1135 ,-1134 ,-1134 ,-1134 ,-1134 ,-1134 ,-1133 ,-1133 ,-1133 ,-1133 ,-1132 ,-1132 ,-1132 ,-1132 ,-1131 ,-1131 ,-1131 ,-1131 ,-1130 ,-1130 ,-1130 ,-1130 ,-1129 ,-1129 ,-1129 ,-1129 ,-1128 ,-1128 ,-1128 ,-1128 ,-1127 ,-1127 ,-1127 ,-1127 ,-1126 ,-1126 ,-1126 ,-1125 ,-1125 ,-1125 ,-1125 ,-1124 ,-1124 ,-1124 ,-1123 ,-1123 ,-1123 ,-1123 ,-1122 ,-1122 ,-1122 ,-1121 ,-1121 ,-1121 ,-1120 ,-1120 ,-1120 ,-1119 ,-1119 ,-1119 ,-1119 ,-1118 ,-1118 ,-1118 ,-1117 ,-1117 ,-1117 ,-1116 ,-1116 ,-1116 ,-1115 ,-1115 ,-1115 ,-1114 ,-1114 ,-1114 ,-1113 ,-1113 ,-1113 ,-1112 ,-1112 ,-1112 ,-1111 ,-1111 ,-1110 ,-1110 ,-1110 ,-1109 ,-1109 ,-1109 ,-1108 ,-1108 ,-1108 ,-1107 ,-1107 ,-1107 ,-1106 ,-1106 ,-1105 ,-1105 ,-1105 ,-1104 ,-1104 ,-1104 ,-1103 ,-1103 ,-1102 ,-1102 ,-1102 ,-1101 ,-1101 ,-1101 ,-1100 ,-1100 ,-1099 ,-1099 ,-1099 ,-1098 ,-1098 ,-1098 ,-1097 ,-1097 ,-1096 ,-1096 ,-1096 ,-1095 ,-1095 ,-1094 ,-1094 ,-1094 ,-1093 ,-1093 ,-1093 ,-1092 ,-1092 ,-1091 ,-1091 ,-1091 ,-1090 ,-1090 ,-1089 ,-1089 ,-1089 ,-1088 ,-1088 ,-1088 ,-1087 ,-1087 ,-1086 ,-1086 ,-1086 ,-1085 ,-1085 ,-1084 ,-1084 ,-1084 ,-1083 ,-1083 ,-1083 ,-1082 ,-1082 ,-1081 ,-1081 ,-1081 ,-1080 ,-1080 ,-1080 ,-1079 ,-1079 ,-1078 ,-1078 ,-1078 ,-1077 ,-1077 ,-1077 ,-1076 ,-1076 ,-1076 ,-1075 ,-1075 ,-1074 ,-1074 ,-1074 ,-1073 ,-1073 ,-1073 ,-1072 ,-1072 ,-1072 ,-1071 ,-1071 ,-1071 ,-1070 ,-1070 ,-1070 ,-1069 ,-1069 ,-1069 ,-1068 ,-1068 ,-1068 ,-1067 ,-1067 ,-1067 ,-1066 ,-1066 ,-1066 ,-1065 ,-1065 ,-1065 ,-1065 ,-1064 ,-1064 ,-1064 ,-1063 ,-1063 ,-1063 ,-1062 ,-1062 ,-1062 ,-1062 ,-1061 ,-1061 ,-1061];

%- Shift the table:
for iy = 1 : ny
	FIELD(:,iy,:) = circshift(FIELD(:,iy,:),dx(iy),1);
end% for iy
% for iy = 1 : ny
% 	a0 = squeeze(FIELD(:,iy,:));
% 	FIELD(1:nx--dx(iy)   ,iy,:) = a0(-dx(iy)+1:nx ,:);
% 	FIELD(nx--dx(iy)+1:nx,iy,:) = a0(1:-dx(iy),:);
% end% for iy
% for iy = 1 : ny
% 	FIELD(:,iy,:) = cat(1,FIELD(-dx(iy)+1:nx ,iy,:),FIELD(1:-dx(iy),iy,:));
% end% for iy

end %functionshiftxORCA025



%- How to get dx to change to 0/360 from -180/180:
function dummy()
	% For each row, we circshift to start at 0 instead of -180
	INDX = repmat([1:NLON]',[1 NLAT]);
	for iy = 1 : NLAT
		ix1 = find(LON(:,iy)>=0);
		ix2 = find(LON(:,iy)>=0 & INDX(:,iy)>=NLON/2);
		ix3 = find(LON(:,iy)>=0 & INDX(:,iy)>=NLON/2,1);
		dx(iy) = -ix3+1;
		x = circshift(LON(:,iy),dx(iy),1);
		x2 = x; x2(x>=-180 & x<0) = 360+x(x>=-180 & x<0);
		LON2(:,iy) = x2;
		% clf;iw=1;jw=3;ipl=0;	
		% ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on	
		% plot(INDX(:,iy),LON(:,iy),'k') 
		% plot(INDX(ix1,iy),LON(ix1,iy),'r+')
		% plot(INDX(ix2,iy),LON(ix2,iy),'b+')
		% vline(ix3);hline;
		% ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		% plot(x,'+'); hline
		% ipl=ipl+1;subp(ipl)=subplot(iw,jw,ipl);hold on
		% plot(x2,'+'); hline
		% title(num2str(iy));
		% drawnow
	end% for iy
	save('ORCA025_180to360.mat','dx','LON2','LON');
end% end function

