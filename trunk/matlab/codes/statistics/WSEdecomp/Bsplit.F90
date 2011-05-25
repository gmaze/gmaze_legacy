! 
! DECOMP(SIGNAL,NT,NX,DT,DX,FILTER,SIGNALW,SIGNALS,SIGNALE)
! 
! This subroutine splits the matrix SIGNAL(NT,NX) into its 
! upward/stationary/downward components:
! SIGNALW(NT,NX), SIGNALS(NT,NX) and SIGNALE(NT,NX), 
! given space/time resolutions DX/DT.
! Parameter FILTER is a 4 real values matrix containing the
! space and time limits in order to do a filtering:
! FILTER(XMIN,XMAX,TMIN,TMAX)
! The methos used is a 2D Fourier analysis (with subroutine 
! FOURT into Bfft.f).
! For more details, check:
! http://scripts.mit.edu/~gmaze/blog/?page_id=124
! 
! Guillaume MAZE 
! 2004, gmaze@mit.edu
! Rev. by Guillaume Maze on 2009-09-29: created Fortran90 version
! 
! Bibliography: 
! Park, Y.-H. (1990).
!   Mise en evidence d'ondes planetaires semi-annuelles 
!   baroclines au sud de l'ocean indien par altimetrie satellitaire.
!   C. R. Acad. Sci. Paris, 310(2):919-926.
!
! Park, Y.-H., Roquet, F., and Vivier, F. (2004).
!   Quasi-stationary enso wave signals versus the antarcti! 
!   circumpolar wave scenario.
!   Geophys. Res. Lett., 31(L09315). 
!
!-------------------------------------------------------------
	subroutine decomp(signal,nt,nx,dt,dx,filter,signalW,signalS,signalE)
!-------------------------------------------------------------
!
	integer nx,nfx,nt,nft
	real   signal(nt,nx),sig(nt,nx)
	real filter(4)
	real signalW(nt,nx),signalS(nt,nx),signalE(nt,nx)
	real  Ck(nt,nx/2), Sk(nt,nx/2)
	real  Ckc(nt/2,nx/2), Cks(nt/2,nx/2)
	real  Skc(nt/2,nx/2), Sks(nt/2,nx/2)
	real Ces,Cec,Cws,Cwc,Aw,Ae,phiw,phie,compo
	real varE,varS,varW
	real MATCes(nt/2,nx/2),MATCec(nt/2,nx/2)
	real MATCws(nt/2,nx/2),MATCwc(nt/2,nx/2)
	real  MATAw(nt/2,nx/2), MATAe(nt/2,nx/2)
	real MATphiw(nt/2,nx/2),MATphie(nt/2,nx/2)
	real tt(nt),xx(nx)
	real omega(nt/2),ca(nx/2),compose(nt/2,nx/2)
	real camin,camax,omegamin,omegamax,xmin,xmax,tmin,tmax
	real dt,dx
	real pi
	real dataX(2,nx),dataT(2,nt)
!
! ------------------------------------------------------
! PARAMETERS
! ------------------------------------------------------

! Initialise indices and matrices
!
	nft=nt/2
	nfx=nx/2
	pi=4*atan(1.)
	do it=1,nt
		tt(it)=(it-1)*dt 
	enddo
	do ix=1,nx
		xx(ix)=(ix-1)*dx
	enddo
	do it=1,nft
		omega(it)=2*pi*(it-1)/dt/nt
	enddo
	do ix=1,nfx
		ca(ix)=2*pi*(ix-1)/dx/nx
	enddo
!
! Eventualy produce a test signal:
	if(0.EQ.1) then
		do it=1,nt
			do ix=1,nx
				signal(it,ix)=4*cos(2*pi/360*2*xx(ix)-2*pi/3*tt(it))
				signal(it,ix)=sig(it,ix)+2*cos(2*pi/360*6*xx(ix)+2*pi/5*tt(it))
			enddo
		enddo
	endif
!
!
! Frequencies (space and time) to be conserved:
	xmin=filter(1)
	xmax=filter(2)
	tmin=filter(3)
	tmax=filter(4)
	camin=2.*pi/xmax
	camax=2.*pi/xmin
	omegamin=2.*pi/tmax
	omegamax=2.*pi/tmin
	do ifx=1,nfx
		do ift=1,nft
			if( (ca(ifx).LE.camax).AND.(ca(ifx).GE.camin).AND.(omega(ift).LE.omegamax).AND.(omega(ift).GE.omegamin) ) then
				compose(ift,ifx) = 1.
			else
				compose(ift,ifx) = 0.
			endif
		enddo
	enddo
	print*,'nt/nx/dt/dx'
	print*,nt,nx,dt,dx
	print*,'xmin/xmax/tmin/tmax'
	print*,xmin,xmax,tmin,tmax
	print*,'camax/camin/omegamax/omegamin'
	print*,camax,camin,omegamax,omegamin
	print*,'omega=',(omega(i),i=1,20)
