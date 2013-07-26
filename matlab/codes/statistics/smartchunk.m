%smartchunk Compute homogeneous chunks of data
%
% [CHUNKS IDAT SCORE] = smartchunk(DATASET,NWORKER,[ARG,VAL])
% 
% Compute NWORKER homogeneous chunks of data from DATASET so that
% chunks can be dispatch to multiple workers/processes/jobs.
%
% Inputs:
% 	DATASET: is an 1D array of data to chunk
% 	NWORKER: is an integer defining the number of chunks to create
% 
% Options (defined with ARG/VAL pairs):
% 	metric: the function name to compute the metric to be homogeneized 
% 		among chunks. 'nansum' is the default value.
% 		Eg: smartchunk(DATASET,NWORKER,'metric','nanmean')
% 	niter: the optimization maximum number of iteration (1e4 by default)
% 		Eg: smartchunk(DATASET,NWORKER,'niter',5e4)
% 
% Outputs:
% 	CHUNKS: is a 2D array (NWORKER x CHUNKSIZE) with the chunk of DATASET
% 	IDAT: is a 2D array (NWORKER x CHUNKSIZE) with the indeces of DATASET used
% 		by CHUNKS: CHUNKS = DATASET(IDAT)
% 	SCORE: is the optimized minimum std among metrics of chunks.
% 
% Eg:
% 	Minimize the std along size(chunks,1) of the sum of chunks along size(chunks,2):
% 	[chunks, idat, score] = smartchunk([12 2 3 30 18 8],4)
% 
% 	This dataset is chunked into two peaces with equal sum of 10 (thus score = 0):
% 	[chunks, idat, score] = smartchunk([10 2 4 2 2],2)
% 	
% 
% Created: 2013-03-07.
% Copyright (c) 2013, Guillaume Maze (Ifremer, Laboratoire de Physique des Oceans).
% All rights reserved.
% http://codes.guillaumemaze.org

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Ifremer, Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specific prior 
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%

function varargout = smartchunk(pool,nproc,varargin)

%- SET DEFAULT PARAMETERS:
%pool  = varargin{1}; % The dataset to chunk homogeneously 
%nproc = varargin{2}; % The number of chunks
niter  = 1e4; % The optimization maximum number of iteration
metric = @nansum; % The function to use to compute the metric to homogeneize among chunks.

%- LOAD USER PARAMETERS:
in0 = 2;
if nargin > in0
	if mod(nargin,2) ~= 0
		error('Arguments must come in pairs: ARG,VAL')
	end% if 
	for in = 1 : 2 : nargin - in0
		eval(sprintf('%s = varargin{in+1};',varargin{in}));		
	end% for in	
end% if
clear in0

%- CHECK USER PARAMETERS:
tested = 9999;
if ~isa(metric,'function_handle');
	metric = str2func(metric);
end
tested = feval(metric,rand(5,1)); % test the function for non-scalar output
if tested == 9999
	error('Something is weird with this function');
end% if 

if nproc < 0
	error('The number of chunks must be strictly positive')
end% if 

%- COMPUTATION:

% Length of chunks:
chunklength = ceil(length(pool)/nproc)+1; 

% Working pool:
POOL = zeros(1,chunklength*nproc)*NaN;
POOL(1:length(pool)) = pool;

% Optimization loop:
% (we explore niter random permutations)
C = zeros(niter,length(POOL))*NaN;
F = zeros(niter,1)*NaN;
for it = 1 : niter
	ip = randperm(length(POOL));	
	chunks = reshape(POOL(ip),chunklength,nproc);
	chunks_metrics = feval(metric,chunks);
	chunks_metrics_homogeneity_estimate = std(chunks_metrics);
%	chunks_metrics_homogeneity_estimate = std(chunks_metrics-mean(chunks_metrics));
%	chunks_metrics_homogeneity_estimate = abs((median(chunks_metrics) - mean(chunks_metrics))/mean(chunks_metrics));
	
	C(it,:) = ip; % Indeces combination
	F(it) = chunks_metrics_homogeneity_estimate; % Optimum metric
	
end% for it

%- FIND THE OPTIMUM SOLUTION:
[Fopt iopt] = min(F);
Copt = C(iopt,:);

%- FORMAT OUTPUT:
CHUNKS = reshape(POOL(C(iopt,:)),chunklength,nproc); 
IDAT = reshape(C(iopt,:),chunklength,nproc);

[CHUNKS ii] = sort(CHUNKS,1,'descend'); 
for j = 1 : size(CHUNKS,2), 
	IDAT(:,j) = IDAT(ii(:,j),j); 
end% for 
	
[CHUNKS ii] = sort(CHUNKS,2,'descend'); 
for j = 1 : size(CHUNKS,1), 
	IDAT(j,:) = IDAT(j,ii(j,:)); 
end% for
IDAT(isnan(CHUNKS))=NaN;
	
CHUNKS = CHUNKS'; % N_PROC x CHUNK_SIZE
IDAT = IDAT';
 
% Remove columns with NaNs for all procs:
keep = zeros(1,size(CHUNKS,2))*NaN;
for ic = 1 : size(CHUNKS,2)
	if sum(isnan(CHUNKS(:,ic))) == nproc
		keep(ic) = 0;
	else
		keep(ic) = 1;
	end% if 
end% for ic
CHUNKS = CHUNKS(:,keep==1);
IDAT   = IDAT(:,keep==1);

%- OUTPUT:
varargout{1} = CHUNKS;
varargout{2} = IDAT;
varargout{3} = Fopt;

end %functiondispatch






















