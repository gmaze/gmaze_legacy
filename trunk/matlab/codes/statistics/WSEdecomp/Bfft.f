	SUBROUTINE FOURT(DATA,NN,NDIM,ISIGN,IFORM,WORK)
	implicit none
c
c
c     the cooley-tukey fast fourier transform in usasi basic fortran
c
c     transform(j1,j2,,,,) = sum(data(i1,i2,,,,)*w1**((i1-1)*(j1-1))
c                                 *w2**((i2-1)*(j2-1))*,,,),
c     where i1 and j1 run from 1 to nn(1) and w1=exp(isign*2*pi=
c     sqrt(-1)/nn(1)), etc.  there is no limit on the dimensionality
c     (number of subscripts) of the data array.  if an inverse
c     transform (isign=+1) is performed upon an array of transformed
c     (isign=-1) data, the original data will reappear.
c     multiplied by nn(1)*nn(2)*,,,  the array of input data must be
c     in complex format.  however, if all imaginary parts are zero (i.e.
c     the data are disguised real) running time is cut up to forty per-
c     cent.  (for fastest transform of real data, nn(1) should be even.)
c     the transform values are always complex and are returned in the
c     original array of data, replacing the input data.  the length
c     of each dimension of the data array may be any integer.  the
c     program runs faster on composite integers than on primes, and is
c     particularly fast on numbers rich in factors of two.
c
c     timing is in fact given by the following formula.  let ntot be the
c     total number of points (real or complex) in the data array, that
c     is, ntot=nn(1)*nn(2)*...  decompose ntot into its prime factors,
c     such as 2**k2 * 3**k3 * 5**k5 * ...  let sum2 be the sum of all
c     the factors of two in ntot, that is, sum2 = 2*k2.  let sumf be
c     the sum of all other factors of ntot, that is, sumf = 3*k3*5*k5*..
c     the time taken by a multidimensional transform on these ntot data
c     is t = t0 + ntot*(t1+t2*sum2+t3*sumf).  on the cdc 3300 (floating
c     point add time = six microseconds), t = 3000 + ntot*(600+40*sum2+
c     175*sumf) microseconds on complex data.
c
c     implementation of the definition by summation will run in a time
c     proportional to ntot*(nn(1)+nn(2)+...).  for highly composite ntot
c     the savings offered by this program can be dramatic.  a one-dimen-
c     sional array 4000 in length will be transformed in 4000*(600+
c     40*(2+2+2+2+2)+175*(5+5+5)) = 14.5 seconds versus about 4000*
c     4000*175 = 2800 seconds for the straightforward technique.
c
c     the fast fourier transform places three restrictions upon the
c     data.
c     1.  the number of input data and the number of transform values
c     must be the same.
c     2.  both the input data and the transform values must represent
c     equispaced points in their respective domains of time and
c     frequency.  calling these spacings deltat and deltaf, it must be
c     true that deltaf=2*pi/(nn(i)*deltat).  of course, deltat need not
c     be the same for every dimension.
c     3.  conceptually at least, the input data and the transform output
c     represent single cycles of periodic functions.
c
c     the calling sequence is--
c     call fourt(data,nn,ndim,isign,iform,work)
c
c     data is the array used to hold the real and imaginary parts
c     of the data on input and the transform values on output.  it
c     is a multidimensional floating point array, with the real and
c     imaginary parts of a datum stored immediately adjacent in storage
c     (such as fortran iv places them).  normal fortran ordering is
c     expected, the first subscript changing fastest.  the dimensions
c     are given in the integer array nn, of length ndim.  isign is -1
c     to indicate a forward transform (exponential sign is -) and +1
c     for an inverse transform (sign is +).  iform is +1 if the data are
c     complex, 0 if the data are real.  if it is 0, the imaginary
c     parts of the data must be set to zero.  as explained above, the
c     transform values are always complex and are stored in array data.
c     work is an array used for working storage.  it is floating point
c     real, one dimensional of length equal to twice the largest array
c     dimension nn(i) that is not a power of two.  if all nn(i) are
c     powers of two, it is not needed and may be replaced by zero in the
c     calling sequence.  thus, for a one-dimensional array, nn(1) odd,
c     work occupies as many storage locations as data.  if supplied,
c     work must not be the same array as data.  all subscripts of all
c     arrays begin at one.
c
c     example 1.  three-dimensional forward fourier transform of a
c     complex array dimensioned 32 by 25 by 13 in fortran iv.
c     dimension data(32,25,13),work(50),nn(3)
c     complex data
c     data nn/32,25,13/
c     do 1 i=1,32
c     do 1 j=1,25
c     do 1 k=1,13
c  1  data(i,j,k)=complex value
c     call fourt(data,nn,3,-1,1,work)
c
c     example 2.  one-dimensional forward transform of a real array of
c     length 64 in fortran ii,
c     dimension data(2,64)
c     do 2 i=1,64
c     data(1,i)=real part
c  2  data(2,i)=0.
c     call fourt(data,64,1,-1,0,0)
c
c     there are no error messages or error halts in this program.  the
c     program returns immediately if ndim or any nn(i) is less than one.
c
c     program by norman brenner from the basic program by charles
c     rader,  june 1967.  the idea for the digit reversal was
c     suggested by ralph alter.
c
c     this is the fastest and most versatile version of the fft known
c     to the author.  a program called four2 is available that also
c     performs the fast fourier transform and is written in usasi basic
c     fortran.  it is about one third as long and restricts the
c     dimensions of the input array (which must be complex) to be powers
c     of two.  another program, called four1, is one tenth as long and
c     runs two thirds as fast on a one-dimensional complex array whose
c     length is a power of two.
c
c     reference--
c     ieee audio transactions (june 1967), special issue on the fft.
c
C     .. Scalar Arguments ..
	INTEGER IFORM,ISIGN,NDIM
