function draggable(h,varargin)
% DRAGGABLE - Make it so that a graphics object can be dragged in a figure.
%   This function makes an object interactive by allowing it to be dragged
%   accross a set of axes, following or not certain constraints. This
%   allows for intuitive control elements which are not buttons or other
%   standard GUI objects, and which reside inside an axis. Typical use
%   involve markers on an axis, whose position alters the output of a
%   computation or display
% 
%   >> draggable(h);
%   
%   makes the object with handle "h" draggable. Use the "Position" property
%   of the object to retrieve its position, by issuing a get(h,'Position')
%   command.
%
%   >> draggable(h,...,motionfcn)
%
%   where "motionfcn" is a function handle, executes the given function
%   while the object is dragged. Handle h is passed to motionfcn as an
%   argument. Argument "motionfcn" can be put anywhere after handle "h".
%
%   >> draggable(h,...,constraint,p);
%
%   enables the object with handle "h" to be dragged, with a constraint.
%   Arguments "constraint" (a string) and "p" (a vector) can be put
%   anywhere after handle "h".
%
%   The argument "constraint" may be one of the following strings:
%
%       'n' or 'none':          The object is unconstrained (default).
%       'h' or 'horizontal':    The object can only be moved horizontally.
%       'v' or 'vertical':      The object can only be moved vertically.
%
%   The argument "p" is an optional parameter which depends upon the
%   constraint type:
%
%   Constraint      p                   Description
%   -----------------------------------------------------------------------
%
%   'none'          [x1 x2 y1 y2]       Drag range (for the object's outer
%                                       limits, from x1 to x2 on the x-axis
%                                       and from y1 to y2 on the y-axis).
%                                       Default is the current axes range.
%                                       Use "inf" if no limit is desired.
%
%   'horizontal'    [xmin xmax]         Drag range (for the object's outer
%                                       limits). Default is the x-axis
%                                       range. Use "inf" if no limit is
%                                       desired.
%
%   'vertical'      [ymin ymax]         Drag range (for the object's outer
%                                       limits). Default is the y-axis
%                                       range. Use "inf" if no limit is
%                                       desired.
%
%   -----------------------------------------------------------------------
%
%   >> draggable(h,'off')
%
%   returns object h to its original, non-draggable state.
%
%   See the source code (e.g. by issuing "type draggable" at the Matlab 
%   prompt) for implementation notes and the copyright notice.

% VERSION INFORMATION:
% 2003-11-20:   Initially submitted to MatlabCentral.Com
% 2004-01-06:   Addition of the renderer option, as proposed by Ohad Gal
%               as a feedback on MatlabCentral.Com.
% 2004-02-18:   Bugfix: now works with 1-element plots and line objects
% 2004-03-04:   Bugfix: sanitized the way the object's new position is
%               computed; it now always follow the mouse even after the
%               mouse pointer was out of the axes.
% 2004-03-05:   Bugfix: movement when mouse is out of the axes is now
%               definitely correct ;)
% 2006-05-23:   Bugfix: fix a rendering issue using Matlab 7 & +
%               Deprecated the rendering options: rendering seems ok with
%               every renderer.

% Removed help section concerning the renderer option:
%
%   >> draggable(h,...,renderer);
%
%   where renderer is one of 'painters', 'zbuffer' or 'opengl', uses the
%   corresponding renderer for the figure while the graphical object whose
%   handle is h is being dragged. By default, zbuffer is used since it is
%   the only renderer that offers both acceptable performance and a
%   guaranteed correct behavior with draggable. The 'painters' renderer is
%   too slow, while the 'opengl' renderer's behavior with draggable depends
%   ont the graphics driver used and may differ from what is expected. 


