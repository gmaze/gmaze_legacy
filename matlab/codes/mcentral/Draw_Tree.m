function Draw_Tree(p,pre,x)
%Function which visualizes general, directed or undirected, rooted trees
% Input variables:
% p: is the vector of parent pointers, (in which p(r) = r implies that r
%    is the root)
% x: is a vector which describes the arcís directions.
% For any non root node i, x(i) = 1, ( x(i) = -1) implies that arc (p(i), i), (arc (i, p(i))) is contained in the tree.
% Also, it is set x(r) = 0 for the root node r. This vector is an optional choice for the user.
% In case it is passed as an argument to the function the tree will be directed.
% pre: is the vector of the pre-order traversal
% Also the number of the nodes and the height of the tree is calculated

% -------------------------------------------------------------------------
% This work was analytically presented in:
%
% Paparrizos K., Samaras N. and Sifaleras A., ´A learning tool for the
% visualization of general, directed or undirected rooted treesª, 
% Proc. of the 1st International Conference on New Learning Paradigms and
% New Learning Tools, (New Learning 2004), 10-12 May 2004, pp. 205-213,
% Skiathos, Greece.
%
% -------------------------------------------------------------------------

%count of the nodes which doesn't exist
zerocounter=0;
for t=1:length(p)
   if p(t)==0
      zerocounter=zerocounter+1;
   end
end
%Find root
k=1;
while k<length(p)+1
   if p(k)==k
      root=k;
   end
   k=k+1;
end
%Sorting...,current is the matrix with the fathers, at any moment
%the pointer directs at the current position, in order for an element to enter in the newlist
%the counter directs to the current position for the matrix current2
%the changepointer shows the current element of the changelist
%Á gotolist shows at which position every node went
newlist=zeros(1,length(p)-zerocounter);
gotolist=zeros(1,length(newlist));
gotolist(root)=1;
changelist(1)=2;
changepointer=2;
pointer=2;
counter=1;
newlist(1)=root;
current(1)=root;
curlength=length(current);
while pointer<=length(newlist) % Until the newlist is filled
   for i=1:curlength % for every father
       B=[];
       for j=1:length(p)
           if p(j)==current(i) & j~=root & p(j)~=0 % find his childrenı
              B=[B,j];
           end
       end %At this point all the children of every father have been found and entered in vector ¬
       m=[];
       for v=1:length(B)% for all the children of every father
           for z=1:length(pre)% search in the structure
               if B(v)==pre(z)% find every child in the structure
                  m=[m,z];% The positions of all his children in the structure, enter with randomly (serial) order in vector m 
               end
           end
       end
       u=sort(m);% sort the vector m and the vctor u is the output
       for g=1:length(u)
           newlist(pointer)=pre(u(g));% the children depended on the order with which they are in preorder, they enter in the newlist
           gotolist(pre(u(g)))=pointer;
           pointer=pointer+1;
           current2(counter)=pre(u(g));
           counter=counter+1;
       end
   end
   changelist(changepointer)=changelist(changepointer-1)+length(current2);
   changepointer=changepointer+1;
   current=current2;
   current2=[];
   counter=1;
   curlength=length(current);
end
%At this point the coordinates of the nodesa are given, which are going to be
%used for the drawing
%the xcounter is set to zero everytime the height is changed, in order that for every height the coordinates start counting from 0
%the xypoints is a matrix, in which every column corresponds to a node, depending on the node's order in the newlist
%the first row consists of the necessary coordinates (x-axis), while the second row consists of the necessary coordinates (y-axis), for each node.
xypoints=zeros(2,length(newlist));
changepointer=2;
pointer=2;
xcounter=0;
y=-5;
while pointer<=length(newlist)
   if pointer==changelist(changepointer)
      changepointer=changepointer+1;
      xcounter=0;
      y=y-5;
   end
   xypoints(1,pointer)=5*xcounter;
   xypoints(2,pointer)=y;
   xcounter=xcounter+1;
   pointer=pointer+1;
