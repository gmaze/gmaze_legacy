% [Sf A FX FT] = WSEdecomp(S,DT,DX,[PERIOD],[WAVELENGTH]) 
% Split S(SPACE,TIME) into: DW/ST/UP-waves
%
% Split the signal S(SPACE,TIME) into its downward/upward space 
% propagating and stationnary components via a 2D Fourier decomposition.
% S is a (SPACE,TIME) matrix. We eventually proceed to a space and/or 
% time filtering. DT,DX are temporal and space step. PERIOD=[Tmin Tmax] 
% and WAVELENGTH=[Xmin Xmax] are time and space band-pass filters 
% specifications.
%
% Sf(DIRspec,SPACE,TIME) are each components with:
%    DIRspec=1 -> Downward part (decreasing space axis)
%    DIRspec=2 -> Stationnary part
%    DIRspec=3 -> Upward part (increasing space axis)
%
% A(DIRspec,SPACE/2,TIME/2) are propagative Power Spectral Density with:
%    DIRspec=1 -> Downward part (decreasing space axis)
%    DIRspec=2 -> Upward part (increasing space axis)
% Rq: SPACE and TIME must be even
%
% FX and FT are space and time wavenumbers:
%    FX -> Space wavenumber, ie: 2*pi*[0:SPACE/2-1]/DX/SPACE
%    FT -> Time wavenumber, ie: 2*pi*[0:TIME/2-1]/DT/TIME
% 
% PERIOD=[Tmin Tmax] is in real time axis unit
% WAVELENGTH=[Xmin Xmax] is in real space axis unit
%
% Rq: 
%   - PERIOD/WAVELENGTH=[0 Inf] produce no filtering
%   - Tmin or Xmin = 0   will produce high-pass filtering
%   - Tmax or Xmax = Inf will produce low-pass filtering
%
% Ref: Park et al (2004) GRL V31
%      Park (1990) C. R. Acad. Sci. Paris 310(II) p919-926
%      J. Le Sommer, personnal communication
%================================================================
%
%  Guillaume MAZE - LPO/LMD - July 2004 - gmaze@univ-brest.fr
%  Last reviewed:
%                 Nathalie Daniault - September 2004
%                 -> Vectorisation of recomposition loop
%                 Nathalie Daniault - August 2004
%                 -> Change phases definition and 
%                    adapt to a signal with non nul mean

function varargout = WSEdecomp(S,DT,DX,varargin)


warning off MATLAB:divideByZero
%===============================================================================
% Variables
%===============================================================================
switch nargin
   case 1    
     help WSEdecomp.m
     error('WSEdecomp.m : Wrong number or bad parameter(s)')
     return
   case 2    
     help WSEdecomp.m
     error('WSEdecomp.m : Wrong number or bad parameter(s)')
     return
   case 4
     arg = varargin(1); arg=arg{:};
     PERIOD=arg;
   case 5
     arg1 = varargin(1); arg1=arg1{:};
     arg2 = varargin(2); arg2=arg2{:};
     PERIOD=arg1;
     WAVELENGTH=arg2;
end % swith nargin

showWAIT=1; % Display a waitbar during computation (0 else)

%===============================================================================
% PRE-PROCESS
%===============================================================================
% Allocate signal value to the work variable W:
W=S;

% Check even dimensions and create axis:
[nx,nt]=size(W);
if iseven(nx)==0,nx=nx-1;W=squeeze(W(1:nx,:));end;
if iseven(nt)==0,nt=nt-1;W=squeeze(W(:,1:nt));end;
nfx=nx/2;nft=nt/2;
tt=[0:nt-1]*DT; % Time axis
xx=[0:nx-1]*DX; % Space axis

% Define space/time range to keep:
if exist('WAVELENGTH')
    xmin=WAVELENGTH(1);
    xmax=WAVELENGTH(2);
else
    xmin=0;
    xmax=Inf;
end
if exist('PERIOD')
    tmin=PERIOD(1);
    tmax=PERIOD(2);
else
    tmin=0;
    tmax=Inf;
end

% Frequencies tables:
ca    = 2*pi*[0:nfx-1]/DX/nx;
omega = 2*pi*[0:nft-1]/DT/nt;

% Frequencies conserved:
   camin = 2*pi/xmax;
   camax = 2*pi/xmin;
omegamin = 2*pi/tmax;
omegamax = 2*pi/tmin;

% Coefficients:
for ifx=1:nfx
   for ift=1:nft
       if( (ca(ifx)<=camax)&(ca(ifx)>=camin)&...
           (omega(ift)<=omegamax)&(omega(ift)>=omegamin) )
          compose(ifx,ift) = 1;
       else
          compose(ifx,ift) = 0;      
       end %if
   end %for ift