% IMPLEMENTATION NOTES:
%
% This function uses the dragged object's "ButtonDownFcn" function and set it
% so that the objec becomes draggable. Any previous "ButtonDownFcn" is thus
% lost during operation, but is retrieved after issuing the draggable(h,'off')
% command.
%
% Information about the object's behavior is also stored in the object's
% 'UserData' property, using setappdata() and getappdata(). The original
% 'UserData' property is restored after issuing the draggable(h,'off')
% command.
%
% The corresponding figure's "WindowButtonDownFcn", "WindowButtonUpFcn" and
% "WindowButtonMotionFcn" functions.  During operation, those functions are
% set by DRAGGABLE; however, the original ones are restored after the user
% stops dragging the object.
%
% By default, DRAGGABLE also switches the figure's renderer to 'zbuffer'
% during operation: 'painters' is not fast enough and 'opengl' sometimes
% produce curious results. However there may be a need to switch to another
% renderer, so the user can now specify a specific figure renderer during
% object drag (thanks to Ohad Gal for the suggestion).
%
% The "motionfcn" function handle is called at each displacement, after the
% object's position is updated, using "feval(motionfcn,h)", where h is the
% object's handle.
%
% TO DO:
%
% 1 - For now, DRAGGABLE allows only one object at a time to be draggable. In
% the future, draggable(h), where h is a vector of handles, will create a
% group of objects that will all be dragged when one of them is selected.

% ==============================================================================
% Copyright (C) 2003, 2004
% Francois Bouffard
% fbouffar@gel.ulaval.ca
% Université Laval, Québec City
% ==============================================================================

% ==============================================================================
% Input arguments management
% ==============================================================================

% Initialization of some default arguments
user_renderer = 'zbuffer';
user_movefcn = [];
constraint = 'none';
p = [];

% At least the handle to the object must be given
Narg = nargin;
if Narg == 0
    error('Not engough input arguments');
elseif prod(size(h))>1
    error('Only one object at a time can be made draggable');
end;

% Fetching informations about the parent axes
axh = get(h,'Parent');
if iscell(axh)
    axh = axh{1};
end;
fgh = get(axh,'Parent');
ax_xlim = get(axh,'XLim');
ax_ylim = get(axh,'YLim');

% Assigning optional arguments
Noptarg = Narg - 1;
for k = 1:Noptarg
    current_arg = varargin{k};
    if isa(current_arg,'function_handle');
        user_movefcn = current_arg;
    end;
    if ischar(current_arg);
        switch lower(current_arg)
            case {'off'}
                set_initial_state(h);
                return;
            case {'painters','zbuffer','opengl'}
                warning('The renderer option is deprecated and will not be taken into account');
                user_renderer = current_arg;
            otherwise
                constraint = current_arg;
        end;
    end;
    if isnumeric(current_arg);
        p = current_arg;
    end;
end;

% Assigning defaults for constraint
switch lower(constraint)
    case {'n','none'}
        if isempty(p); p = [ax_xlim ax_ylim]; end;
    case {'h','horizontal'}
        if isempty(p); p = ax_xlim; end;
    case {'v','vertical'}
        if isempty(p); p = ax_ylim; end;
    otherwise
        error('Unknown constraint type');
end;

% ==============================================================================
% Saving initial state and parameters, setting up the object callback
% ==============================================================================

% Saving object's and parent figure's initial state
setappdata(h,'initial_userdata',get(h,'UserData'));
setappdata(h,'initial_objbdfcn',get(h,'ButtonDownFcn'));
%setappdata(h,'initial_renderer',get(fgh,'Renderer'));
setappdata(h,'initial_wbdfcn',get(fgh,'WindowButtonDownFcn'));
setappdata(h,'initial_wbufcn',get(fgh,'WindowButtonUpFcn'));
setappdata(h,'initial_wbmfcn',get(fgh,'WindowButtonMotionFcn'));

% Saving parameters
setappdata(h,'constraint_type',constraint);
setappdata(h,'constraint_parameters',p);
setappdata(h,'user_movefcn',user_movefcn);
setappdata(h,'user_renderer',user_renderer);

% Detecting if object's position is specified through the
% 'Position' or 'XData' and 'YData' properties
h_properties = get(h);
if isfield(h_properties,'Position')
    setappdata(h,'position_type','rect');
else
    setappdata(h,'position_type','xydata');
end;

% Setting the object's ButtonDownFcn
set(h,'ButtonDownFcn',@click_object);

% ==============================================================================
% FUNCTION click_object
%   Executed when the object is clicked
% ==============================================================================