end
%From this point the tree starts to balance
changelist=[1 changelist];
treeheight=length(changelist)-2;
changecounter=treeheight+1;
while changecounter>1
      newcounter=changelist(changecounter);
      for i=changelist(changecounter-1):changelist(changecounter)-1
          midx=[];
          if newcounter<=length(newlist)&p(newlist(newcounter))==newlist(i)
             midx(1)=xypoints(1,newcounter);
             newcounter=newcounter+1;
             while newcounter<=length(newlist)&(p(newlist(newcounter)))==newlist(i)
                   midx(2)=xypoints(1,newcounter);
                   newcounter=newcounter+1;
             end %while
             if length(midx)==1
                midx(2)=midx(1);
             end %if
             newx=(midx(1)+midx(2))/2;
             oldx=xypoints(1,i);
             if newx>oldx
                for r=i:changelist(changecounter)-1
                    xypoints(1,r)=xypoints(1,r)+newx-oldx;
                end %for
            else
                for j=changelist(changecounter-1):i-1
                    xypoints(1,j)=xypoints(1,j)+newx-oldx;
                    times=1;
                    jump=changecounter;
                    for k=changelist(changecounter):length(newlist)
                        if k==changelist(jump+1)
                           times=times+1;
                           jump=jump+1;
                        end %if
                        cur=newlist(k);
                        for l=1:times
                            cur=p(cur);
                        end %for
                        if cur==newlist(j)
                           xypoints(1,k)=xypoints(1,k)+newx-oldx;
                        end %if
                     end%for
                 end%for
                 xypoints(1,i)=xypoints(1,i)+newx-oldx;
             end%elseif
         end%if
     end%for
     changecounter=changecounter-1;
end%while
%Now the visualization starts, while the user may choose the shape or the
%colour of the nodes
%The matrix xypoints is in its final format
s=menu('Choose a shape','Circle','Square','Triangle','Diamond');
shape=['o','s','^','d'];
k=menu('Choose a color','Red','Yellow','Green','Cyan','Blue','Purple','White');
color = ['r','y','g','c','b','m','w'];
figure
%------------------------------------------------------------
if nargin==2 %undirected tree
hold on
%Now the edges are depicted
   for i=1:length(p)
       a=[xypoints(1,gotolist(p(i))),xypoints(1,gotolist(i))];
       b=[xypoints(2,gotolist(p(i))),xypoints(2,gotolist(i))];
       plot(a,b)
   end
end
%Now the nodes are depicted
plot(xypoints(1,:),xypoints(2,:),shape(s),'MarkerSize',16,'MarkerFaceColor',color(k),'MarkerEdgeColor',color(k))
text(xypoints(1,:),xypoints(2,:),num2str(newlist(:)),'HorizontalAlignment','center','FontSize',8);
xmin=min(xypoints(1,:));
xmax=max(xypoints(1,:));
text(xmin,0,strcat('Treeheight=  ',num2str(treeheight)),'FontSize',8);
text(xmax,0,strcat('Number of nodes=  ',num2str(length(newlist)),'           '),'HorizontalAlignment','right','FontSize',8);
axis off
%------------------------------------------------------------
if nargin==3 %directed tree
hold on
%Now the edges are depicted
for i=1:length(x)
    if x(i)==1
        myquiver(xypoints(1,gotolist(p(i))),xypoints(2,gotolist(p(i))),xypoints(1,gotolist(i))-xypoints(1,gotolist(p(i))),xypoints(2,gotolist(i))-xypoints(2,gotolist(p(i))))
    else if x(i)==-1
        myquiver(xypoints(1,gotolist(i)),xypoints(2,gotolist(i)),xypoints(1,gotolist(p(i)))-xypoints(1,gotolist(i)),xypoints(2,gotolist(p(i)))-xypoints(2,gotolist(i)))
    end
end
end
%Now the nodes are depicted
plot(xypoints(1,:),xypoints(2,:),shape(s),'MarkerSize',16,'MarkerFaceColor',color(k),'MarkerEdgeColor',color(k))
text(xypoints(1,:),xypoints(2,:),num2str(newlist(:)),'HorizontalAlignment','center','FontSize',8);
xmin=min(xypoints(1,:));
xmax=max(xypoints(1,:));
text(xmin,0,strcat('Treeheight=  ',num2str(treeheight)),'FontSize',8);
text(xmax,0,strcat('Number of nodes=  ',num2str(length(newlist)),'           '),'HorizontalAlignment','right','FontSize',8);
end

function hh = quiver(varargin)
%QUIVER Quiver plot.
%   QUIVER(X,Y,U,V) plots velocity vectors as arrows with components (u,v)
%   at the points (x,y).  The matrices X,Y,U,V must all be the same size
%   and contain corresponding position and velocity components (X and Y
%   can also be vectors to specify a uniform grid).  QUIVER automatically
%   scales the arrows to fit within the grid.
%
%   QUIVER(U,V) plots velocity vectors at equally spaced points in
%   the x-y plane.
%
%   QUIVER(U,V,S) or QUIVER(X,Y,U,V,S) automatically scales the 
%   arrows to fit within the grid and then stretches them by S.  Use
%   S=0 to plot the arrows without the automatic scaling.
%
%   QUIVER(...,LINESPEC) uses the plot linestyle specified for
%   the velocity vectors.  Any marker in LINESPEC is drawn at the base
%   instead of an arrow on the tip.  Use a marker of '.' to specify
%   no marker at all.  See PLOT for other possibilities.
%
%   QUIVER(...,'filled') fills any markers specified.
%
%   H = QUIVER(...) returns a vector of line handles.
%
%   Example:
%      [x,y] = meshgrid(-2:.2:2,-1:.15:1);
%      z = x .* exp(-x.^2 - y.^2); [px,py] = gradient(z,.2,.15);
%      contour(x,y,z), hold on
%      quiver(x,y,px,py), hold off, axis image
%
%   See also FEATHER, QUIVER3, PLOT.

