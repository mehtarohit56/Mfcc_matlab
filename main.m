% MFCC Mel frequency cepstral coefficient feature extraction.
%
%   MFCC(S,FS,TW,TS,ALPHA,WINDOW,R,M,N,L) returns mel frequency
%   cepstral coefficients (MFCCs) computed from speech signal given
%   in vector S and sampled at FS (Hz). The speech signal is first
%   preemphasised using a first order FIR filter with preemphasis
%   coefficient ALPHA. The preemphasised speech signal is subjected
%   to the short-time Fourier transform analysis with frame durations
%   of TW (ms), frame shifts of TS (ms) and analysis window function
%   given as a function handle in WINDOW. This is followed by magnitude
%   spectrum computation followed by filterbank design with M triangular
%   filters uniformly spaced on the mel scale between lower and upper
%   frequency limits given in R (Hz). The filterbank is applied to
%   the magnitude spectrum values to produce filterbank energies (FBEs)
%   (M per frame). Log-compressed FBEs are then decorrelated using the
%   discrete cosine transform to produce cepstral coefficients. Final
%   step applies sinusoidal lifter to produce liftered MFCCs that
%   closely match those produced by HTK [1].
%
%   [CC,FBE,FRAMES]=MFCC(...) also returns FBEs and windowed frames,
%   with feature vectors and frames as columns.
%
%   This framework is based on Dan Ellis' rastamat routines [2]. The
%   emphasis is placed on closely matching MFCCs produced by HTK [1]
%   (refer to p.337 of [1] for HTK's defaults) with simplicity and
%   compactness as main considerations, but at a cost of reduced
%   flexibility. This routine is meant to be easy to extend, and as
%   a starting point for work with cepstral coefficients in MATLAB.
%   The triangular filterbank equations are given in [3].
%
%   Inputs
%           S is the input speech signal (as vector)
%
%           FS is the sampling frequency (Hz)
%
%           TW is the analysis frame duration (ms)
%
%           TS is the analysis frame shift (ms)
%
%           ALPHA is the preemphasis coefficient
%
%           WINDOW is a analysis window function handle
%
%           R is the frequency range (Hz) for filterbank analysis
%
%           M is the number of filterbank channels
%
%           N is the number of cepstral coefficients
%             (including the 0th coefficient)
%
%           L is the liftering parameter
%
%   Outputs
%           CC is a matrix of mel frequency cepstral coefficients
%              (MFCCs) with feature vectors as columns
%
%           FBE is a matrix of filterbank energies
%               with feature vectors as columns
%
%           FRAMES is a matrix of windowed frames
%                  (one frame per column)
%
%   Example
          Tw = 25;           % analysis frame duration (ms)
          Ts = 10;           % analysis frame shift (ms)
          alpha = 0.97;      % preemphasis coefficient
          R = [ 300 3700 ];  % frequency range to consider
          M = 20;            % number of filterbank channels
          C = 13;            % number of cepstral coefficients
          L = 22;            % cepstral sine lifter parameter

%           % hamming window (see Eq. (5.2) on p.73 of [1])
           hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
%
%           % Read speech samples, sampling rate and precision from file
           [ speech, fs, nbits ] = wavread( 'sp10.wav' );
%
%           % Feature extraction (feature vectors as columns)
           [ MFCCs, FBEs, frames ] = ...
                           mfcc( speech, fs, Tw, Ts, alpha, hamming, R, M, C, L );
%
%           % Plot cepstrum over time
           figure('Position', [30 100 800 200], 'PaperPositionMode', 'auto', ...
                  'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' );
%
MFCCs
          imagesc( [1:size(MFCCs,2)], [0:C-1], MFCCs );
           axis( 'xy' );
           xlabel( 'Frame index' );
           ylabel( 'Cepstrum index' );
           title( 'Mel frequency cepstrum' );
%
%   References
%
%           [1] Young, S., Evermann, G., Gales, M., Hain, T., Kershaw, D.,
%               Liu, X., Moore, G., Odell, J., Ollason, D., Povey, D.,
%               Valtchev, V., Woodland, P., 2006. The HTK Book (for HTK
%               Version 3.4.1). Engineering Department, Cambridge University.
%               (see also: http://htk.eng.cam.ac.uk)
%
%           [2] Ellis, D., 2005. Reproducing the feature outputs of
%               common programs using Matlab and melfcc.m. url:
%               http://labrosa.ee.columbia.edu/matlab/rastamat/mfccs.html
%
%           [3] Huang, X., Acero, A., Hon, H., 2001. Spoken Language
%               Processing: A guide to theory, algorithm, and system
%               development. Prentice Hall, Upper Saddle River, NJ,
%               USA (pp. 314-315).
%
%   See also EXAMPLE, COMPARE, FRAMES2VEC, TRIFBANK.

%   Author: Kamil Wojcicki, September 2011