C     ..
C     .. Array Arguments ..
	REAL DATA(1),WORK(1)
	INTEGER NN(1)
C     ..
C     .. Local Scalars ..
	REAL DIFI,DIFR,OLDSI,OLDSR,RTHLF,SUMI,SUMR,T2I,T2R,T3I,T3R,T4I,
     +     T4R,TEMPI,TEMPR,THETA,TWOPI,TWOWR,U1I,U1R,U2I,U2R,U3I,U3R,
     +     U4I,U4R,W2I,W2R,W3I,W3R,WI,WR,WSTPI,WSTPR
	INTEGER I,I1,I1MAX,I1RNG,I2,I2MAX,I3,ICASE,ICONJ,IDIM,IDIV,IF,
     +        IFMIN,IFP1,IFP2,IMAX,IMIN,INON2,IPAR,IQUOT,IREM,J,J1,
     +        J1MAX,J1MIN,J2,J2MAX,J2MIN,J2RNG,J3,J3MAX,JMAX,JMIN,K1,K2,
     +        K3,K4,KDIF,KMIN,KSTEP,L,LMAX,M,MMAX,N,NHALF,NP0,NP1,NP1HF,
     +        NP1TW,NP2,NP2HF,NPREV,NTOT,NTWO,NWORK
C     ..
C     .. Local Arrays ..
	INTEGER IFACT(32)
C     ..
C     .. Intrinsic Functions ..
	INTRINSIC COS,MAX0,REAL,SIN
C     ..
C     .. Data statements ..
	DATA NP0/0/,NPREV/0/
	DATA TWOPI/6.2831853071796/,RTHLF/0.70710678118655/
C     ..
	IF (NDIM-1) 232,101,101
 101	NTOT = 2
	DO 103 IDIM = 1,NDIM
	   IF (NN(IDIM)) 232,232,102
 102	   NTOT = NTOT*NN(IDIM)
 103	CONTINUE
