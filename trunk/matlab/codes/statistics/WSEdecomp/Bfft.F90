	SUBROUTINE FOURT(DATA,NN,NDIM,ISIGN,IFORM,WORK)
	implicit none
	
!     .. Scalar Arguments ..
	INTEGER IFORM,ISIGN,NDIM
!     ..
!     .. Array Arguments ..
	REAL DATA(1),WORK(1)
	INTEGER NN(1)
!     ..
!     .. Local Scalars ..
	REAL DIFI,DIFR,OLDSI,OLDSR,RTHLF,SUMI,SUMR,T2I,T2R,T3I,T3R,T4I,
     +     T4R,TEMPI,TEMPR,THETA,TWOPI,TWOWR,U1I,U1R,U2I,U2R,U3I,U3R,
     +     U4I,U4R,W2I,W2R,W3I,W3R,WI,WR,WSTPI,WSTPR
	INTEGER I,I1,I1MAX,I1RNG,I2,I2MAX,I3,ICASE,ICONJ,IDIM,IDIV,IF,
     +        IFMIN,IFP1,IFP2,IMAX,IMIN,INON2,IPAR,IQUOT,IREM,J,J1,
     +        J1MAX,J1MIN,J2,J2MAX,J2MIN,J2RNG,J3,J3MAX,JMAX,JMIN,K1,K2,
     +        K3,K4,KDIF,KMIN,KSTEP,L,LMAX,M,MMAX,N,NHALF,NP0,NP1,NP1HF,
     +        NP1TW,NP2,NP2HF,NPREV,NTOT,NTWO,NWORK
!     ..
!     .. Local Arrays ..
	INTEGER IFACT(32)
!     ..
!     .. Intrinsic Functions ..
	INTRINSIC COS,MAX0,REAL,SIN
!     ..
!     .. Data statements ..
	DATA NP0/0/,NPREV/0/
	DATA TWOPI/6.2831853071796/,RTHLF/0.70710678118655/
	RETURN
c
c revision history---
c
c january 1978     deleted references to the  *cosy  cards and
c                  added revision history
c-----------------------------------------------------------------------
	END

