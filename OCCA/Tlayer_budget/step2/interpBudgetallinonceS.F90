! COMPUTE THE VOLUME BUDGET FOR EACH TERM, DAILY INTERPOLATING AT 1/12 AND STORING AT 1/4

! Created by Gael Forget and Guillaume Maze on 2008-09-30.
! Copyright (c) 2008 Guillaume Maze. 
! http://codes.guillaumemaze.org

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

! HOW TO COMPILE ?
! module load intel
! ifort -O3 -ipo -mp1 -align -convert big_endian -assume byterecl -assume nobuffered_io interpBudgetallinonceS.F90 -o intBdgS_ifort_1619

!
	MODULE mysizes
	IMPLICIT NONE

! KESS REGION: subdomain = [130 180 90 135 1 25]; % Western Pacific, original version (too short west, cut the gyre)
!	integer,parameter :: jpi=51,jpj=46,jpk=25,nb_in=12,nbIn2Out=3,nb_out=nb_in/nbIn2Out

! KESS REGION EXT: 	subdomain = [122 180 90 130 1 25]; 
!	integer,parameter :: jpi=59,jpj=41,jpk=25,nb_in=12,nbIn2Out=3,nb_out=nb_in/nbIn2Out

! KESS REGION EXT: 	subdomain = [150 180 100 120 1 25]; 
!	integer,parameter :: jpi=31,jpj=21,jpk=25,nb_in=12,nbIn2Out=3,nb_out=nb_in/nbIn2Out

! KESS REGION EXT: 	subdomain = [110 260 90 147 1 25]; % Whole North Pacific
!	integer,parameter :: jpi=151,jpj=58,jpk=25,nb_in=12,nbIn2Out=3,nb_out=nb_in/nbIn2Out
!	integer,parameter :: jpi=151,jpj=58,jpk=25,nb_in=4,nbIn2Out=2,nb_out=nb_in/nbIn2Out

! WESTERN PACIFIC: 	subdomain = [185   260    90   147     1    25]; 
!	integer,parameter :: jpi=76,jpj=58,jpk=25,nb_in=12,nbIn2Out=3,nb_out=nb_in/nbIn2Out
	
! EASTERN PACIFIC: 	subdomain = [111   185    90   147     1    25]; 
	integer,parameter :: jpi=75,jpj=58,jpk=25,nb_in=12,nbIn2Out=3,nb_out=nb_in/nbIn2Out

! TEMPERATURE BIN TO DEFINE A CLASS AS: THETA-BIN_CUR/2 < THETA < THETA+BIN_CUR/2	
	real,parameter :: bin_cur=0.25
	END MODULE mysizes

	PROGRAM interpBdgALLinONCE
	use mysizes
	implicit none

	integer :: icur,jcur,kcur,lcur,tcur,lcur1,lcur2
	real,allocatable :: fieldCUR(:,:,:)
    real,allocatable :: field0(:,:,:),field1(:,:,:),field2(:,:,:),field3(:,:,:)
	real,dimension(jpi*nb_out,jpj*nb_out,jpk*nb_out) :: cumfieldMR,fieldMR
	CHARACTER(LEN=200) :: file_in,file_out,file_theta,file_out2,file_time
	CHARACTER(LEN=50) :: file_cur
	integer :: iter0,iter1,fcur,ifil_cur,dsc
	CHARACTER(LEN=200) :: lrf_path
	CHARACTER(LEN=200) :: tmp_path
	real :: THETAlow,THETAhig,cumfield
	integer,allocatable :: timetokeep(:)
	logical :: notenteredtheloop,dorecord
	INTEGER :: idate0(8),idate1(8),idate2(8)
	real :: myT

! ############################################################################# BEGIN SETUP	
print*,'*******************************************************************'

! DO WE REALY RECORD THE OUTPUT ?
dorecord=.FALSE.
dorecord=.TRUE.

! LOOPS PARAMETERS:
iter0 = 1
iter1 = 1099