c
c     main loop for each dimension
c
	NP1 = 2
	DO 231 IDIM = 1,NDIM
	   N = NN(IDIM)
	   NP2 = NP1*N
	   IF (N-1) 232,230,104
c
c     is n a power of two and if not, what are its factors
c
 104	   M = N
	   NTWO = NP1
	   IF = 1
	   IDIV = 2
 105	   IQUOT = M/IDIV
	   IREM = M - IDIV*IQUOT
	   IF (IQUOT-IDIV) 113,106,106
 106	   IF (IREM) 108,107,108
 107	   NTWO = NTWO + NTWO
	   IFACT(IF) = IDIV
	   IF = IF + 1
	   M = IQUOT
	   GO TO 105

 108	   IDIV = 3
	   INON2 = IF
 109	   IQUOT = M/IDIV
	   IREM = M - IDIV*IQUOT
	   IF (IQUOT-IDIV) 115,110,110
 110	   IF (IREM) 112,111,112
 111	   IFACT(IF) = IDIV
	   IF = IF + 1
	   M = IQUOT
	   GO TO 109

 112	   IDIV = IDIV + 2
	   GO TO 109

 113	   INON2 = IF
	   IF (IREM) 115,114,115
 114	   NTWO = NTWO + NTWO
	   GO TO 116

 115	   IFACT(IF) = M
c
c     separate four cases--
c        1. complex transform or real transform for the 4th, 9th,etc.
c           dimensions.
c        2. real transform for the 2nd or 3rd dimension.  method--
c           transform half the data, supplying the other half by con-
c           jugate symmetry.
c        3. real transform for the 1st dimension, n odd.  method--
c           set the imaginary parts to zero.
c        4. real transform for the 1st dimension, n even.  method--
c           transform a complex array of length n/2 whose real parts
c           are the even numbered real values and whose imaginary parts
c           are the odd numbered real values.  separate and supply
c           the second half by conjugate symmetry.
c
 116	   ICASE = 1
	   IFMIN = 1
	   I1RNG = NP1
	   IF (IDIM-4) 117,122,122
 117	   IF (IFORM) 118,118,122
 118	   ICASE = 2
	   I1RNG = NP0* (1+NPREV/2)
	   IF (IDIM-1) 119,119,122
 119	   ICASE = 3
	   I1RNG = NP1
	   IF (NTWO-NP1) 122,122,120
 120	   ICASE = 4
	   IFMIN = 2
	   NTWO = NTWO/2
	   N = N/2
	   NP2 = NP2/2
	   NTOT = NTOT/2
	   I = 1
	   DO 121 J = 1,NTOT
              DATA(J) = DATA(I)
              I = I + 2
 121	   CONTINUE
c
c     shuffle data by bit reversal, since n=2**k.  as the shuffling
c     can be done by simple interchange, no working array is needed
c
 122	   IF (NTWO-NP2) 132,123,123
 123	   NP2HF = NP2/2
	   J = 1
	   DO 131 I2 = 1,NP2,NP1
              IF (J-I2) 124,127,127
 124	      I1MAX = I2 + NP1 - 2
              DO 126 I1 = I2,I1MAX,2
		 DO 125 I3 = I1,NTOT,NP2
		    J3 = J + I3 - I2
		    TEMPR = DATA(I3)
		    TEMPI = DATA(I3+1)
		    DATA(I3) = DATA(J3)
		    DATA(I3+1) = DATA(J3+1)
		    DATA(J3) = TEMPR
		    DATA(J3+1) = TEMPI
 125		 CONTINUE
 126	      CONTINUE
 127	      M = NP2HF
 128	      IF (J-M) 130,130,129
 129	      J = J - M
              M = M/2
              IF (M-NP1) 130,128,128
 130	      J = J + M
 131	   CONTINUE
	   GO TO 142
