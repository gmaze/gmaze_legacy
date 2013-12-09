function pushd(varargin)
%PUSHD  Changes MATLAB working directory to the one specified, or to the folder containing the specified file
%   PUSHD(directory/file) stores the current working directory and changes current directory to the one 
%   specified in the string directory/file.  Files must exist in the MATLAB path. To get back to the stored
%   directory call POPD, see help popd.
%   
%   PUSHD(directory) changes working dir to to the directory specified in
%   the string directory. 
%
%   PUSHD(file) changes the directory to the one containing file. The file
%   has to be in the MATLAB path.
%   
%   PUSHD without argument stores MATLAB current directory
%
%   
%   Example 1:          Directories
%   pushd('..\');       % Move to one step up in the folder hierarchy and store current directory
%   pwd                 % Check current dir
%   popd;               % Use popd to get back to the stored directory
%   pwd                 % Check current dir
%   
%   Example 2:          Files
%   pushd('sin');       % Move to the folder containing sin.m
%   pwd                 % Check current dir
%
%   Example 3:          Non-functional calls
%   pushd ..\..\        % Moves two steps, using non-functional call 
%   pwd
%  
%   Example 4:          Stack pushing
%   pushd ..\..
%   % do something
%   pushd filter
%   pwd
%   % do something else
%   popd                % Now you are in ..\..
%   pwd
%   popd                % Now you are back where you started
%   pwd
%
%   Example 5:
%   pushd dirspec       % dirspec can be any directory in your matlab-path
% 
% 
% 
%   See also popd, cd, pwd

% Author: Peter (PB) Bodin
% pbodin@kth.se
% Created: Jul 2005
% Updated 2005-08-12
% Changes:
% Version 2
% Changed from using setappdata to setpref, this allows the last pushed dir 
% to be remembered between sessions.
% Version 3
% Fixed a bug 
% Added stack funcionality (Thanks to John D'Errico who found the bug and suggested the stack)
% Version 3.1 
% Added some error trapping. It is now possible to write the dir name only,
% no need for a valid "cd-string"
% Version 3.11
% Added error trapping to catch errors caused by changed output of WHICH 
% for built-ins. (Thanks to Jiro Doke for making me aware of the problem)


error(nargchk(0,1,nargin,'struct'));
if ~ispref('pushd','pushed')
    addpref('pushd','pushed',pwd);
end
switch nargin
    case 0
        % use the string '£*$*£' to create a separator in a fake stack, this will allow
        % popd pop back up the stack.
        setpref('pushd','pushed',[getpref('pushd','pushed') '£*$*£' pwd]);
    case 1 & isdir(varargin{1})
        setpref('pushd','pushed',[getpref('pushd','pushed') '£*$*£' pwd]);
        try  % If the user supplied a valid "cd-string" go there.
            cd(varargin{1});
        catch % If only a dir-name, use what to find it.
            w=what(varargin{1});
            cd(w.path);
        end
    case 1 & ~isempty(which(varargin{1}));
        setpref('pushd','pushed',[getpref('pushd','pushed') '£*$*£' pwd]);
        try % Try to jump to the dir containing the file
            cd(fileparts(which([varargin{1}])))
        catch % Ok, the file is a built-in function and the user did not supply the file extension.
            cd(fileparts(which([varargin{1} '.m'])))
        end
    otherwise
        error('First argument of PUSHD must be a string containing a valid directory name or file in the MATLAB path')
end
