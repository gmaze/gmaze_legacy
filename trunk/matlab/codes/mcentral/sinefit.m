function varargout = sinefit(varargin)
% params = sinefit(yin,t,f)
% [params,yest] = sinefit(yin,t,f)
% [params,yest] = sinefit(yin,t,f,verbose)
% [params,yest] = sinefit(yin,t,f,verbose,plotflag)
% [params,yest] = sinefit(yin,t,f,verbose,plotflag,searchflag)
% [params,yest,yres] = sinefit(yin,t,...)
% [params,yest,yres,rmserr] = sinefit(yin,t,...)
% 
% Least squares sinusoid fit - optimization toolbox not needed
%
% IEEE Standard for Digitizing Waveform Recorders (IEEE Std 1057):
% Algorithm for three-parameter (known frequency) and four-parameter 
% (general use) least squares fit to sinewave data using matrix operations.
%
% INPUTS:   -yin:        Input signal to be fitted (a vector)
%           -t:          Time vector (same length as yin)
%           -f:          Signal frequency (actual or estimate) [Hz]
%           -verbose:    if 1, display information; else, don't. default: 1
%           -plotflag:   If 1, plot; else, don't. default: 1
%           -searchflag: If 0, iterative search skipped, just fit.
%                        A quick choice you may want to try...
%                        By default searchflag = 1.
%
% -The time vector is not necessarily linearly spaced (hence required here)
% -If f is a guess, it has to be near true input signal frequency
%
% OUTPUTS:  -params:  A vector containing:
%                     [offset amplitude freq(Hz) angle(rad)].
%                     If not converged, params = [nan nan nan nan]
%           -yest:    Estimated sinusoid:
%                     offset+amplitude*cos(2*pi*frequency_Hz*t+angle_rad)
%           -yres:    The residual
%           -rmserr:  Root mean square of the residual
%
% For further information, consult IEEE Std 1057 and/or 
% IEEE Std 1241 documentation.
% 
% type sinefit for demo

% seed number for random generator. For repeatability...
oct_flag = 0;
try
    s=RandStream('mt19937ar','seed',16384);
catch
    oct_flag = 1;
    fprintf('\nCannot create seed number\n')
end


if nargin == 0   %demo
    clc
    fprintf('\ndemo1: creating sinusoid with\n\t- clock jitter,\n\t')
    fprintf('- phase noise,\n\t- additive noise and \n\t- harmonics\n ')
    N=pow2(12);          	%vector length
    fs = pi*1e3;            %sampling freq
    ts = 1/fs;              %sampling interval
    freq = (N/128-1)*fs/N;  %freq (Hz)
    phase = pi/2;          %phase (rad)
    offset = pi*2;          %offset (i.e mean)
    amplitude = pi/3;       %amplitude
    t = (0:(N-1))*ts;       %time vector
    std_jitter = 1e-2;  %standard deviation of jitter noise
    std_addnoi = 1e-1;  %standard deviation of  noise added to signal
    std_phase  = 1e-2;   %standard deviation of phase noise
    if oct_flag
        noise = randn(1,N);
    else
        noise = randn(s,1,N);
    end
    
    std1_noise = noise/std(noise);  % random vector with stdev = 1
    jit_noise = std_jitter*std1_noise;
    phase_noise = std_phase*std1_noise;
    add_noise = std_addnoi*std1_noise;
    w=2*pi*freq;
    t = t + ts*jit_noise;                          % add clock jitter
    A2 = amplitude*0.01;     % 2. harmonic ampl
    A3 = amplitude*0.02;     % 3. harmonic ampl
    yin = cos(w*t+phase+phase_noise);  % sinusoid with phase noise
    %add offset, noise & harmonics
    yin = offset+amplitude*yin+A2*yin.*yin+A3*yin.*yin.*yin+add_noise; 
    figure
    params = sinefit(yin,t,freq,1,1);
    %params = sinefit(yin,t,freq,1,1,0);  %quick mode
    fprintf('\n\t\t\tpure sinusoid\tnoisy sinusoid fit')
    fprintf('\nOffset:   \t%3.4g\t\t\t%3.4g',offset,params(1))
    fprintf('\nAmpl:   \t%3.4g\t\t\t%3.4g',amplitude,params(2))
    fprintf('\nFreq:   \t%3.4g\t\t\t%3.4g [Hz]',freq,params(3))
    fprintf('\nPhase:\t\t%3.4g*pi\t\t%3.4g*pi [rad]\n',phase/pi,...
        params(4)/pi)
    fprintf('\nend demo1\n\n Press space for demo2')
    pause
    noiseq = randn(s,1,N);
    std1_noiseq = noise/std(noiseq);  % random vector with stdev = 1
    add_noise = 1e-2*(std1_noise+1i*std1_noiseq);
    fprintf('\n\ndemo2: phasor with noise and offset')
    yin = exp(1i*(w*t+phase));  % phasor with phase noise
    offset = offset + 1i*offset;
    yin = offset+amplitude*yin+add_noise; 
    params = sinefit(yin,t,freq,1,1);
    fprintf('\n\t\t\tpure sinusoid\tnoisy sinusoid fit')
    fprintf('\nOffset:   \t%3.4g+j%3.4g\t%3.4g+j%3.4g',...
        real(offset),imag(offset),real(params(1)),imag(params(1)))
    fprintf('\nAmpl:   \t%3.4g\t\t\t%3.4g',amplitude,params(2))
    fprintf('\nFreq:   \t%3.4g\t\t\t%3.4g [Hz]',freq,params(3))
    fprintf('\nPhase:\t\t%3.4g*pi\t\t%3.4g*pi [rad]\n',phase/pi,...
        params(4)/pi)
    fprintf('\nend demo2\n')
    %clear params yest
    return