c
c     shuffle data by digit reversal for general n
c
 132	   NWORK = 2*N
	   DO 141 I1 = 1,NP1,2
              DO 140 I3 = I1,NTOT,NP2
		 J = I3
		 DO 138 I = 1,NWORK,2
		    IF (ICASE-3) 133,134,133
 133		    WORK(I) = DATA(J)
		    WORK(I+1) = DATA(J+1)
		    GO TO 135
		    
 134		    WORK(I) = DATA(J)
		    WORK(I+1) = 0.
 135		    IFP2 = NP2
		    IF = IFMIN
 136		    IFP1 = IFP2/IFACT(IF)
		    J = J + IFP1
		    IF (J-I3-IFP2) 138,137,137
 137		    J = J - IFP2
		    IFP2 = IFP1
		    IF = IF + 1
		    IF (IFP2-NP1) 138,138,136
 138		 CONTINUE
		 I2MAX = I3 + NP2 - NP1
		 I = 1
		 DO 139 I2 = I3,I2MAX,NP1
		    DATA(I2) = WORK(I)
		    DATA(I2+1) = WORK(I+1)
		    I = I + 2
 139		 CONTINUE
 140	      CONTINUE
 141	   CONTINUE
c
c     main loop for factors of two.  perform fourier transforms of
c     length four, with one of length two if needed.  the twiddle factor
c     w=exp(isign*2*pi*sqrt(-1)*m/(4*mmax)).  check for w=isign*sqrt(-1)
c     and repeat for w=w*(1+isign*sqrt(-1))/sqrt(2).
c
 142	   IF (NTWO-NP1) 174,174,143
 143	   NP1TW = NP1 + NP1
	   IPAR = NTWO/NP1
 144	   IF (IPAR-2) 149,146,145
 145	   IPAR = IPAR/4
	   GO TO 144

 146	   DO 148 I1 = 1,I1RNG,2
              DO 147 K1 = I1,NTOT,NP1TW
		 K2 = K1 + NP1
		 TEMPR = DATA(K2)
		 TEMPI = DATA(K2+1)
		 DATA(K2) = DATA(K1) - TEMPR
		 DATA(K2+1) = DATA(K1+1) - TEMPI
		 DATA(K1) = DATA(K1) + TEMPR
		 DATA(K1+1) = DATA(K1+1) + TEMPI
 147	      CONTINUE
 148	   CONTINUE
 149	   MMAX = NP1
 150	   IF (MMAX-NTWO/2) 151,174,174
 151	   LMAX = MAX0(NP1TW,MMAX/2)
	   DO 173 L = NP1,LMAX,NP1TW
              M = L
              IF (MMAX-NP1) 156,156,152
 152	      THETA = -TWOPI*REAL(L)/REAL(4*MMAX)
              IF (ISIGN) 154,153,153
 153	      THETA = -THETA
 154	      WR = COS(THETA)
              WI = SIN(THETA)
 155	      W2R = WR*WR - WI*WI
              W2I = 2.*WR*WI
              W3R = W2R*WR - W2I*WI
              W3I = W2R*WI + W2I*WR
 156	      DO 169 I1 = 1,I1RNG,2
		 KMIN = I1 + IPAR*M
		 IF (MMAX-NP1) 157,157,158
 157		 KMIN = I1
 158		 KDIF = IPAR*MMAX
 159		 KSTEP = 4*KDIF
		 IF (KSTEP-NTWO) 160,160,169
 160		 DO 168 K1 = KMIN,NTOT,KSTEP
		    K2 = K1 + KDIF
		    K3 = K2 + KDIF
		    K4 = K3 + KDIF
		    IF (MMAX-NP1) 161,161,164
 161		    U1R = DATA(K1) + DATA(K2)
		    U1I = DATA(K1+1) + DATA(K2+1)
		    U2R = DATA(K3) + DATA(K4)
		    U2I = DATA(K3+1) + DATA(K4+1)
		    U3R = DATA(K1) - DATA(K2)
		    U3I = DATA(K1+1) - DATA(K2+1)
		    IF (ISIGN) 162,163,163
 162		    U4R = DATA(K3+1) - DATA(K4+1)
		    U4I = DATA(K4) - DATA(K3)
		    GO TO 167

 163		    U4R = DATA(K4+1) - DATA(K3+1)
		    U4I = DATA(K3) - DATA(K4)
		    GO TO 167

 164		    T2R = W2R*DATA(K2) - W2I*DATA(K2+1)
		    T2I = W2R*DATA(K2+1) + W2I*DATA(K2)
		    T3R = WR*DATA(K3) - WI*DATA(K3+1)
		    T3I = WR*DATA(K3+1) + WI*DATA(K3)
		    T4R = W3R*DATA(K4) - W3I*DATA(K4+1)
		    T4I = W3R*DATA(K4+1) + W3I*DATA(K4)
		    U1R = DATA(K1) + T2R
		    U1I = DATA(K1+1) + T2I
		    U2R = T3R + T4R
		    U2I = T3I + T4I
		    U3R = DATA(K1) - T2R
		    U3I = DATA(K1+1) - T2I
		    IF (ISIGN) 165,166,166
 165		    U4R = T3I - T4I
		    U4I = T4R - T3R
		    GO TO 167

 166		    U4R = T4I - T3I
		    U4I = T3R - T4R
 167		    DATA(K1) = U1R + U2R
		    DATA(K1+1) = U1I + U2I
		    DATA(K2) = U3R + U4R
		    DATA(K2+1) = U3I + U4I
		    DATA(K3) = U1R - U2R
		    DATA(K3+1) = U1I - U2I
		    DATA(K4) = U3R - U4R
		    DATA(K4+1) = U3I - U4I
 168		 CONTINUE
		 KDIF = KSTEP
		 KMIN = 4* (KMIN-I1) + I1
		 GO TO 159

 169	      CONTINUE
              M = M + LMAX
              IF (M-MMAX) 170,170,173
 170	      IF (ISIGN) 171,172,172
 171	      TEMPR = WR
              WR = (WR+WI)*RTHLF
              WI = (WI-TEMPR)*RTHLF
              GO TO 155

 172	      TEMPR = WR
              WR = (WR-WI)*RTHLF
              WI = (TEMPR+WI)*RTHLF
              GO TO 155

 173	   CONTINUE
	   IPAR = 3 - IPAR
	   MMAX = MMAX + MMAX
	   GO TO 150
