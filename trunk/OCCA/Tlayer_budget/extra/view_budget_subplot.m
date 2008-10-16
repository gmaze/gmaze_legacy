% Make 4 subplots maps tight

posi = posiI;
posiCL = posiCLI;

dx = 0.1;
dy = .07;
he = 0.3305;

%%% MOVE LEFT:
ip=1; set(sb(ip),'position',[posi(ip,1)-dx*2/3 posi(ip,2:3) he]);
ip=3; set(sb(ip),'position',[posi(ip,1)-dx*2/3 posi(ip,2:3) he]);
ip=2; set(sb(ip),'position',[posi(ip,1)-1.75*dx posi(ip,2:3) he]);
ip=4; set(sb(ip),'position',[posi(ip,1)-1.75*dx posi(ip,2:3) he]);

%%% Update positions:
for ip = 1 : 4, posi(ip,:) = get(sb(ip),'position'); end

%%% Colorbar:
set(cl(4),'position',[posi(4,1)+posi(4,2)+2*dx posi(4,3)-dy 0.01 2*he]);

%%% MOVE UP
ip=3; set(sb(ip),'position',[posi(ip,1) posi(ip,2)+dy posi(ip,3) he]);
ip=4; set(sb(ip),'position',[posi(ip,1) posi(ip,2)+dy posi(ip,3) he]);

%%% Update positions:
for ip = 1 : 4, posi(ip,:) = get(sb(ip),'position'); end

%%% Ensure all plot have the same height:
for ip = 1 : 4
	set(sb(ip),'position',[posi(ip,1:3) he]);
end
