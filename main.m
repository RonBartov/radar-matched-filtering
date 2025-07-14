clear vars
close all
clear classes
clc

% Get access to the functions files
addpath(genpath('functions_library'));
%% Home Assignment: Radar Signal Processing

% Constants that will be used in all questions
SPEED_OF_LIGHT = 3e8;
TAU = 50e-6; % Pulse duration (seconds)
R_TARGET = 50e3; % Target range (meters) 
F_S = 5e6; % Sampling frequency (Hz)
MAX_RANGE = 120e3; % Maximum range (meters)

%% Question 1: Pulse Radar
%% (a) Received Signal Due to a Target in Time Domain

% sampling parameters
ts = 1/F_S; % Sampling period (seconds)
N = ceil((2*MAX_RANGE/SPEED_OF_LIGHT) / ts); % Number of samples

% Generate time and range axes
tAxis = (0:N-1) * ts; % Time vector
rAxis = tAxis * SPEED_OF_LIGHT / 2; % Convert time to range

% Generate received signal
xReceived = zeros(1, N); % Initialize signal with zeros
delaySamples = round((2*R_TARGET/SPEED_OF_LIGHT) / ts); % Calculate delay in samples
xReceived(delaySamples:delaySamples + round(TAU/ts) - 1) = 1; % Square pulse

% Plot received signal in time domain (converted to range)
PlotClass.line_plot(rAxis/1e3, xReceived, 'Question 1.a: Received Signal in Time Domain', 'Range (km)', 'Amplitude', [0 MAX_RANGE/1e3]);

%% (b) Frequency domain representation using FFT
X_f = fft(xReceived); % Compute FFT
freqAxis = linspace(-F_S/2, F_S/2, N); %fs/N*(-N/2:N/2-1)% Frequency axis

% Plot the magnitude spectrum
%PlotClass.centered_fft_plot(X_f, freqAxis/1e6 , 'Question 1.b: Frequency Domain Representation of the Received Signal', 'Frequency (MHz)', 'Magnitude (dB)', 'manual_db');
PlotClass.logarithmic_plot(freqAxis/1e6, abs(fftshift(X_f)), 'Question 1.b: Frequency Domain Representation of the Received Signal', 'Frequency (MHz)', 'Magnitude (dB)', 'manual_db')

% Measure peak difference
centeredSpectrumDb = 20*log10(abs(fftshift(X_f)));
[spectrumPeaks,freqLoc, peaksDelta] = spectrum_highest_peak_diff(centeredSpectrumDb, freqAxis, "Question 1.b: Two Highest Peaks Difference");

%% (c) Matched Filter Implementation
hMf = fliplr(xReceived); % Time-reversed signal for matched filtering
yMf = conv(xReceived, hMf, 'same'); % Apply matched filter

% Plot matched filter output in range domain
PlotClass.line_plot(rAxis/1e3, yMf, 'Question 1.c: Matched Filter Output', 'Range (km)', 'Amplitude', [0 MAX_RANGE/1e3])

%% (d) Adding Gaussian Noise
sigma = 2; % Standard deviation of noise
noise = sigma * randn(1, N); % Generate Gaussian noise
xNoisy = xReceived + noise; % Add noise to the signal

% Plot noisy signal
PlotClass.line_plot(rAxis/1e3, xNoisy, 'Question 1.d: Noisy Received Signal in Time Domain', 'Range (km)', 'Amplitude', [0 MAX_RANGE/1e3])

% Apply matched filtering to noisy signal
yMfNoisy = conv(xNoisy, hMf, 'same');

% Plot matched filter output with noise
PlotClass.line_plot(rAxis/1e3, yMfNoisy, 'Question 1.d: Matched Filter Output with Noise in Time Domain', 'Range (km)', 'Amplitude', [0 MAX_RANGE/1e3])


%% Question 2: Linear Frequency Modulation (LFM) Pulse Radar
%% (a) Received Signal Due to a Target in Time Domain
% Define constants for this question
BW = 1e6; % Bandwidth (Hz)