%   Clay M. Thompson 3-3-94
%   Copyright 1984-2001 The MathWorks, Inc. 
%   $Revision: 5.20 $  $Date: 2001/04/15 12:03:54 $

% Arrow head parameters
alpha = 0.25; % Size of arrow head relative to the length of the vector
beta = 0.25;  % Width of the base of the arrow head relative to the length
autoscale = 1; % Autoscale if ~= 0 then scale by this.
plotarrows = 1; % Plot arrows
sym = '';

filled = 0;
ls = '-';
ms = '';
col = '';

nin = nargin;
% Parse the string inputs
while isstr(varargin{nin}),
  vv = varargin{nin};
  if ~isempty(vv) & strcmp(lower(vv(1)),'f')
    filled = 1;
    nin = nin-1;
  else
    [l,c,m,msg] = colstyle(vv);
    if ~isempty(msg), 
      error(sprintf('Unknown option "%s".',vv));
    end
    if ~isempty(l), ls = l; end
    if ~isempty(c), col = c; end
    if ~isempty(m), ms = m; plotarrows = 0; end
    if isequal(m,'.'), ms = ''; end % Don't plot '.'
    nin = nin-1;
  end
end

error(nargchk(2,5,nin));

% Check numeric input arguments
if nin<4, % quiver(u,v) or quiver(u,v,s)
  [msg,x,y,u,v] = xyzchk(varargin{1:2});
else
  [msg,x,y,u,v] = xyzchk(varargin{1:4});
end
if ~isempty(msg), error(msg); end

if nin==3 | nin==5, % quiver(u,v,s) or quiver(x,y,u,v,s)
  autoscale = varargin{nin};
end

% Scalar expand u,v
if prod(size(u))==1, u = u(ones(size(x))); end
if prod(size(v))==1, v = v(ones(size(u))); end

if autoscale,
  % Base autoscale value on average spacing in the x and y
  % directions.  Estimate number of points in each direction as
  % either the size of the input arrays or the effective square
  % spacing if x and y are vectors.
  if min(size(x))==1, n=sqrt(prod(size(x))); m=n; else [m,n]=size(x); end
  delx = diff([min(x(:)) max(x(:))])/n;
  dely = diff([min(y(:)) max(y(:))])/m;
  del = delx.^2 + dely.^2;
  if del>0
    len = sqrt((u.^2 + v.^2)/del);
    maxlen = max(len(:));
  else
    maxlen = 0;
  end
  
  if maxlen>0
    autoscale = autoscale*0.9 / maxlen;
  else
    autoscale = autoscale*0.9;
  end
  u = u*autoscale; v = v*autoscale;
end

ax = newplot;
next = lower(get(ax,'NextPlot'));
hold_state = ishold;

% Make velocity vectors
x = x(:).'; y = y(:).';
u = u(:).'; v = v(:).';
uu = [x;x+u;repmat(NaN,size(u))];
vv = [y;y+v;repmat(NaN,size(u))];

h1 = plot(uu(:),vv(:),[col ls]);

if plotarrows,
  % Make arrow heads and plot them
  hu = [x+u-alpha*(u+beta*(v+eps));x+u; ...
        x+u-alpha*(u-beta*(v+eps));repmat(NaN,size(u))];
  hv = [y+v-alpha*(v-beta*(u+eps));y+v; ...
        y+v-alpha*(v+beta*(u+eps));repmat(NaN,size(v))];
  hold on
  h2 = plot(hu(:),hv(:),[col ls]);
else
  h2 = [];
end

if ~isempty(ms), % Plot marker on base
  hu = x; hv = y;
  hold on
  h3 = plot(hu(:),hv(:),[col ms]);
  if filled, set(h3,'markerfacecolor',get(h1,'color')); end
else
  h3 = [];
end

if ~hold_state, hold off, view(2); set(ax,'NextPlot',next); end

if nargout>0, hh = [h1;h2;h3]; end
