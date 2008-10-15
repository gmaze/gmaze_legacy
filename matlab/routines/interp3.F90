!DEF
!REQ
!
! Created by Gael Forget, 2007
! Modified by Guillaume Maze on 2008-10-06.
! Copyright (c) 2008 Guillaume Maze. 
! http://www.guillaumemaze.org/codes

!
!    This program is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    any later version.
!    This program is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!    You should have received a copy of the GNU General Public License
!    along with this program.  If not, see <http://www.gnu.org/licenses/>.
!


! #############################################################################
	implicit none

! input:         field0 	is the 3D field of size [jpi jpj jpk]
! output:        field3 	is the 3D field of size [jpi jpj jpk]*nb_in

! ifort -O3 -ipo -mp1 -align -convert big_endian -assume byterecl -assume nobuffered_io interp3.F90 -o interp3_ifort

!remarks:	1) WRONG, WORKS BOTH WAYS: where works only for the left side [where(xx.EQ.1) XX=YY does not work]
!		2) cshift works backwards compared with matlab circshift
!		3) same as f77, you need to be careful with int/int ratios
!		4) next step is to do the two other directions... possibly using dyn alloc&fieldTMP/maskTMP
!		4) in matlab version, nb_loop = size(field0,1)+2  nb_loop = size(field0,2)+2

!next steps:
!	1) do the two other directions... possibly using dyn alloc&fieldTMP/maskTMP
!	2) test against a matlab case for T
!	3) do a top level routine to handle the full layer budget, incl. IO ... here => subroutine with arg


!        integer jpi,jpj,jpk,nb_in
!        parameter (jpi=111,jpj=61,jpk=25,nb_in=12)
	real::icur_num,icur_den
	integer icur,jcur,kcur,tcur,test_print
	CHARACTER(LEN=200) :: file_in,file_out

	real,allocatable :: mycst0(:,:,:),field0(:,:,:),mask0(:,:,:)
	real,allocatable :: mycst1(:,:,:),field1(:,:,:),mask1(:,:,:)
    real,allocatable :: mycst2(:,:,:),field2(:,:,:),mask2(:,:,:)
    real,allocatable :: field3(:,:,:)
	integer jpi,jpj,jpk,nb_in,nbI2Out,nb_out

!	real,dimension(jpi,jpj,jpk) 			:: mycst0,field0,mask0
!	real,dimension(jpi*nb_in,jpj,jpk) 		:: mycst1,field1,mask1
!   real,dimension(jpi*nb_in,jpj*nb_in,jpk)       :: mycst2,field2,mask2
!   real,dimension(jpi*nb_in,jpj*nb_in,jpk*nb_in) :: field3
    real,allocatable :: mycstTMP(:,:,:),fieldTMP(:,:,:),maskTMP(:,:,:),mask3(:,:,:)

!	integer,parameter :: jpi=51,jpj=46,jpk=25,nb_in=12,nbIn2Out=3,nb_out=nb_in/nbIn2Out
	read(*,*) jpi
	read(*,*) jpj
	read(*,*) jpk
	read(*,*) nb_in
	read(*,*) file_in
	read(*,*) file_out
	
	allocate(mycst0(jpi,jpj,jpk))
	allocate(field0(jpi,jpj,jpk))
	allocate(mask0(jpi,jpj,jpk))
	allocate(mycst1(jpi*nb_in,jpj,jpk))
	allocate(field1(jpi*nb_in,jpj,jpk))
	allocate(mask1(jpi*nb_in,jpj,jpk))
	allocate(mycst2(jpi*nb_in,jpj*nb_in,jpk))
	allocate(field2(jpi*nb_in,jpj*nb_in,jpk))
	allocate(mask2(jpi*nb_in,jpj*nb_in,jpk))	
	allocate(field3(jpi*nb_in,jpj*nb_in,jpk*nb_in))
	
!	print*,jpi,jpj,jpk
!	print*,nb_in
!	print*,file_in
!	print*,trim(file_out)

	test_print=0

!step 1: input fields
!	field0=0
!       field0(2:jpi-1,2:jpj-1,2:jpk-1)=2
!	field0(3:jpi-2,3:jpj-2,3:jpk-2)=3

	open(unit=11,file=trim(file_in),form ='unformatted',ACTION='READ',status='old', access='direct',recl=jpi*jpj*jpk*4 )
	read(11,rec=1) field0
	close(11)

    mask0=0.
	mycst0=1.
	where(field0.NE.-9999.) mask0=mycst0
	mycst0=0.
	where(field0.EQ.-9999.) field0=mycst0