! 
! ------------------------------------------------------
! ANALYSIS
	print*,'Analyse...'
! ------------------------------------------------------
!
	print*,'Compute spacial coefficients...'
! Coef of FFT in space for each time step:
! ------------------------------------------------------
	do it=1,nt
		do ix=1,nx ! Matrix to be analyse:
			dataX(1,ix)=signal(it,ix)
			dataX(2,ix)=0.
		enddo
		call fourt(dataX,nx,1,-1,0,0) ! Compute the FFT:
		do ifx=1,nfx   ! Get coefs.:
			Ck(it,ifx)= 2.*dataX(1,ifx)/real(nx)
			Sk(it,ifx)=-2.*dataX(2,ifx)/real(nx)
		enddo
		Ck(it,1)=dataX(1,1)/real(nx)
		Sk(it,1)=0.
	enddo
!
	print*,'Compute temporal coefficients...'
! Coef of FFT in time of space-coef:
! ------------------------------------------------------
	do ifx=1,nfx
		! For coef Ck:
		do it=1,nt
			dataT(1,it)=Ck(it,ifx)
			dataT(2,it)=0.
		enddo
		call fourt(dataT,nt,1,-1,0,0)
		do ift=1,nft
			Ckc(ift,ifx)= 2.*dataT(1,ift)/real(nt)
			Cks(ift,ifx)=-2.*dataT(2,ift)/real(nt)
		enddo
		Ckc(1,ifx)=dataT(1,ift)/real(nt)
		Cks(1,ifx)=0.
		! For coef Sk:
		do it=1,nt
			dataT(1,it)=Sk(it,ifx)
			dataT(2,it)=0.
		enddo
		call fourt(dataT,nt,1,-1,0,0)
		do ift=1,nft
			Skc(ift,ifx)= 2.*dataT(1,ift)/real(nt)
			Sks(ift,ifx)=-2.*dataT(2,ift)/real(nt)
		enddo
		Skc(1,ifx)=dataT(1,ift)/real(nt)
		Sks(1,ifx)=0.
	enddo
!
!
! Coef of cos/sin for down/up-ward directions
! Amplitude and phase of components down/up
! ------------------------------------------------------
	print*,'Matrices of amplitudes and phases...'
	do ift=1,nft
		do ifx=1,nfx
			MATCes(ift,ifx)=(Skc(ift,ifx)-Cks(ift,ifx))/2.
			MATCws(ift,ifx)=(Cks(ift,ifx)+Skc(ift,ifx))/2.
			MATCec(ift,ifx)=(Ckc(ift,ifx)+Sks(ift,ifx))/2.
			MATCwc(ift,ifx)=(Ckc(ift,ifx)-Sks(ift,ifx))/2.
			MATAw(ift,ifx)=sqrt(MATCws(ift,ifx)**2+MATCwc(ift,ifx)**2)
			MATAe(ift,ifx)=sqrt(MATCes(ift,ifx)**2+MATCec(ift,ifx)**2)
			MATphiw(ift,ifx)=atan2(MATCws(ift,ifx),MATCwc(ift,ifx))
			MATphie(ift,ifx)=atan2(MATCes(ift,ifx),MATCec(ift,ifx))
		enddo
	enddo
!
! Reconstruction of splited signals
! ------------------------------------------------------
	print*,'Reconstruct the signal...'
	do ix=1,nx
		print*,ix,'/',nx
		do it=1,nt
			! Values of each components for a peculiar point:
			varE=0.
			varS=0.
			varW=0.
			! Sum over wavenumbers and frequencies:
			do ifx=1,nfx
				do ift=1,nft
					! Variables allocation:
					phiw=MATphiw(ift,ifx)
					phie=MATphie(ift,ifx)
					Ae=MATAe(ift,ifx)
					Aw=MATAw(ift,ifx)
					compo=compose(ift,ifx)
					! Phase of the stationary wave:
					pxt1=ca(ifx)*xx(ix)   -0.5*(phiw+phie)
					pxt2=omega(ift)*tt(it)-0.5*(phiw-phie)
					if (Aw.GT.Ae) then  ! If upward higher than downward
						! upward wave phase:
						pxt3 =   ca(ifx)*xx(ix) + omega(ift)*tt(it) - phiw
						! the signal:
						varS = varS + compo*2*Ae*cos(pxt1)*cos(pxt2)
						varW = varW + compo*((Aw-Ae)*cos(pxt3))
					else ! otherwise downward higher than upward
						! downward wave phase:
						pxt3 =   ca(ifx)*xx(ix) - omega(ift)*tt(it) - phie
						! the signal:
						varS = varS + compo*2*Aw*cos(pxt1)*cos(pxt2)
						varE = varE + compo*((Ae-Aw)*cos(pxt3))
					endif
				enddo !ift
			enddo !ifx
			! the signal reconstructed in it,ix:
			signalW(it,ix)=varW
			signalS(it,ix)=varS
			signalE(it,ix)=varE
		enddo !it
	enddo !ix
!
	return
	end
! 