! WHICH FILE TO PROCESS:
print*, ' 1- LRvol.3yV2adv.bin '
print*, ' 2- LRtheta.3yV2adv.bin (NOT OK)'
print*, ' 3- LRadvTOT.3yV2adv.bin '
print*, ' 4- LRdiffTOT.3yV2adv.bin '
print*, ' 5- LRairsea3D.3yV2adv.bin '
print*, ' 6- LRtendNATIVE.3yV2adv.bin '
print*, ' 7- LRtendARTIF.3yV2adv.bin '
print*, ' 8- LRallotherTOT.3yV2adv.bin '
print*, ' 9- LRadvX.3yV2adv.bin '
print*, '10- LRadvY.3yV2adv.bin '
print*, '11- LRadvZ.3yV2adv.bin '
print*, '12- LRdifX.3yV2adv.bin '
print*, '13- LRdifY.3yV2adv.bin '
print*, '14- LRdifZ.3yV2adv.bin '
print*, '15- LRdifIZ.3yV2adv.bin '
print*, '16- LRghat.3yV2adv.bin '
print*, '-> Which file to process ?'
read(*,*) ifil_cur
!ifil_cur = 6

! TIME AXIS:
print*, ' => Please enter the path with the time axis file:'
read(*,*) file_time
print*, 'OK, we will use this file:',trim(file_time)

! INPUT DIRECTORY:
print*,' => Please enter the path to find input low-res files:'
read(*,*) lrf_path
print*, 'OK, we will get input from:',trim(lrf_path)

! OUPUT DIRECTORY:
print*,' => Please enter the path to store output files:'
read(*,*) tmp_path
print*, 'OK, we will print out there:',trim(tmp_path)

! To print some stuff on screen
dsc = 1 

! TEMPERATURE FILE TO FIND THE LAYERS DEFINITION:
write (file_cur,'(A)') 'LRtheta.3yV2adv.bin'
write (file_theta,'(2A)') trim(lrf_path),file_cur

! LAYER TEMPERATURE DEFINITION:
THETAlow = 16.
THETAhig = 19.

! HERE WE READ THE INDICES OF THE TIMESERIE TO KEEP INTO THE COMPUTATION:
! (SEE CREATE_TIMELINE.M MATLAB SCRIPT TO CREATE SUCH A FILE)
! TO DO: INCORPORATE INTO THE FORTRAN ROUTINE 
allocate(timetokeep(1+(iter1-iter0)))
open(unit=11,file=file_time,form ='unformatted',status='old', access='direct',recl=4*(1+(iter1-iter0)))
read(11,rec=1) timetokeep
close(11)
!if (dsc.EQ.1) print*,'USE THIS TIME LINE: ',file_time



! ############################################################################# END SETUP
if (1.EQ.1) then

if (dsc.EQ.1) then
	 print*,'Compute budget for the layer: ',THETAlow,THETAhig
	 print*,' and for iterations:',iter0,'TO:',iter1
	 print*,' Record results (T/F):',dorecord
endif