end   %end demo

% convergence related parameters you can tweak:
TOL = 1e-15;    % Normalized initial tolerance
MTOL = 2;             % TOL relaxation multiplicand, MTOL > 1 
MAX_FUN= 22;          % MAX number of function calls
MAX_ITER = 22;        % MAX number of iterations in one function call

%varargin
if not(oct_flag)
if nargin < 3 && nargin > 0
    error('at least three input params needed')
else
    yin=varargin{1};
    t=varargin{2};
    f=varargin{3};
    verbose=1;
    plotflag = 1;
    searchflag=1;
end

if nargin == 4
    verbose=varargin{4};
    plotflag = 1;
    searchflag=1;
elseif nargin == 5
    verbose=varargin{4};
    plotflag=varargin{5};
    searchflag=1;
elseif nargin == 6
    verbose=varargin{4};
    plotflag=varargin{5};
    searchflag=varargin{6};
end
end

% Convergence related stuff: Vector x0 will be created: x0=[A B C dw], 
% where A & B are sin & cos multiplicands, C is the offset and dw is 
% the angular frequency increment in iterative search.
%
% x0 is, of course, normalized in convergence calculation
%(Fit for 1*yin converges as fast as for 100*yin)
% ****  if max(abs(x0(i)-x0(i-1)))<TOL, the fit is complete.
% ****  if not, multiply TOL with MTOL and retry maximum of MAX_FUN times.

%plotting related
if plotflag
    N_per=8; %number of periods plotted
    N_hist = 11; %number of bins in histogram
end

if verbose
    tic
end

%vector dimension preps
[rc]=size(yin);
if rc(1)==1
    yin = yin(:);
    N=rc(2);
else
    N=rc(1);
end
t=t(:);

 onevec = ones(N,1);

%t does not have to be linearly spaced, so to estimate sampling time ts
ts = rms(diff(t),N-1); % ts needed in freq normalization of converg. calc

if MTOL<0
    error('MTOL is a positive number > 1')
elseif MTOL<1
    MTOL=1/MTOL;
    fprintf('warning: MTOL should be > 1,')
    fprintf('swiching to inverse value.\nXTOL = %i\n',MTOL)
end

% convergence related normalization 
rmsyin = rms(yin,N);
TOL=rmsyin*TOL;

if nargin < 6
    searchflag = 1;
end

%here we go
if not(searchflag)
    x0 = sinefit3par(yin,2*pi*f*t,onevec);
    x0 = [x0;2*pi*f]; %not searching for freq
    success = 1;
    if verbose
        fprintf('\n\tQuick mode: using 3-parameter sinefit\n\n')
    end