c
c     main loop for factors not equal to two.  apply the twiddle factor
c     w=exp(isign*2*pi*sqrt(-1)*(j1-1)*(j2-j1)/(ifp1+ifp2)), then
c     perform a fourier transform of length ifact(if), making use of
c     conjugate symmetries.
c
 174	   IF (NTWO-NP2) 175,201,201
 175	   IFP1 = NTWO
	   IF = INON2
	   NP1HF = NP1/2
 176	   IFP2 = IFACT(IF)*IFP1
	   J1MIN = NP1 + 1
	   IF (J1MIN-IFP1) 177,177,184
 177	   DO 183 J1 = J1MIN,IFP1,NP1
              THETA = -TWOPI*REAL(J1-1)/REAL(IFP2)
              IF (ISIGN) 179,178,178
 178	      THETA = -THETA
 179	      WSTPR = COS(THETA)
              WSTPI = SIN(THETA)
              WR = WSTPR
              WI = WSTPI
              J2MIN = J1 + IFP1
              J2MAX = J1 + IFP2 - IFP1
              DO 182 J2 = J2MIN,J2MAX,IFP1
		 I1MAX = J2 + I1RNG - 2
		 DO 181 I1 = J2,I1MAX,2
		    DO 180 J3 = I1,NTOT,IFP2
		       TEMPR = DATA(J3)
		       DATA(J3) = DATA(J3)*WR - DATA(J3+1)*WI
		       DATA(J3+1) = TEMPR*WI + DATA(J3+1)*WR
 180		    CONTINUE
 181		 CONTINUE
		 TEMPR = WR
		 WR = WR*WSTPR - WI*WSTPI
		 WI = TEMPR*WSTPI + WI*WSTPR
 182	      CONTINUE
 183	   CONTINUE
 184	   THETA = -TWOPI/REAL(IFACT(IF))
	   IF (ISIGN) 186,185,185
 185	   THETA = -THETA
 186	   WSTPR = COS(THETA)
	   WSTPI = SIN(THETA)
	   J2RNG = IFP1* (1+IFACT(IF)/2)
	   DO 200 I1 = 1,I1RNG,2
              DO 199 I3 = I1,NTOT,NP2
		 J2MAX = I3 + J2RNG - IFP1
		 DO 197 J2 = I3,J2MAX,IFP1
		    J1MAX = J2 + IFP1 - NP1
		    DO 193 J1 = J2,J1MAX,NP1
		       J3MAX = J1 + NP2 - IFP2
		       DO 192 J3 = J1,J3MAX,IFP2
			  JMIN = J3 - J2 + I3
			  JMAX = JMIN + IFP2 - IFP1
			  I = 1 + (J3-I3)/NP1HF
			  IF (J2-I3) 187,187,189
 187			  SUMR = 0.
			  SUMI = 0.
			  DO 188 J = JMIN,JMAX,IFP1
			     SUMR = SUMR + DATA(J)
			     SUMI = SUMI + DATA(J+1)
 188			  CONTINUE
			  WORK(I) = SUMR
			  WORK(I+1) = SUMI
			  GO TO 192
			  
 189			  ICONJ = 1 + (IFP2-2*J2+I3+J3)/NP1HF
			  J = JMAX
			  SUMR = DATA(J)
			  SUMI = DATA(J+1)
			  OLDSR = 0.
			  OLDSI = 0.
			  J = J - IFP1
 190			  TEMPR = SUMR
			  TEMPI = SUMI
			  SUMR = TWOWR*SUMR - OLDSR + DATA(J)
			  SUMI = TWOWR*SUMI - OLDSI + DATA(J+1)
			  OLDSR = TEMPR
			  OLDSI = TEMPI
			  J = J - IFP1
			  IF (J-JMIN) 191,191,190
 191			  TEMPR = WR*SUMR - OLDSR + DATA(J)
			  TEMPI = WI*SUMI
			  WORK(I) = TEMPR - TEMPI
			  WORK(ICONJ) = TEMPR + TEMPI
			  TEMPR = WR*SUMI - OLDSI + DATA(J+1)
			  TEMPI = WI*SUMR
			  WORK(I+1) = TEMPR + TEMPI
			  WORK(ICONJ+1) = TEMPR - TEMPI
 192		       CONTINUE
 193		    CONTINUE
		    IF (J2-I3) 194,194,195
 194		    WR = WSTPR
		    WI = WSTPI
		    GO TO 196
		    
 195		    TEMPR = WR
		    WR = WR*WSTPR - WI*WSTPI
		    WI = TEMPR*WSTPI + WI*WSTPR
 196		    TWOWR = WR + WR
 197		 CONTINUE
		 I = 1
		 I2MAX = I3 + NP2 - NP1
		 DO 198 I2 = I3,I2MAX,NP1
		    DATA(I2) = WORK(I)
		    DATA(I2+1) = WORK(I+1)
		    I = I + 2
 198		 CONTINUE
 199	      CONTINUE
 200	   CONTINUE
	   IF = IF + 1
	   IFP1 = IFP2
	   IF (IFP1-NP2) 176,201,201