end %for ifx


%===============================================================================
%   PROCESS
%===============================================================================
% Space Fourier Transform:
for it=1:nt
  Hx = fft(W(:,it));
  Ck(:,it) = 2*real(Hx(1:nfx))/nx;
  Sk(:,it) =-2*imag(Hx(1:nfx))/nx;
  Ck(1,it)=Hx(1)/nx; Sk(1,it)=0; % Added By N. Daniault
end

% Time Fourier Transform:
for ifx=1:nfx
  HtC = fft(Ck(ifx,:));
  a(ifx,:) = 2*real(HtC(1:nft))/nt;
  b(ifx,:) = -2*imag(HtC(1:nft))/nt;
  a(ifx,1)=HtC(1)/nt;b(ifx,1)=0;  % Added By N. Daniault

  HtS = fft(Sk(ifx,:));
  c(ifx,:) = 2*real(HtS(1:nft))/nt;
  d(ifx,:) = -2*imag(HtS(1:nft))/nt;
  c(ifx,1)=HtS(1)/nt;d(ifx,1)=0;  % Added By N. Daniault
end %for ifx

% Cosine and sine coefficients for each space direction
% (See Park et al (2004) GRL V31)
  Ces = (c-b)/2;
  Cws = (b+c)/2;
  Cec = (a+d)/2;
  Cwc = (a-d)/2;
% Amplitude of each waves:
  Aw = sqrt( Cws.^2 + Cwc.^2 );
  Ae = sqrt( Ces.^2 + Cec.^2 );
% Phases:
  %phiw = atan(Cws./Cwc);   phie = atan(Ces./Cec);   % First version
  phiw = angle(Cwc+i*Cws); phie = angle(Cec+i*Ces); % New one by N. Daniault

% Now we sum over ca and omega in each point of the signal
% to recomposed signal with each components:
WS=zeros(nx,nt);WE=WS;WW=WS;
if showWAIT,h = waitbar(0,'Please wait...');end,
for ix = 1 : nx
  if showWAIT,waitbar(ix/nx,h);end,
  for lt = 1 : nt
    varS = 0;
    varE = 0;
    varW = 0;
    for ifx = 1 : nfx
      for ift = 1 : nft
	% Stationnary wave phases:
	pxt1 = ca(ifx)*xx(ix) - (phiw(ifx,ift)+phie(ifx,ift))/2;
        pxt2 = omega(ift)*tt(lt) - (phiw(ifx,ift)-phie(ifx,ift))/2;
        if Aw(ifx,ift)>Ae(ifx,ift)
	  % WEST/DOWN wave phase:
           pxt3 = ca(ifx)*xx(ix) + omega(ift)*tt(lt) - phiw(ifx,ift);
          % Signal:
   	   varS = varS + compose(ifx,ift)*2*Ae(ifx,ift)*cos(pxt1)*cos(pxt2);
           varW = varW + compose(ifx,ift)*(Aw(ifx,ift)-Ae(ifx,ift))*cos(pxt3);
        else
    	  % EAST/UP wave phase:
           pxt3 = ca(ifx)*xx(ix) - omega(ift)*tt(lt) - phie(ifx,ift);
          % Signal:
           varS = varS + compose(ifx,ift)*2*Aw(ifx,ift)*cos(pxt1)*cos(pxt2);
           varE = varE + compose(ifx,ift)*(Ae(ifx,ift)-Aw(ifx,ift))*cos(pxt3);
        end
      end %for ift
    end %for ifx

    WS(ix,lt)=varS;
    WE(ix,lt)=varE;
    WW(ix,lt)=varW;

  end %for lt
end %for ix
if showWAIT,close(h);end,


%===============================================================================
% OUTPUT VARIABLES:
%===============================================================================
Sf(1,:,:)= WW;
Sf(2,:,:)= WS;
Sf(3,:,:)= WE;
A(1,:,:) = (Aw.*compose).^2;
A(2,:,:) = (Ae.*compose).^2;
FX=ca;
FT=omega;

switch nargout
  case 1
   varargout(1) = {Sf} ;
  case 2
   varargout(1) = {Sf} ;
   varargout(2) = {A};
  case 3
   varargout(1) = {Sf} ;
   varargout(2) = {A};
   varargout(3) = {FX};
  case 4
   varargout(1) = {Sf} ;
   varargout(2) = {A};
   varargout(3) = {FX};
   varargout(4) = {FT};
end


