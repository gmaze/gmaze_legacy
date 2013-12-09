% DRAGDEMO Demo for the draggable.m
%   This function is a demo for the draggable.m function and should be
%   distributed along with it. It basically presents some of draggable.m's
%   features: users of draggable.m are invited to read dragdemo's source.
%
%   >> dragdemo(demotitle);
%
%   runs the demo which title is contained in the string demotitle.
%   Available demos are:
%
%   'crosshair'     A draggable crosshair is drawn; its movements are
%                   limited so that its center never leaves the axes. This
%                   is the default demo.
%
%   'dragtest'      Some graphical objects (such as rectangles, lines,
%                   patches and plots) are drawn, following various
%                   constraints. For more details, please read the comments
%                   in the source code.
%
%   'snapgrid'      An example on how to use draggable's "motionfcn"
%                   argument so that a draggable object snaps to a grid.
%
%   'polymove'      A polygon with draggable vertices is drawn;
%                   draggable's "motionfcn" argument is used to redraw the
%                   polygon each time a vertex is moved.
%
% (C) Copyright 2004
% François Bouffard
% fbouffar@gel.ulaval.ca

function dragdemo(demotitle);

if nargin == 0
    demotitle = 'crosshair';
end;

switch lower(demotitle)
    
    case 'crosshair'
        
        % CROSSHAIR demo
        %   We first build the cross, using plot() with a NaN y-element so
        %   that it is non-continuous. The cross spans 0.2 units:
        
        figure;
        p = plot([0.5 0.5 0.4 0.4 0.6],[0.4 0.6 NaN 0.5 0.5]);
        
        %   Some cosmetic adjustments, and adjusting the axes limits:
        
        set(p,'Color','k','LineWidth',2);
        axis equal;
        set(gca,'DataAspectRatio',[1 1 1],'Xlim',[0 1],'YLim',[0 1]);
        title('CROSSHAIR demo for draggable.m');
        
        %   Call to draggable(), using no movement constraint and limits
        %   corresponding to the axes limits, plus half the size of the
        %   cross, so that its center always stay in the axes:
        
        draggable(p,'n',[-0.1 1.1 -0.1 1.1]); 
        
    case 'dragtest'
        
        % DRAGTEST demo
        %   This demo was used in draggable's development to test some of
        %   its features. Users interested in modifying draggable.m should
        %   ensure that it works with this demo in order to verify backward
        %   compatibility.
        %   
        %   Figure creation; we set up an initial WindowButtonDownFcn in
        %   order to test proper figure properties recovery after the
        %   object is dragged:
        
        f = figure;
        set(f,'WindowButtonDownFcn','disp(''Window Click!'')');
        axis equal; box on;
        set(gca,'DataAspectRatio',[1 1 1],'XLim',[0.3 1],'YLim',[0 1]);
        title('DRAGTEST demo for draggable.m');
        
        %   Drawing various test case objects...
        
        hold on;
        
        %   The Green Rectangle tests default behavior:
        
        greenrect = rectangle('Position',[0.7 0.1 0.1 0.2]);
        set(greenrect,'FaceColor','g');
        draggable(greenrect);
        
        %   The Red Square will demonstrates 'off' mode and object
        %   properties recovery afterwards, so that the 'beep' function is
        %   assigned as its ButtonDownFcn.
        
        redsquare = rectangle('Position',[0.5 0.6 0.1 0.1]);
        set(redsquare,'FaceColor','r','ButtonDownFcn','beep');
        draggable(redsquare);
        draggable(redsquare,'off');
        
        %   The Blue Rectangle will demonstrate a case in which the
        %   'painters' renderer is used, and in which the object cannot be
        %   dragged past the axis limits on the right, left and bottom.
        %   However, the object can be dragged past the axis limit on top;
        %   furthermore, the object starts off-limits to the left, so that
        %   it can be dragged inside the limits, but cannot be dragged back
        %   off-limits afterwards.
        
        bluerect = rectangle('Position',[0.2 0.4 0.2 0.2]); 
        set(bluerect,'FaceColor','b');
        draggable(bluerect,'none',[0.3 1 0 inf],'painters');
        
        %   The Magenta Line will demonstrates a line object being dragged
        %   with horizontal movement constraint with default parameters.
        
        magline = line([0.7 0.9],[0.7 0.9]);
        set(magline,'Color','m','LineWidth',2);
        draggable(magline,'h');
        
        %   The Cyan Cross will demonstrates a plot object being dragged,
        %   its center always forced to be in the axes (as in the
        %   'crosshair' demo).
        
        cyancross = plot([0.7 0.7 0.6 0.6 0.8],[0.4 0.6 NaN 0.5 0.5]); 
        set(cyancross,'Color','c','LineWidth',2);
        draggable(cyancross,'n',[0.2 1.1 -0.1 1.1]); 
        
        %   The Yellow Triangle demonstrates a patch object being dragged
        %   with vertical movement constraint and the opengl renderer.
        
        yellowtri = patch([0.4 0.6 0.6],[0.1 0.1 0.2],'y');
        draggable(yellowtri,'v',[0.1 0.7],'opengl');  
        
    case 'snapgrid'
        
        % SNAPGRID demo
        %   The 'motionfcn' argument of draggable.m is used here to set up
        %   a grid on which the object movement is constrained.
        %
        %   Furthermore, we use 'motionfcn' to display a "fleur" figure
        %   pointer while the object moves, and the figure's
        %   WindowButtonMotionFcn to display a standard "arrow" figure
        %   pointer while the mouse moves but the object is not dragged.
        %
        %   First we set up the figure and axes. 
        
        f = figure;
        set(f,'WindowButtonMotionFcn','set(gcf,''Pointer'',''arrow'')');
        axis equal; box on;
        set(gca,'DataAspectRatio',[1 1 1],'XLim',[0 10],'YLim',[0 10],...
            'XTick',0:10,'YTick',0:10);
        grid on;
        title('SNAPGRID demo for draggable.m');
        
        %   Now we create a cross which will snap on a grid with 1-unit
        %   spacing. This is done by giving the handle to the move_cross
        %   function (see below) as the 'movefcn' argument of draggable.m.
        
        hold on;
        cross = plot([5 5 4.5 4.5 5.5],[4.5 5.5 NaN 5 5]); 
        set(cross,'Color','r','LineWidth',3);
        draggable(cross,'n',[-0.5 10.5 -0.5 10.5],@move_cross);

    case 'polymove'

        % POLYMOVE demo
        %   The 'motionfcn' argument of draggable.m is used here to
        %   redraw the polygon each time one of its vertex is moved.

        %   Setting up the figure and axes.

        figure;
        axis equal; box on;
        set(gca,'DataAspectRatio',[1 1 1],'Xlim',[-2 2],'YLim',[-2 2]);
        title('POLYMOVE demo for draggable.m')

        % Creating the polygon vertices

        hold on;
        v1 = plot(-1,0);
        v2 = plot(0,-1);
        v3 = plot(1,0);
        v4 = plot(0,1);
        vv = [v1 v2 v3 v4];
        set(vv,'Marker','o','MarkerSize',10,'MarkerFaceColor','b');

        % Saving the vertex vector as application data
        % in the current axes (along with empty element p which will
        % later hold the handle to the polygon itself)

        setappdata(gca,'vv',vv);
        setappdata(gca,'p',[]);

        % Calling draggable on each of the vertices, passing as an
        % argument the handle to the redraw_poly fucntion (see below)

        draggable(v1,@redraw_poly);
        draggable(v2,@redraw_poly);
        draggable(v3,@redraw_poly);
        draggable(v4,@redraw_poly);

        % Finally we draw the polygon itself using the redraw_poly
        % function, which can be found below

        redraw_poly;

    otherwise
        
        disp(['Demo ''' demotitle ''' is not available.']);
        
end;

% -----------------------------------------------------------------------
% Function MOVE_CROSS
%   This function is passed as the 'motionfcn' argument to draggable.m in
%   the SNAPGRID demo. It recieves the handle to the object being dragged
%   as its only argument.

function move_cross(h);

% We first set up the figure pointer to "fleur"

set(gcf,'Pointer','fleur');

% Then we retrieve the current cross position

cross_xdata = get(h,'XData');
cross_ydata = get(h,'YData');
cross_center = [cross_xdata(1) cross_ydata(5)];

% Computing the new position of the cross

new_position = round(cross_center);

% Updating the cross' XData and YData properties

delta = new_position - cross_center;
cross_center = new_position;
set(h,'XData',cross_xdata+delta(1),'YData',cross_ydata+delta(2));

% -----------------------------------------------------------------------
% Function REDRAW_POLY
%   This function is passed as the 'motionfcn' argument to draggable.m in
%   the POLYMOVE demo. It recieves the handle to the object being dragged
%   as its only argument, but it is not actually used in this function.

function redraw_poly(h);

% Deleting the previous polygon

delete(getappdata(gca,'p'));

% Retrieving the vertex vector and corresponding xdata and ydata

vv = getappdata(gca,'vv');
xdata = cell2mat(get(vv,'xdata'));
ydata = cell2mat(get(vv,'ydata'));

% Plotting the new polygon and saving its handle as application data

p = plot([xdata' xdata(1)],[ydata' ydata(1)]);
setappdata(gca,'p',p);

% Putting the vertices on top of the polygon so that they are easier
% to drag (or else, the polygone line get in the way)

set(gca,'Children',[vv p]);