% Generate LFM pulse
tAxisLfm = -TAU/2:ts:TAU/2; % New time axis due to time shift
xLfm = exp(1i * pi * BW / TAU * tAxisLfm.^2); % LFM single pulse signal

% Generate received LFM signal
xLfmReceived = zeros(1, N);
xLfmReceived(delaySamples:delaySamples + length(xLfm) - 1) = xLfm;

% Plot received LFM signal in time domain
PlotClass.line_plot(rAxis/1e3, abs(xLfmReceived), 'Question 2.a: Received LFM Signal in Time Domain', 'Range (km)', 'Amplitude', [0 MAX_RANGE/1e3])

%% (c) Matched Filter Implementation
% Compute matched filter for LFM
hMfLfm = conj(xLfm); % Matched filter
yLfmMf = conv(xLfmReceived, hMfLfm, 'same');

% Plot matched filter output for LFM
PlotClass.line_plot(rAxis/1e3, abs(yLfmMf), 'Question 2.c: Matched Filter Output for LFM Received Signal in Time Domain', 'Range (km)', 'Amplitude', [0 MAX_RANGE/1e3]);

%% (d) Adding Gaussian Noise
xLfmNoisy = xLfmReceived + noise; % Add noise to the signal

% Plot noisy signal
PlotClass.line_plot(rAxis/1e3, abs(xLfmNoisy), 'Question 2.d: Noisy Received LFM Signal in Time Domain', 'Range (km)', 'Amplitude', [0 MAX_RANGE/1e3])

% Apply matched filtering to noisy signal
yLfmMfNoisy = conv(xLfmNoisy, hMfLfm, 'same');

% Plot matched filter output with noise
PlotClass.line_plot(rAxis/1e3, abs(yLfmMfNoisy), 'Question 1.d: Matched Filter Output for LFM Received Signal with Noise in Time Domain', 'Range (km)', 'Amplitude', [0 MAX_RANGE/1e3])


%% Question 3: Target Detection Using LFM Radar

% Using previous question LFM signal (plotting for comparison)
xLfmNoisyTwo = xLfmNoisy;
PlotClass.line_plot(rAxis/1e3, abs(xLfmNoisyTwo), 'Question 3: Noisy Received LFM Signal Before Adding Strong Noise', 'Range (km)', 'Amplitude', [0 MAX_RANGE/1e3]);

% Adding additional noise up to 30km (plotting for comparison)
sigma30 = 20; % Standard deviation of noise
noise30 = sigma30 * randn(1, N); % Generate Gaussian noise
lowerThan30Region = (rAxis < 30e3);
xLfmNoisyTwo(lowerThan30Region) = xLfmNoisyTwo(lowerThan30Region) + noise30(lowerThan30Region);
PlotClass.line_plot(rAxis/1e3, abs(xLfmNoisyTwo), 'Question 3: Noisy Received LFM Signal with Additional High Noise Up to 30km', 'Range (km)', 'Amplitude', [0 MAX_RANGE/1e3]);

% Apply matched filtering to the noisy signal
yLfmMfNoisyTwo = conv(xLfmNoisyTwo, hMfLfm, 'same');

% Take the absolute value and plot
yLfmMfNoisyTwoAbs = abs(yLfmMfNoisyTwo);
PlotClass.line_plot(rAxis/1e3, yLfmMfNoisyTwoAbs, 'Question 3: Matched Filter Output for LFM Received Signal with High Noise in Time Domain', 'Range (km)', 'Amplitude', [0 MAX_RANGE/1e3])


%% (a) Target Detection - Method 1: Average Global Threshold
% Define constants for the section
TH_FACTOR = 5.6;

% Calculate the threshold
signalAvg = mean(yLfmMfNoisyTwoAbs);
th1 = TH_FACTOR * signalAvg;
th1Vec = th1 * ones(1,N); 

% Split the match filter output to targets and non-targets parts
[th1Targets,th1NonTargets] = classify_targets_from_th(yLfmMfNoisyTwoAbs, th1);