! BEGIN LOOP OVER FILE
! #############################################################################
!do fcur=ifil_cur,ifil_cur
do fcur=ifil_cur,ifil_cur
	print*,'*******************************************************************'

	! DEFINE INPUT FILE OF A BUDGET TERM (FILE_CUR) 
	select case (fcur)
		case (1)
			write (file_cur,'(A)') 'LRvol.3yV2adv.bin' ! WILL COMPUTE THE VOLUMETRIC CENSUS OF THE LAYER
		case (2)
			write (file_cur,'(A)') 'LRtheta.3yV2adv.bin'	! WILL COMPUTE THE MEAN TEMPERATURE OF THE LAYER
		case (3)
			write (file_cur,'(A)') 'LRadvTOT.3yV2adv.bin'
		case (4)
			write (file_cur,'(A)') 'LRdiffTOT.3yV2adv.bin'
		case (5)
			write (file_cur,'(A)') 'LRairsea3D.3yV2adv.bin'
		case (6)
			write (file_cur,'(A)') 'LRtendNATIVE.3yV2adv.bin'
		case (7)
			write (file_cur,'(A)') 'LRtendARTIF.3yV2adv.bin'
		case (8)
			write (file_cur,'(A)') 'LRallotherTOT.3yV2adv.bin'
		case (9)
			write (file_cur,'(A)') 'LRadvX.3yV2adv.bin'
		case (10)
			write (file_cur,'(A)') 'LRadvY.3yV2adv.bin'
		case (11)
			write (file_cur,'(A)') 'LRadvZ.3yV2adv.bin'
		case (12)
			write (file_cur,'(A)') 'LRdifX.3yV2adv.bin'
		case (13)
			write (file_cur,'(A)') 'LRdifY.3yV2adv.bin'
		case (14)
			write (file_cur,'(A)') 'LRdifZ.3yV2adv.bin'
		case (15)
			write (file_cur,'(A)') 'LRdifIZ.3yV2adv.bin'
		case (16)
			write (file_cur,'(A)') 'LRghat.3yV2adv.bin'
	end select
	write (file_in,'(2A)') trim(lrf_path),file_cur
	if (dsc.EQ.1) print*,'Processing: ',file_cur
		
	! DEFINE OUTPUT FILES (MAPS AND TIMESERIES INTO FILE_OUT AND FILE_OUT2)
	write (file_out,'(2A,i4.4,A,i4.4,A,F0.0,A,F0.0,2A)') trim(tmp_path),'InterpALLonce_',iter0,'_',iter1,'_',THETAlow,'m',THETAhig,'_',file_cur
	write (file_out2,'(2A,i4.4,A,i4.4,A,F0.0,A,F0.0,2A)') trim(tmp_path),'InterpALLonce_',iter0,'_',iter1,'_',THETAlow,'m',THETAhig,'_timeseries_',file_cur
!	write (file_out,'(2A,i4.4,A,i4.4,2A)') trim(tmp_path),'InterpALLonce_',iter0,'_',iter1,'_16m18_',file_cur	
!	write (file_out2,'(2A,i4.4,A,i4.4,2A)') trim(tmp_path),'InterpALLonce_',iter0,'_',iter1,'_16m18_timeseries_',file_cur

	! CREATE OUTPUT FILES (FILE_OUT AND FILE_OUT2) AND FILL WITH ZEROS
	cumfieldMR=0.
	cumfield = 0.
	if (dorecord) then
		open(unit=11,file=file_out,form ='unformatted',status='new', access='direct',recl=jpi*jpj*jpk*4*nb_out*nb_out*nb_out )
		write(11,rec=1) cumfieldMR
		close(11)
		open(unit=11,file=file_out2,form ='unformatted',status='new', access='direct',recl= 4 )
		write(11,rec=1+(iter1-iter0)) cumfield
		close(11)	
	endif
	! USE TO INITIALISE VARIABLE THE FIRST TIME WE ENTERED THE TIME LOOP:
	notenteredtheloop= .TRUE.
! ==============================================================================
! BEGIN LOOP OVER TIME (TCUR)
do tcur=iter0,iter1
	
