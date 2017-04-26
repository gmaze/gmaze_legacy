!DEF Compute pycnocline depth
!REQ
! HOW TO COMPILE ?
! g95 minmax.F90 -o minmax_g95
!
! Copyright (c) 2014, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
! For more information, see the http://codes.guillaumemaze.org
! Created: 2014-06-18 (G. Maze)

! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:
! 	* Redistributions of source code must retain the above copyright notice, this list of 
! 	conditions and the following disclaimer.
! 	* Redistributions in binary form must reproduce the above copyright notice, this list 
! 	of conditions and the following disclaimer in the documentation and/or other materials 
! 	provided with the distribution.
! 	* Neither the name of the Ifremer, Laboratoire de Physique des Oceans nor the names of its contributors may be used 
!	to endorse or promote products derived from this software without specific prior 
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
	program minmax
	implicit none
	
	! User data:
	real,allocatable,dimension(:) :: d,zd,dclean
	integer :: nzd
	
	! Internal vertical axis parameters:
	real,parameter :: dz=-5,zmax=-5000;
	real,allocatable,dimension(:) :: zr
	integer :: nz
	
	! smoothing parameters:
	real,parameter :: sscale=50

	! Misc variables:
	integer :: ik
	logical :: debug=.false.

! #############################################################################
print*,'*******************************************************************'
! CREATE VERTICAL AXIS Z, negative, downward: [0:DZ<0:ZMAX<0]
nz = zmax/dz+1
allocate(zr(nz))
do ik=1,nz
	zr(ik) = (ik-1)*dz
enddo
!print*,zr

! PRE-PROCESSING OF THE PROFILE
! Remove NaNs out of the input data:
allocate(dclean(nzd))
do ik=1,nzd
	if (isnan(d(ik))) then
	else
	end if
enddo

! iz = find(~isnan(data));
! dclean = data(iz);
! zclean = dpth(iz);

! n2a = interp1(zclean,dclean,zr);

! izOKa = find(~isnan(n2a),1,'first');
! n2a(1:izOKa) = n2a(izOKa);

! izOKb = find(~isnan(n2a),1,'last');
! n2a(izOKb:nz) = n2a(izOKb);



! #############################################################################
deallocate(zr)

print*,'*******************************************************************'
print*,'PROGRAM TERMINATED CORRECTLY'

! #############################################################################
! #############################################################################
! ################# END OF THE MAIN PROGRAM  ##################################
! #############################################################################
! #############################################################################
END