!step 2.1: add u points
	allocate(mycstTMP(jpi*2,jpj,jpk),fieldTMP(jpi*2,jpj,jpk),maskTMP(jpi*2,jpj,jpk))
	fieldTMP=0.
        maskTMP=0.

        fieldTMP(2:2*jpi:2,:,:)=field0
        fieldTMP(1:2*jpi-1:2,:,:)=field0+cshift(field0,-1,1)
        maskTMP(2:2*jpi:2,:,:)=mask0
        maskTMP(1:2*jpi-1:2,:,:)=mask0+cshift(mask0,-1,1)

	where(maskTMP.GT.0.) fieldTMP=fieldTMP/maskTMP
	mycstTMP=1.
        where(maskTMP.GT.0.) maskTMP=mycstTMP
	mycstTMP=0.
	where(maskTMP.EQ.0.) fieldTMP=mycstTMP
	where(maskTMP.EQ.0.) maskTMP=mycstTMP

!step 2.2: interpolate
        mask1=0.
        field1=0.
        icur_den=nb_in
        do icur=1,nb_in/2
	icur_num=1+(icur-1)*2
	field1(icur:nb_in*jpi:nb_in/2,:,:)=field1(icur:nb_in*jpi:nb_in/2,:,:)+(1.-icur_num/icur_den)*fieldTMP
	field1(icur:nb_in*jpi:nb_in/2,:,:)=field1(icur:nb_in*jpi:nb_in/2,:,:)+icur_num/icur_den*cshift(fieldTMP,1,1)
	mask1(icur:nb_in*jpi:nb_in/2,:,:)=mask1(icur:nb_in*jpi:nb_in/2,:,:)+(1.-icur_num/icur_den)*maskTMP
	mask1(icur:nb_in*jpi:nb_in/2,:,:)=mask1(icur:nb_in*jpi:nb_in/2,:,:)+icur_num/icur_den*cshift(maskTMP,1,1)
        enddo

	where(mask1.GT.0.99) field1=field1/mask1
	mycst1=1.
        where(mask1.GT.0.99) mask1=mycst1
	mycst1=0.
        where(mask1.LE.0.99) field1=mycst1
        where(mask1.LE.0.99) mask1=mycst1

if (test_print.EQ.1) then        
        print*,"step2.2"
        print*,'X1',field0(:,3,3)
        print*,'X3',field1(:,3,3)
endif

deallocate(mycstTMP,fieldTMP,maskTMP)

!step 3.1: add v points
allocate(mycstTMP(jpi*nb_in,jpj*2,jpk),fieldTMP(jpi*nb_in,jpj*2,jpk),maskTMP(jpi*nb_in,jpj*2,jpk))
        fieldTMP=0.
        maskTMP=0.

        fieldTMP(:,2:2*jpj:2,:)=field1
        fieldTMP(:,1:2*jpj-1:2,:)=field1+cshift(field1,-1,2)
        maskTMP(:,2:2*jpj:2,:)=mask1
        maskTMP(:,1:2*jpj-1:2,:)=mask1+cshift(mask1,-1,2)

        where(maskTMP.GT.0.) fieldTMP=fieldTMP/maskTMP
	mycstTMP=1.
        where(maskTMP.GT.0.) maskTMP=mycstTMP
	mycstTMP=0.
        where(maskTMP.EQ.0.) fieldTMP=mycstTMP
        where(maskTMP.EQ.0.) maskTMP=mycstTMP

!step 3.2: interpolate
        mask2=0.
        field2=0.
        icur_den=nb_in
        do icur=1,nb_in/2
	icur_num=1+(icur-1)*2
	field2(:,icur:nb_in*jpj:nb_in/2,:)=field2(:,icur:nb_in*jpj:nb_in/2,:)+(1.-icur_num/icur_den)*fieldTMP
	field2(:,icur:nb_in*jpj:nb_in/2,:)=field2(:,icur:nb_in*jpj:nb_in/2,:)+icur_num/icur_den*cshift(fieldTMP,1,2)
	mask2(:,icur:nb_in*jpj:nb_in/2,:)=mask2(:,icur:nb_in*jpj:nb_in/2,:)+(1.-icur_num/icur_den)*maskTMP
	mask2(:,icur:nb_in*jpj:nb_in/2,:)=mask2(:,icur:nb_in*jpj:nb_in/2,:)+icur_num/icur_den*cshift(maskTMP,1,2)
        enddo

        where(mask2.GT.0.99) field2=field2/mask2
	mycst2=1.
        where(mask2.GT.0.99) mask2=mycst2
	mycst2=0.
        where(mask2.LE.0.99) field2=mycst2
        where(mask2.LE.0.99) mask2=mycst2

