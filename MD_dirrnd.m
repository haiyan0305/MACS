function R = MD_dirrnd(alpha, N, method)
% _
% Dirichlet-distributed random numbers
% FORMAT R = MD_dirrnd(alpha, N, method)
% 
%     alpha  - a  1 x K vector with parameters of the distribution
%     N      - an integer specifying the number of samples to be drawn
%     method - a  string indicating the sampling method to be used
% 
%     R      - an N x K matrix with Dirichlet-distributed random numbers
% 
% FORMAT R = MD_dirrnd(alpha, N, method) returns N samples from the
% Dirichlet distribution with parameters alpha. Random numbers are
% generated by exploiting the fact that Dirichlet random variables are
% normalized standard Gamma variates [1].
% 
% The input variable "method" is optional and specifies whether to use
% - the MATLAB function "gamrnd" (if method is 'MATLAB'), 
% - the SPM function "spm_gamrnd" (if method is 'SPM') or
% - the MACS function "MD_gamrnd" (if method is 'MACS')
% for Gamma random number generation. The default value is 'SPM'.
% 
% References:
% [1] Gelman A, Carlin JB, Stern HS, Dunson DB, Vehtari A, Rubin DB (2013):
%     "Bayesian Data Analysis". Chapman & Hall, 3rd edition, p. 583.
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% 
% First edit: 21/10/2014, 18:30 (V0.2/V6)
%  Last edit: 16/05/2018, 15:50 (V1.2/V18)


% Get dimensionality
%-------------------------------------------------------------------------%
K = numel(alpha);

% Set method if required
%-------------------------------------------------------------------------%
if nargin < 3 || isempty(method), method = 'SPM'; end;

% Generate Gamma random numbers (MATLAB)
%-------------------------------------------------------------------------%
if strcmp(method,'MATLAB')
    R = gamrnd(repmat(alpha,[N 1]),1);
end;
% Note: This is the fastest method of Gamma random number generation,
% but it requires MATLAB's statistics toolbox.

% Generate Gamma random numbers (SPM)
%-------------------------------------------------------------------------%
if strcmp(method,'SPM')
    R = zeros(N,K);
    for j = 1:K
        R(:,j) = spm_gamrnd(alpha(j),1,N,1);
    end;
end;
% Note: Although this takes twice as long as the MATLAB implementation,
% because other than in MATLAB, a for-loop has to be used. However, it
% does not require MATLAB's statistics toolbox.

% Generate Gamma random numbers (MACS)
%-------------------------------------------------------------------------%
if strcmp(method,'MACS')
    R = MD_gamrnd(repmat(alpha,[N 1]),1);
end;
% Note: This is the slowest method of Gamma random number generation,
% because other than in MATLAB (or SPM), the MACS version of "gamrnd"
% is written in MATLAB (and not C). Therefore, the toolbox-own function
% is not used here, in favor of the SPM function.

% Calculate Dirichlet random numbers
%-------------------------------------------------------------------------%
R = R./repmat(sum(R,2),[1 K]);