function click_object(obj,eventdata);
% obj here is the object to be dragged and gcf is the object's parent
% figure since the user clicked on the object
h = obj;
position_type = getappdata(h,'position_type');
if strcmp(position_type,'xydata')
    setappdata(h,'initial_xdata',get(h,'XData'));
    setappdata(h,'initial_ydata',get(h,'YData'));
else
    setappdata(h,'initial_position',get(h,'Position'));
end;
setappdata(h,'initial_point',get(gca,'CurrentPoint'));
set(gcf,'WindowButtonDownFcn',{@activate_movefcn,h});
set(gcf,'WindowButtonUpFcn',{@deactivate_movefcn,h});
activate_movefcn(gcf,eventdata,h);

% ==============================================================================
% FUNCTION activate_movefcn
%   Activates the WindowButtonMotionFcn for the figure
% ==============================================================================

function activate_movefcn(obj,eventdata,h);
% obj here is the figure containing the object
user_renderer = getappdata(h,'user_renderer');
%set(obj,'Renderer',user_renderer);
if strcmp(user_renderer,'painters')
    set(obj,'Doublebuffer','on');
end;
set(obj,'WindowButtonMotionFcn',{@movefcn,h});

% ==============================================================================
% FUNCTION deactivate_movefcn
%   Deactivates the WindowButtonMotionFcn for the figure
% ==============================================================================

function deactivate_movefcn(obj,eventdata,h);
% obj here is the figure containing the object
set(obj,'WindowButtonMotionFcn',getappdata(h,'initial_wbmfcn'));
set(obj,'WindowButtonDownFcn',getappdata(h,'initial_wbdfcn'));
set(obj,'WindowButtonUpFcn',getappdata(h,'initial_wbufcn'));
%set(obj,'Renderer',getappdata(h,'initial_renderer'));

% ==============================================================================
% FUNCTION set_initial_state
%   Returns the object to its initial state
% ==============================================================================

function set_initial_state(h);
initial_objbdfcn = getappdata(h,'initial_objbdfcn');
initial_userdata = getappdata(h,'initial_userdata');
set(h,'ButtonDownFcn',initial_objbdfcn);
set(h,'UserData',initial_userdata);

% ==============================================================================
% FUNCTION movefcn
%   Actual code for dragging the object
% ==============================================================================

function movefcn(obj,eventdata,h);
% obj here is the figure containing the object

% Retrieving data saved in the figure
position_type = getappdata(h,'position_type');
if strcmp(position_type,'xydata')
    initial_xdata = getappdata(h,'initial_xdata');
    initial_ydata = getappdata(h,'initial_ydata');
else
    %initial_position = getappdata(h,'initial_position');
end;
initial_point = getappdata(h,'initial_point');
constraint = getappdata(h,'constraint_type');
p = getappdata(h,'constraint_parameters');
user_movefcn = getappdata(h,'user_movefcn');

% Getting current point
current_point = get(gca,'CurrentPoint');

% Retrieving (x,y) couple for current and initial points
cpt = current_point(1,1:2);
ipt = initial_point(1,1:2);

% Computing movement
dpt = cpt - ipt;

% Computing movement range and imposing movement constraints
% (p is always [xmin xmax ymin ymax])
switch lower(constraint)
    case {'n','none'};
        range = p;
    case {'h','horizontal'}
        dpt(2) = 0;
        range = [p -inf inf];
    case {'v','vertical'}
        dpt(1) = 0;
        range = [-inf inf p];
end;

% Computing new position.
% What we want is actually a bit complex: we want the object to adopt the new
% position, unless it gets out of range. If it gets out of range in a direction,
% we want it to stick to the limit in that direction. Also, if the object is out
% of range at the beginning of the movement, we want to be able to move it back
% into range, so that movement must then be allowed.

switch lower(position_type)

    % Objects with rectangle-type position information
    case 'rect'

        % Retrieveing various quantities:
        %   initial_position is the position when the object was clicked
        %   oldpos is the current position, which will be updated
        %   newpos is the new (proposed) position
        %   old_obj_extent and new_pos extent are the extent occupied by
        %       the old and new objects
        initial_position = getappdata(h,'initial_position');
        oldpos = get(h,'Position');
		if numel(initial_position) == 3,initial_position(4) = 0;end
		if numel(oldpos) == 3,oldpos(4) = 0;end
		