if (timetokeep(tcur).EQ.1) then
	CALL DATE_AND_TIME(VALUES=idate0) ! Start loop timing		
	
	
	! SOME SCREEN PRINTING:	
	if (dsc.EQ.1) then
	!	write(*,'(A,A,I3,A,F5.2)') trim(file_cur)," # ITER = ",tcur,' # Etime it-1:it = ',myT			
	endif
	print*,						 '#######################'
	write(*,'(A,I4,A,A,A,F5.2)') ' # ITER = ',tcur,' # ',trim(file_cur),' # Etime it-1:it = ',myT
	
	! ALLOCATE ARRAYS:
	if (notenteredtheloop) then
		allocate(fieldCUR(jpi*nb_in,jpj*nb_in,jpk*nb_in))
		allocate(field1(jpi*nb_in,jpj*nb_in,jpk*nb_in))
		allocate(field2(jpi*nb_in,jpj*nb_in,jpk*nb_in))
		allocate(field0(jpi*nb_in,jpj*nb_in,jpk*nb_in))
		allocate(field3(jpi*nb_in,jpj*nb_in,jpk*nb_in))
		if (fcur.GE.3) then
			lcur1=1
		else
			lcur1=0
		endif
	endif	
	
	if (dsc.EQ.1) print*,'   => Begin the interpolation and the layer definition'
	CALL DATE_AND_TIME(VALUES=idate1) ! Start timing
	
	! INTERPOLATE THE TEMPERATURE FIELD:
	call interpMyField(file_theta,tcur,fieldCUR)
	
	! -------------------------------------------------------------------
	! THEN FIND LAYERS DEFINITIONS AND PUT THEM IN:
	! IF LCUR=0 ONLY: FIELD0 IS : THETALOW < THETA < THETAHIG
	! IF LCUR=1,2:    FIELD0 IS : THETALOW-BIN_CUR/2 < THETA < THETALOW+BIN_CUR/2
	!                 FIELD3 IS : THETAHIG-BIN_CUR/2 < THETA < THETAHIG+BIN_CUR/2
	! GET THE LAYER:
	field0=0
	field2=1
	if (lcur1.EQ.0) then
		where((fieldCUR.GE.THETAlow).AND.(fieldCUR.LE.THETAhig)) field0=field2
	else
		where((fieldCUR.GE.THETAlow-bin_cur/2.).AND.(fieldCUR.LE.THETAlow+bin_cur/2.)) field0=-field2			
		where((fieldCUR.GE.THETAhig-bin_cur/2.).AND.(fieldCUR.LE.THETAhig+bin_cur/2.)) field0=field2
	endif
	
	! ...........................................................
	! ensure continuity of interface layers:
	if (lcur1.EQ.1) then
	do icur=-1,1
		do jcur=-1,1
			do kcur=-1,1
				! sufficient ...
				if (abs(icur)+abs(jcur)+abs(kcur).EQ.1) then
				!... or thicken the layer some more if (abs(icur)+abs(jcur)+abs(kcur).GT.0) then
					field1=cshift(fieldCUR,icur,1)
					field2=cshift(field1,jcur,2)
					field1=cshift(field2,kcur,3)
					if (kcur.EQ.1) field1(:,:,jpk*nb_in)=-9999.
					if (kcur.EQ.-1) field1(:,:,1)=-9999.
					field2=1 
						where((field1.GE.THETAlow).AND.(fieldCUR.LT.THETAlow).AND.(fieldCUR.NE.-9999.).AND.(field1.NE.-9999.)) field0=-field2
						where((field1.LE.THETAhig).AND.(fieldCUR.GT.THETAhig).AND.(fieldCUR.NE.-9999.).AND.(field1.NE.-9999.)) field0=field2
				endif
			enddo
		enddo
	enddo
	endif
	! ...........................................................

	field2=-9999.
	where(fieldCUR.EQ.-9999.) field0=field2	

	! -------------------------------------------------------------------
	! INTERPOLATE THE TERM TO INTEGRATE:
	call interpMyField(file_in,tcur,fieldCUR)
	call myetime(idate1,idate2,myT) ! Stop timing
	if (dsc.eq.1) print*,'   => Etime(s)=',myT
	
	if (dsc.EQ.1) print*,'   => All interpolations and layers definition done, now compute the budget...'		
	CALL DATE_AND_TIME(VALUES=idate1) ! Start timing
	! -------------------------------------------------------------------
	! NOW COMPUTE TERMS TO BE INTEGRATED OR CUMSUMED
	if (fcur.EQ.1) then
		! For volume elements: simple volume integrals:	
		where (fieldCUR.NE.-9999.) fieldCUR = fieldCUR*field0/365./1000000./86400/nb_in/nb_in/nb_in
		if (dsc.EQ.1) print*,'   => Would be reccorded VOL=',sum(fieldCUR, MASK = fieldCUR.NE.-9999.)
		cumfield = sum(fieldCUR, MASK = fieldCUR.NE.-9999.)
		
	elseif (fcur.EQ.2) then
		!!!!!! NOT WORKING RIGHT NOW !!!!!!
		! For temperature: simple mean value over the layer:
		where (fieldCUR.NE.-9999.) field0   = field0/nb_in/nb_in/nb_in	
		where (fieldCUR.NE.-9999.) fieldCUR = fieldCUR*field0
		if (dsc.EQ.1) print*,'   => Would be reccorded [THETA]=',&
			sum(fieldCUR,MASK = fieldCUR.NE.-9999.)/sum(field0,MASK = fieldCUR.NE.-9999.),&
			sum(fieldCUR,MASK = fieldCUR.NE.-9999.),&
			sum(field0,MASK   = fieldCUR.NE.-9999.)
		cumfield = sum(fieldCUR,MASK = fieldCUR.NE.-9999.)/sum(field0,MASK = fieldCUR.NE.-9999.)
		
	else
		! BUDGET TERMS (FORMATION RATES)
		where (fieldCUR.NE.-9999.) fieldCUR = (fieldCUR*field0)/bin_cur/365./1000000./nb_in/nb_in/nb_in
		! CUMULATIVE SUM FOR THE TIMESERIE:
		cumfield = cumfield + sum(fieldCUR,MASK = fieldCUR.NE.-9999.)
		if (dsc.EQ.1) print*,'   => Would be reccorded M(int(div(flux)))=',cumfield
	endif
	! -------------------------------------------------------------------
	
	! FINALY STORE INTO CUMFIELD THE 3D MAP AVERAGED TO MEDIUM RES.:
	if (notenteredtheloop) cumfieldMR = 0.
	fieldMR = 0.
	call aveMyField(fieldCUR,fieldMR,0)
	where (fieldMR.NE.-9999.) cumfieldMR = cumfieldMR + fieldMR
		
	! AND RECORD THE INTEGRATED VALUE IN THE TIMESERIE:	
	if (dorecord) then
		open(unit=11,file=file_out2,form ='unformatted',status='old', access='direct',recl=4)
		write(11,rec=1+(tcur-iter0)) cumfield
		close(11)
	endif
	
	! USE TO INITIALISE VARIABLE THE FIRST TIME WE ENTERED THE TIME LOOP:	
	notenteredtheloop = .FALSE.
	
	call myetime(idate1,idate2,myT) ! Stop timing
	if (dsc.eq.1) print*,'   => Etime(s)=',myT
    call myetime(idate0,idate1,myT) ! Stop loop timing