c
c     complete a real transform in the 1st dimension, n even, by con-
c     jugate symmetries.
c
 201	   GO TO (230,220,230,202) ICASE
	   
 202	   NHALF = N
	   N = N + N
	   THETA = -TWOPI/REAL(N)
	   IF (ISIGN) 204,203,203
 203	   THETA = -THETA
 204	   WSTPR = COS(THETA)
	   WSTPI = SIN(THETA)
	   WR = WSTPR
	   WI = WSTPI
	   IMIN = 3
	   JMIN = 2*NHALF - 1
	   GO TO 207

 205	   J = JMIN
	   DO 206 I = IMIN,NTOT,NP2
              SUMR = (DATA(I)+DATA(J))/2.
              SUMI = (DATA(I+1)+DATA(J+1))/2.
              DIFR = (DATA(I)-DATA(J))/2.
              DIFI = (DATA(I+1)-DATA(J+1))/2.
              TEMPR = WR*SUMI + WI*DIFR
              TEMPI = WI*SUMI - WR*DIFR
              DATA(I) = SUMR + TEMPR
              DATA(I+1) = DIFI + TEMPI
              DATA(J) = SUMR - TEMPR
              DATA(J+1) = -DIFI + TEMPI
              J = J + NP2
 206	   CONTINUE
	   IMIN = IMIN + 2
	   JMIN = JMIN - 2
	   TEMPR = WR
	   WR = WR*WSTPR - WI*WSTPI
	   WI = TEMPR*WSTPI + WI*WSTPR
 207	   IF (IMIN-JMIN) 205,208,211
 208	   IF (ISIGN) 209,211,211
 209	   DO 210 I = IMIN,NTOT,NP2
              DATA(I+1) = -DATA(I+1)
 210	   CONTINUE
 211	   NP2 = NP2 + NP2
	   NTOT = NTOT + NTOT
	   J = NTOT + 1
	   IMAX = NTOT/2 + 1
 212	   IMIN = IMAX - 2*NHALF
	   I = IMIN
	   GO TO 214
	   
 213	   DATA(J) = DATA(I)
	   DATA(J+1) = -DATA(I+1)
 214	   I = I + 2
	   J = J - 2
	   IF (I-IMAX) 213,215,215
 215	   DATA(J) = DATA(IMIN) - DATA(IMIN+1)
	   DATA(J+1) = 0.
	   IF (I-J) 217,219,219
 216	   DATA(J) = DATA(I)
	   DATA(J+1) = DATA(I+1)
 217	   I = I - 2
	   J = J - 2
	   IF (I-IMIN) 218,218,216
 218	   DATA(J) = DATA(IMIN) + DATA(IMIN+1)
	   DATA(J+1) = 0.
	   IMAX = IMIN
	   GO TO 212

  219     DATA(1) = DATA(1) + DATA(2)
          DATA(2) = 0.
          GO TO 230