%		stophere
        old_obj_extent = [oldpos(1) oldpos(1)+oldpos(3) oldpos(2) oldpos(2)+oldpos(4)];
        newpos = initial_position + [dpt 0 0];
        new_obj_extent = [newpos(1) newpos(1)+newpos(3) newpos(2) newpos(2)+newpos(4)];

        % Verifying if old and new objects breach the allowed range in any
        % direction (see the function is_inside_range below)
        old_inrange = is_inside_range(old_obj_extent,range);
        new_inrange = is_inside_range(new_obj_extent,range);

        % Modifying dpt to stick to range limit if range violation occured,
        % but the movement won't get restricted if the object was out of range
        % to begin with
        if old_inrange(1) & ~new_inrange(1)
            dpt(1) = range(1) - initial_position(1);
        end
        if old_inrange(2) & ~new_inrange(2)
            dpt(1) = range(2) - initial_position(1) - initial_position(3);
        end;
        if old_inrange(3) & ~new_inrange(3)
            dpt(2) = range(3) - initial_position(2);
        end;
        if old_inrange(4) & ~new_inrange(4)
            dpt(2) = range(4) - initial_position(2) - initial_position(4);
        end

        % Computing the final new position and setting it
        newpos = initial_position + [dpt 0 0];
		if numel(get(h,'Position')) == 3
	        set(h,'Position',newpos(1:3));
		else
	        set(h,'Position',newpos);
		end

    % Objects with line-type position information
    case 'xydata'

       % Retrieveing various quantities:
        %   initial_position is the position when the object was clicked
        %   oldpos is the current position, which will be updated
        %   newpos is the new (proposed) position
        %   old_obj_extent and new_pos extent are the extent occupied by
        %       the old and new objects
        initial_xdata = getappdata(h,'initial_xdata');
        initial_ydata = getappdata(h,'initial_ydata');
        initial_position = [initial_xdata(:)' ; initial_ydata(:)'];
        xdata = get(h,'XData');
        ydata = get(h,'YData');
        oldpos = [xdata(:)' ; ydata(:)'];
        old_obj_extent = [min(xdata) max(xdata) min(ydata) max(ydata)];
        newpos = initial_position + dpt'*ones(1,size(oldpos,2));
        new_obj_extent = [min(newpos(1,:)) max(newpos(1,:)) min(newpos(2,:)) max(newpos(2,:))];

        % Verifying if old and new objects breach the allowed range in any
        % direction (see the function is_inside_range below)
        old_inrange = is_inside_range(old_obj_extent,range);
        new_inrange = is_inside_range(new_obj_extent,range);

        % Modifying dpt to stick to range limit if range violation occured,
        % but the movement won't get restricted if the object was out of range
        % to begin with
        if old_inrange(1) & ~new_inrange(1)
            dpt(1) = range(1) - min(initial_xdata);
        end
        if old_inrange(2) & ~new_inrange(2)
            dpt(1) = range(2) - max(initial_xdata);
        end;
        if old_inrange(3) & ~new_inrange(3)
            dpt(2) = range(3) - min(initial_ydata);
        end;
        if old_inrange(4) & ~new_inrange(4)
            dpt(2) = range(4) - max(initial_ydata);
        end

        % Computing the final new position and setting it
        newpos = initial_position + dpt'*ones(1,size(oldpos,2));
        set(h,'XData',newpos(1,:),'YData',newpos(2,:));
		
end;

% Calling user-provided function handle
if ~isempty(user_movefcn)
    feval(user_movefcn,h);
end;

% ==============================================================================
% FUNCTION is_inside_range
%   Checks if a rectangular object is entirely inside a rectangular range
% ==============================================================================

function inrange = is_inside_range(extent,range)
inrange = [extent(1)>=range(1) extent(2)<=range(2) ...
        extent(3)>=range(3) extent(4)<=range(4)];