else
    [x0,iter] = sinefit4par(yin,t,ts,2*pi*f,onevec,TOL,MAX_ITER);
    iter_total=iter;
    iter_sinefit4par = 1;  %first function call

    %success?
    if iter<=MAX_ITER
        success = 1;
        if verbose
            st1 = ['\n\tConverged after ' int2str(iter) ' iterations\n'];
            fprintf(st1)
        end
    else
        if verbose
            st2 = '\n\tincreasing TOL...';
            fprintf(st2)
        end
        while iter>MAX_ITER && iter_sinefit4par<=MAX_FUN
            if verbose
                fprintf('.')
            end
            %while # of function calls is < MAX_FUN, do:
            TOL = TOL*MTOL;   %increase TOL
            if oct_flag
                f=f+f/80*randn(1,1);
            else                
                reset(s)
                f=f+f/80*randn(s,1,1);
            end
            
            [x0,iter] = sinefit4par(yin,t,ts,2*pi*f,onevec,TOL,MAX_ITER);
            iter_total = iter_total+iter;
            iter_sinefit4par=iter_sinefit4par+1;
        end
        
        if iter>MAX_ITER
            if verbose
                clc
                fprintf(['\nFailed to fit. The reasons could be:\n\t1. Bad ',...
                    'initial guess for frequency OR\n\t2. ',...
                    'the amplitude level is way below RMS noise floor OR',...
                    '\n\t3. the fundamental frequency drifts (retry with a portion of input signal) OR',...
                    '\n\t4. too small MAX_FUN, FUN_ITER, MTOL or TOL.\n\n'])
                fprintf(['%g function calls made, %g iterations allowed ',...
                    'in each.\n\n'],iter_sinefit4par-1,MAX_ITER)
            end
            success = 0;
            %return
        else
            success = 1;
            if verbose
                st1 = 'converged!\n';
                fprintf(st1)
                fprintf(['\t%g function calls made,\n\t%g iterations allowed ',...
                'in each.\n\n'],iter_sinefit4par,MAX_ITER)
            end
        end
    end
end
%prep the output parameters
A0=x0(1);   B0=x0(2);
C0=x0(3);   w=x0(4);
sinedata = x0(1)*cos(x0(4)*t) + x0(2)*sin(x0(4)*t);
yest = x0(3) + sinedata;

if isreal(yin)
    f_est=w/(2*pi);
    A=sqrt(A0*A0+B0*B0);
    phi=atan(-B0/A0);
    if A0<0
        phi=phi+pi;
    end
    
    params = [C0 A f_est phi];
else
    f_est=real(w/(2*pi));
    phi = angle(A0);
    %phi = angle(x0(1)/2+x0(2)/2)+pi/2;
    %temp = -B0/A0;
    %phi=atan(real(temp))+atan(imag(temp))-pi/4;
    %if real(A0)<0
    %    phi=phi+pi;
    %end
    params = [C0 abs(A0/2)+abs(B0/2) f_est phi];
end

yres = yin-yest;
rmserr = rms(yres,N);

if verbose
    t_elapsed=toc;
    if t_elapsed<60
        fprintf('\tTime elapsed: %g seconds\n',t_elapsed)
    else
        % this is not likely to happen
        fprintf('\tTime elapsed: %g minutes and %g seconds\n',...
            floor(t_elapsed/60),rem(t_elapsed,60))
    end
    
    if plotflag
        fprintf('\nplotting...')
    end
    
end

%plot or not
if plotflag == 1
    if isreal(yin)
        plotsinefit(N_hist,N_per,t,ts,yin,yest,yres,f_est,N,verbose)
    else
        figure
        plot(yin,'b')
        hold on
        plot(yest,'r')
        hold off
        xlabel('real')
        ylabel('imag')
        legend('data','fit',1)
    end
end

if not(success)        
    params = [nan nan nan nan];
    yest=nan; yres=nan; rmserr=nan;
end

%preserve the original vector dimensions
if nargout > 1 
    if rc(1)==1
        yest = yest.';
        yres = yres.';
    end
end

%varargout
if nargout == 1
    varargout{1}=params;
elseif nargout == 2
    varargout{1}=params;
    varargout{2}=yest;
elseif nargout == 3
    varargout{1}=params;
    varargout{2}=yest;
    varargout{3}=yres;