c
c     complete a real transform for the 2nd or 3rd dimension by
c     conjugate symmetries.
c
 220	  IF (I1RNG-NP1) 221,230,230
 221	  DO 229 I3 = 1,NTOT,NP2
	     I2MAX = I3 + NP2 - NP1
	     DO 228 I2 = I3,I2MAX,NP1
		IMIN = I2 + I1RNG
		IMAX = I2 + NP1 - 2
		JMAX = 2*I3 + NP1 - IMIN
		IF (I2-I3) 223,223,222
 222		JMAX = JMAX + NP2
 223		IF (IDIM-2) 226,226,224
 224		J = JMAX + NP0
		DO 225 I = IMIN,IMAX,2
		   DATA(I) = DATA(J)
		   DATA(I+1) = -DATA(J+1)
		   J = J - 2
 225		CONTINUE
 226		J = JMAX
		DO 227 I = IMIN,IMAX,NP0
		   DATA(I) = DATA(J)
		   DATA(I+1) = -DATA(J+1)
		   J = J - NP0
 227		CONTINUE
 228	     CONTINUE
 229	  CONTINUE
c
c     end of loop on each dimension
c
 230	  NP0 = NP1
          NP1 = NP2
          NPREV = N
 231	CONTINUE
 232	RETURN
c
c revision history---
c
c january 1978     deleted references to the  *cosy  cards and
c                  added revision history
c-----------------------------------------------------------------------
	END

