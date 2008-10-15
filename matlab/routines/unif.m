% FUNI(FLIST)
% Put FLIST identical maximum caxis limit
% gmaze@univ-brest.fr

function varargout = unif(flist)
  

cestfini=0;
cx=[0 0];
ifig=0;
nfig=length(flist);

while cestfini==0
  ifig=ifig+1;
  if ifig<=nfig
	 gc = builtin('figure',flist(ifig));
     limit1=min(caxis);
     if limit1<=cx(1),cx(1)=limit1;end
     limit2=max(caxis);
     if limit2>=cx(2),cx(2)=limit2;end
  else
    cestfini=1;
  end %if
end %while  


for ifig=1:nfig
	gc = builtin('figure',flist(ifig));
	caxis(cx);
end  
