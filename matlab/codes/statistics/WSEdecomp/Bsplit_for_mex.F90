! Bsplit_for_mex H1LINE
!
! [] = Bsplit_for_mex()
! 
! HELPTEXT
!
!     This is a MEX-file for MATLAB.
!     Copyright 1984-2006 The MathWorks, Inc.
!
! Created: 2009-09-29.
! Copyright (c) 2009, Guillaume Maze (Laboratoire de Physique des Oceans).
! All rights reserved.
! http://codes.guillaumemaze.org
!
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:
! 	* Redistributions of source code must retain the above copyright notice, this list of 
! 	conditions and the following disclaimer.
! 	* Redistributions in binary form must reproduce the above copyright notice, this list 
! 	of conditions and the following disclaimer in the documentation and/or other materials 
! 	provided with the distribution.
! 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
!	to endorse or promote products derived from this software without specifi! prior 
!	written permission.
!
! THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
! INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
! PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
! DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
! LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
! BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
! STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
! OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
!
!
#include "/Applications/MATLAB74/extern/include/fintrf.h"
#include "/Users/gmaze/matlab/mymex/gmaze.h"
!#include "Bsplit.F90"
!#include "Bfft.F90"
!      
!======================================================================
!	FORTRAN-MATLAB GATEWAY ROUTINE
!======================================================================
	subroutine mexFunction(nlhs, plhs, nrhs, prhs)
!	nlhs : nargout
!	plhs : nlhs element array that contains pointers to the left-hand side outputs that the Fortran generates
!	nrhs : nargin
!	prhs : nrhs element array that contains pointers to the right-hand side inputs to the MEX-file
!	Eg: x = fun(y,z);
!		Matlab will call mexFunction with:
!		nlhs = 1, nrhs = 2, plhs(1) = null, prhs(1) = y and prhs(2) = z
!
!	Standard:
	integer nlhs, nrhs
	mwpointer plhs(*), prhs(*)
! 	To be used with matlabdisp subroutine:
	CHARACTER(LEN=200) :: matlabdispstr
!	Add your own here:
!
! ---------------------------------------------
! Starting code:
	matlabdispstr = 'Your code starts here'
	call matlabdisp(plhs,matlabdispstr)
! ---------------------------------------------

! Your code for the gateway should be here

! ---------------------------------------------
! Ending code:
	matlabdispstr = 'Your code ends here'
	call matlabdisp(plhs,matlabdispstr)
	return
	end
!======================================================================
!
!======================================================================
!	YOUR SUBROUTINES SHOULD BE HERE AFTER
!======================================================================	