if (test_print.EQ.1) then
        print*,"step3.2"
        print*,'X1',field1(3*nb_in,:,3)
        print*,'X3',field2(3*nb_in,:,3)
endif

deallocate(mycstTMP,fieldTMP,maskTMP)


!step 4.1: add w points
allocate(fieldTMP(jpi*nb_in,jpj*nb_in,jpk*2+1),maskTMP(jpi*nb_in,jpj*nb_in,jpk*2+1))
allocate(mycstTMP(jpi*nb_in,jpj*nb_in,jpk*nb_in),mask3(jpi*nb_in,jpj*nb_in,jpk*nb_in))
!allocate(mycstTMP(jpi*nb_in,jpj*nb_in,jpk*nb_in),field3(jpi*nb_in,jpj*nb_in,jpk*nb_in),mask3(jpi*nb_in,jpj*nb_in,jpk*nb_in))
        fieldTMP=0.
        maskTMP=0.

        fieldTMP(:,:,2:2*jpk:2)=field2
        fieldTMP(:,:,1)=field2(:,:,1)
        fieldTMP(:,:,2*jpk+1)=field2(:,:,jpk)
        fieldTMP(:,:,3:2*jpk-1:2)=field2(:,:,1:jpk-1)+field2(:,:,2:jpk)
        maskTMP(:,:,2:2*jpk:2)=mask2
        maskTMP(:,:,1)=mask2(:,:,1)
        maskTMP(:,:,2*jpk+1)=mask2(:,:,jpk)
        maskTMP(:,:,3:2*jpk-1:2)=mask2(:,:,1:jpk-1)+mask2(:,:,2:jpk)

        where(maskTMP.GT.0.) fieldTMP=fieldTMP/maskTMP
	mycstTMP=1.
        where(maskTMP.GT.0.) maskTMP=mycstTMP
	mycstTMP=0.
        where(maskTMP.EQ.0.) fieldTMP=mycstTMP
        where(maskTMP.EQ.0.) maskTMP=mycstTMP

!step 4.2: interpolate
        mask3=0.
        field3=0.
        icur_den=nb_in
        do icur=1,nb_in/2
	icur_num=1+(icur-1)*2
	field3(:,:,icur:nb_in*jpk:nb_in/2)=field3(:,:,icur:nb_in*jpk:nb_in/2)+(1.-icur_num/icur_den)*fieldTMP(:,:,1:2*jpk)
	field3(:,:,icur:nb_in*jpk:nb_in/2)=field3(:,:,icur:nb_in*jpk:nb_in/2)+icur_num/icur_den*fieldTMP(:,:,2:2*jpk+1)
	mask3(:,:,icur:nb_in*jpk:nb_in/2)=mask3(:,:,icur:nb_in*jpk:nb_in/2)+(1.-icur_num/icur_den)*maskTMP(:,:,1:2*jpk)
	mask3(:,:,icur:nb_in*jpk:nb_in/2)=mask3(:,:,icur:nb_in*jpk:nb_in/2)+icur_num/icur_den*maskTMP(:,:,2:2*jpk+1)
        enddo

        where(mask3.GT.0.99) field3=field3/mask3
	mycstTMP=1.
        where(mask3.GT.0.99) mask3=mycstTMP
	mycstTMP=0.
        where(mask3.LE.0.99) field3=mycstTMP
        where(mask3.LE.0.99) mask3=mycstTMP

	mycstTMP=-9999.
        where(mask3.EQ.0.) field3=mycstTMP

if (test_print.EQ.1) then
        print*,"step4.2"
        print*,'X1',field2(3*nb_in,3*nb_in,:)
        print*,'X3',field3(3*nb_in,3*nb_in,:)
endif

deallocate(mycstTMP,fieldTMP,maskTMP,mask3)

open(unit=11,file=file_out,form ='unformatted',status='new', access='direct',recl=  jpi*jpj*jpk*4*nb_in*nb_in*nb_in )
write(11,rec=1) field3
close(11)


!deallocate(mycstTMP,fieldTMP,maskTMP,mask3,field3)

END