endif 

enddo	
! ==============================================================================

! AT THE END OF THE TIMESERIE, WE RECORD THE CUMULATED SUM OF THE 3D MAP AVERAGED TO MEDIUM RES.:
if (dorecord) then
	open(unit=11,file=file_out,form ='unformatted',status='old', access='direct',recl=jpi*jpj*jpk*4*nb_out*nb_out*nb_out )
	write(11,rec=1) cumfieldMR
	close(11)
endif

enddo
! #############################################################################
deallocate(fieldCUR,field1,field2,field0,field3)
		
endif

print*,'*******************************************************************'
print*,'PROGRAM TERMINATED CORRECTLY'







! #############################################################################
! #############################################################################
! ################# END OF THE MAIN PROGRAM  ##################################
! #############################################################################
! #############################################################################








	! #############################################################################
		CONTAINS

	! #############################################################################
		SUBROUTINE myetime(d0,d1,elapsedtime)
		implicit none
		!	VALUES(1)	    holds the year. 
		!	VALUES(2)	    holds the month 
		!	VALUES(3)	    holds the day of the month 
		!	VALUES(4)	    holds the time difference with respect to UTC 
		!	VALUES(5)	    holds the hour of the day 
		!	VALUES(6)	    holds the minutes of the hour 
		!	VALUES(7)	    holds the seconds in the minute 
		!	VALUES(8)	    holds the milliseconds of the second, in the range 0 to 999

		real::elapsedtime
		INTEGER :: d0(8),d1(8)

		CALL DATE_AND_TIME(VALUES=d1)
	!		print*,d0(5:8)
	!		print*,d1(5:8)
		elapsedtime = (d1(8)-d0(8))/1e3+(d1(7)-d0(7))+(d1(6)-d0(6))*60+(d1(5)-d0(5))*60*60


		END SUBROUTINE


	! #############################################################################
		SUBROUTINE aveMyField(field_in,field_out,AveOrTot)
	! #############################################################################
		use mysizes
		implicit none

	    real,dimension(jpi*nb_in,jpj*nb_in,jpk*nb_in) :: field_in
	    real,dimension(jpi*nb_out,jpj*nb_out,jpk*nb_out) :: mycst,field_out,mask_out,fieldTMP,maskTMP
		integer :: icur,jcur,kcur,AveOrTot


		mask_out=0
		field_out=0
		maskTMP=1
		do icur=1,nbIn2Out
			do jcur=1,nbIn2Out
				do kcur=1,nbIn2Out
					fieldTMP=field_in(icur:jpi*nb_in:nbIn2Out,jcur:jpj*nb_in:nbIn2Out,kcur:jpk*nb_in:nbIn2Out)
					where(fieldTMP.NE.-9999.) field_out=field_out+fieldTMP
					where(fieldTMP.NE.-9999.) mask_out=mask_out+maskTMP
				enddo
			enddo
		enddo
		if (AveOrTot.EQ.1) field_out=field_out/mask_out
		mycst=-9999.
		where(mask_out.EQ.0) field_out=mycst

		END SUBROUTINE


	! #############################################################################
		SUBROUTINE interpMyField(file_in,tcur,field3)
	! #############################################################################
		use mysizes
		implicit none

	! input:         field0 	is the 3D field of size [jpi jpj jpk]
	! output:        field3 	is the 3D field of size [jpi jpj jpk]*nb_in

	! to compile:	pgf90 -mcmodel=medium -byteswapio interpMyField.F90 -o interpMyField
	!		pgf90 -fastsse -O3 -mcmodel=medium -byteswapio interpMyField.F90 -o interpMyField

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

		real,dimension(jpi,jpj,jpk) 			:: mycst0,field0,mask0
		real,dimension(jpi*nb_in,jpj,jpk) 		:: mycst1,field1,mask1
	    real,dimension(jpi*nb_in,jpj*nb_in,jpk)       :: mycst2,field2,mask2
	    real,dimension(jpi*nb_in,jpj*nb_in,jpk*nb_in) :: field3
	    real,allocatable :: mycstTMP(:,:,:),fieldTMP(:,:,:),maskTMP(:,:,:),mask3(:,:,:)

		test_print=0

	!step 1: input fields
	!	field0=0
	!       field0(2:jpi-1,2:jpj-1,2:jpk-1)=2
	!	field0(3:jpi-2,3:jpj-2,3:jpk-2)=3

	open(unit=11,file=file_in,form ='unformatted',ACTION='READ',status='old', access='direct',recl=  jpi*jpj*jpk*4 )
	read(11,rec=tcur) field0
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

	!open(unit=11,file=file_out,form ='unformatted',status='unknown', access='direct',recl=  jpi*jpj*jpk*4*nb_in*nb_in*nb_in )
	!write(11,rec=1) field3
	!close(11)


	!deallocate(mycstTMP,fieldTMP,maskTMP,mask3,field3)

		END SUBROUTINE
END


	
	
	
	
	