% Plotting the results 
PlotClass.logarithmic_plot(rAxis/1e3, th1NonTargets, 'Question 3.a: Target Detection with Averaging', 'Range (km)', 'Amplitude (dB)', 'manual_db', 'first');
PlotClass.logarithmic_plot(rAxis/1e3, th1Targets, 'Question 3.a: Target Detection with Averaging', 'Range (km)', 'Amplitude (dB)', 'manual_db', 'added');
PlotClass.logarithmic_plot(rAxis/1e3, th1Vec, 'Question 3.a: Target Detection with Averaging', 'Range (km)', 'Amplitude (dB)', 'manual_db', 'last', ["Non-Targets", "Detected Targets", "Threshold"]);

%% (b) Target Detection - Method 2: Moving Average Threshold
% Define constants for the section
WINDOW_SIZE = 32;

% Calculate the moving average filter
maFilter = ones(1, WINDOW_SIZE) / WINDOW_SIZE;

% Calculate the threshold
signalMovAvg = conv(yLfmMfNoisyTwoAbs, maFilter, 'same');
th2Vec = TH_FACTOR * signalMovAvg;


% Split the match filter output to targets and non-targets parts
[th2Targets,th2NonTargets] = classify_targets_from_th(yLfmMfNoisyTwoAbs, th2Vec);

PlotClass.logarithmic_plot(rAxis/1e3, th2NonTargets, 'Question 3.b: Target Detection with Moving Averaging', 'Range (km)', 'Amplitude (dB)', 'manual_db', 'first');
PlotClass.logarithmic_plot(rAxis/1e3, th2Targets, 'Question 3.b: Target Detection with Moving Averaging', 'Range (km)', 'Amplitude (dB)', 'manual_db', 'added');
PlotClass.logarithmic_plot(rAxis/1e3, th2Vec, 'Question 3.b: Target Detection with Moving Averaging', 'Range (km)', 'Amplitude (dB)', 'manual_db', 'last', ["Non-Targets", "Detected Targets", "Threshold"]);

%% (c) Target Detection - Method 3: Custom Filter-Based Threshold
% Define constants for the section
WINDOW_SIZE = 32;

% Calculate the custom filter
h_tmp = ones(1, 16) / WINDOW_SIZE;
customFilter = [h_tmp zeros(1,7) h_tmp];

% Calculate the threshold
signalCustomAvg = conv(yLfmMfNoisyTwoAbs, customFilter, 'same');
th3Vec = TH_FACTOR * signalCustomAvg;


% Split the match filter output to targets and non-targets parts
[th3Targets,th3NonTargets] = classify_targets_from_th(yLfmMfNoisyTwoAbs, th3Vec);

PlotClass.logarithmic_plot(rAxis/1e3, th3NonTargets, 'Question 3.c: Target Detection with Custom Filter', 'Range (km)', 'Amplitude (dB)', 'manual_db', 'first');
PlotClass.logarithmic_plot(rAxis/1e3, th3Targets, 'Question 3.c: Target Detection with Custom Filter', 'Range (km)', 'Amplitude (dB)', 'manual_db', 'added');
PlotClass.logarithmic_plot(rAxis/1e3, th3Vec, 'Question 3.c: Target Detection with Custom Filter', 'Range (km)', 'Amplitude (dB)', 'manual_db', 'last', ["Non-Targets", "Detected Targets", "Threshold"]);

%% (d) Target Detection: Compare Threshold Methods with Histogram
maxHistogramRange = max(20*log10(yLfmMfNoisyTwoAbs));
PlotClass.histogram_plot(20*log10(th1Targets), [0, maxHistogramRange], 'Question 3.d: Detected Targets Histogram for TH1', 'Number of Samples' , 'Target Received Amplitude');
PlotClass.histogram_plot(20*log10(th2Targets), [0, maxHistogramRange], 'Question 3.d: Detected Targets Histogram for TH2', 'Number of Samples' , 'Target Received Amplitude');
PlotClass.histogram_plot(20*log10(th3Targets), [0, maxHistogramRange], 'Question 3.d: Detected Targets Histogram for TH3', 'Number of Samples' , 'Target Received Amplitude');