elseif nargout == 4
    varargout{1}=params;
    varargout{2}=yest;
    varargout{3}=yres;
    varargout{4}=rmserr;
end

function x0 = sinefit3par(yin,wt,onevec)
    %3-parameter fit is used to create an initiall guess in sinefit4par
    cosvec=cos(wt);
    sinvec=sin(wt);
    D0=[cosvec sinvec onevec];
    %x0=inv(D0.'*D0)*(D0.'*yin);
    if isreal(yin)
        [Q,R] = qr(D0,0);
        x0 = R\(Q.'*yin); 
    else
        x0=lscov(D0,yin);
    end

function [x0,iter] = sinefit4par(yin,t,ts,w,onevec,TOL,MAX_ITER)
    x0 = sinefit3par(yin,w*t,onevec);
    x0 = [x0;0];
    iter = 0;success = 0;
    while success == 0
        w=w+x0(4);
        wt=w*t;
        cosvec=cos(wt);
        sinvec=sin(wt);
        D0=[cosvec sinvec onevec -x0(1)*t.*sinvec+x0(2)*t.*cosvec];
        x0old = x0;
        %x0=inv(D0.'*D0)*(D0.'*yin);
        if isreal(yin)
            [Q,R] = qr(D0,0);
            x0 = R\(Q.'*yin);
        else
            x0=lscov(D0,yin);
        end
        iter = iter + 1;
        
        %error term with dw normalized
        temp=abs(x0-x0old).*[1 1 1 ts].';
        err=max(temp);
        
        if err<TOL || iter > MAX_ITER %if iter>MAX_ITER, increase TOL and
            success = 1;              %re-visit this function later.
        end
    end
    x0(end)=w;  %place w in the position if w's increment

function plotsinefit(N_hist,N_per,t,ts,yin,yest,yres,f,N,verbose)
    [Nh,X] = hist([yin,yest],N_hist);
    subplot(232)
    barh(X,Nh)
    title('Histograms')
    legend('data','fit',1)
    axis tight,xlabel('samples')

    [Nh,X] = hist(yres,N_hist);
    subplot(235)
    barh(X,Nh,'k')
    title('Residual histogram')
    xlabel('samples')
    axis tight
    
    samples_per_period = abs(1/(f*ts));

    new_N=ceil(N_per*samples_per_period);
    if N >= new_N %if at least N_per (16) periods are found
        N = new_N;
        %selected_samples=1:N;
        %t = t(selected_samples);
        %yin = yin(selected_samples);
        %yest = yest(selected_samples);
        %yres = yres(selected_samples);
    else
        N_per=floor(N/samples_per_period);
    end

    selected_samples=1:N;
    subplot(231)
    plot(t(selected_samples),yin(selected_samples),'b',t(selected_samples),yest(selected_samples),'r')
    axis tight
    title([int2str(N_per),' periods plotted'])
    legend('data','fit',1)
    xlabel('t (s)')
    ylabel('amplitude')
    ylimy = get(gca,'YLim');
    
    subplot(234)
    plot(t(selected_samples),yres(selected_samples),'k')
    xlabel('time (s)')
    axis tight
    title(['Residual, ',int2str(N_per),' periods'])
    axis tight
    xlabel('t (s)')
    ylabel('amplitude')
    ylime = get(gca,'YLim');

    subplot(232)
    set(gca,'YLim',ylimy)
    subplot(235)
    set(gca,'YLim',ylime)

    tt=mod(t,1/f);
    [tt,index]=sort(tt);
    yy=yin(index);
    yyest=yest(index);
    yyresi = yres(index);
    subplot(233)
    plot(tt,yy,'b.',tt,yyest,'r','MarkerSize',4)
    title('trace period plot')  % file ID: #22907
    axis tight,legend('data','fit',1),xlabel('time, 1 period')
    set(gca,'YLim',ylimy)
    subplot(236)
    plot(tt,yyresi,'k.','MarkerSize',4)
    title('trace period plot, residual'), axis tight
    xlabel('time, 1 period')
    set(gca,'YLim',ylime)
    if verbose
        fprintf('done\n')
    end

function y = rms(x,N)
    y = norm(x)/sqrt(N);
