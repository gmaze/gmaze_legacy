function [AIC , BIC] = aicbic(LLF , numParams , numObs)
%AICBIC Akaike and Bayesian information criteria for model order selection.
%   Given optimized log-likelihood function (LLF) values obtained by fitting 
%   models of the conditional mean and variance to a univariate return series, 
%   compute the Akaike (AIC) and Bayesian (BIC) information criteria. Since 
%   information criteria penalize models with additional parameters, AIC and 
%   BIC are model order selection criteria based on parsimony. When using 
%   either AIC or BIC, models that minimize the criteria are preferred.
%
%   [AIC , BIC] = aicbic(LLF , NumParams , NumObs)
%
%   Optional Inputs: NumObs
%
% Inputs:
%   LLF - Vector of optimized log-likelihood objective function (LLF)
%     values associated with parameter estimates of various models. The LLF 
%     values are assumed to be obtained from the estimation function GARCHFIT,
%     or the inference function GARCHINFER. Type "help garchfit" or "help 
%     garchinfer" for details.
%
%   NumParams - Number of estimated parameters associated with each value 
%     in LLF. NumParams may be a scalar applied to all values in LLF, or a 
%     vector the same length as LLF. All elements of NumParams must be 
%     positive integers. NumParams may be obtained from the function 
%     GARCHCOUNT. Type "help garchcount" for details.
%
% Optional Input:
%   NumObs - Sample sizes of the observed return series associated with each 
%     value of LLF. NumObs is required for computing BIC, but is not needed 
%     for AIC. NumObs may be a scalar applied to all values in LLF, or a 
%     vector the same length as LLF. All elements NumObs must be positive 
%     integers. 
%
% Outputs:
%   AIC - Vector of AIC statistics associated with each LLF objective
%     function value. The AIC statistic is defined as:
%
%              AIC = -2*LLF  +  2*NumParams
%
%   BIC - Vector of BIC statistics associated with each LLF objective
%     function value. The BIC statistic is defined as:
%
%              BIC = -2*LLF  +  NumParams*Log(NumObs)
%
% See also GARCHFIT, GARCHINFER, GARCHCOUNT, GARCHDISP.

%   Copyright 1999-2003 The MathWorks, Inc.   
%   $Revision: 1.1.8.1 $   $Date: 2008/04/18 21:15:22 $

%
% References:
%   Box, G.E.P., Jenkins, G.M., Reinsel, G.C., "Time Series Analysis: 
%     Forecasting and Control", 3rd edition, Prentice Hall, 1994.
%

%
% Ensure the optimized LLF is a vector.
%

rowLLF  =  false;

if numel(LLF) == length(LLF)   % Check for a vector.
   rowLLF  =  size(LLF,1) == 1;     % Flag a row vector for outputs.
   LLF     =  LLF(:);               % Convert to a column vector.
else
   error('econ:aicbic:NonVectorLLF' , ' ''LLF'' must be a vector.');
end

%
% Ensure NUMPARAMS is a scalar, or compatible vector, of positive integers.
%

if (nargin < 2)

   error('econ:aicbic:UnspecifiedNumParams' , ' Number of parameters ''NumParams'' must be specified.');

else

   if numel(numParams) ~= length(numParams)    % Check for a vector.
      error('econ:aicbic:NonVectorNumParams' , ' ''NumParams'' must be a vector.');
   end

   numParams  =  numParams(:);

   if any(round(numParams) - numParams) || any(numParams <= 0)
      error('econ:aicbic:NonPositiveNumParams' , ' All elements of ''NumParams'' must be positive integers.')
   end

   if length(numParams) == 1
      numParams  =  numParams(ones(length(LLF),1)); % Scalar expansion.
   end

   if length(numParams) ~= length(LLF)
      error('econ:aicbic:VectorLengthMismatch1' , ' Length of ''NumParams'' and ''LLF'' must be the same.');
   end

end

%
% Ensure NUMOBS is a scalar, or compatible vector, of positive integers.
% Note that the error checking is performed only when BIC is requested.
%

if nargout >= 2

   if nargin < 3
      error('econ:aicbic:UnspecifiedNumObs' , ' Sample size ''NumObs'' is required for BIC.');
   end

   if numel(numObs) ~= length(numObs)    % Check for a vector.
      error('econ:aicbic:NonVectorNumObs' , ' ''NumObs'' must be a vector.');
   end

   numObs  =  numObs(:);

   if any(round(numObs) - numObs) || any(numObs <= 0)
      error('econ:aicbic:NonPositiveNumObs' , ' All elements of ''NumObs'' must be positive integers.')
   end

   if length(numObs) == 1
      numObs  =  numObs(ones(length(LLF),1)); % Scalar expansion.
   end

   if length(numObs) ~= length(LLF)
      error('econ:aicbic:VectorLengthMismatch2' , ' Sizes of ''NumObs'' and ''LLF'' must be the same.');
   end

end

%
% Compute AIC.
%

AIC  =  -2 * LLF  +  2 * numParams;

%
% Compute BIC if requested.
%

if nargout >= 2

   BIC  =  -2 * LLF  +  numParams .* log(numObs);

else

   BIC  =  [];

end

%
% Re-format outputs for compatibility with the LLF input. When LLF is
% input as a single row vector, then pass the outputs as a row vectors. 
%

if rowLLF
   AIC  =  AIC(:).';
   BIC  =  BIC(:).';
end