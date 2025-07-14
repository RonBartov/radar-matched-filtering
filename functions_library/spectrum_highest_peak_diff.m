function [spectrumPeaks,freqLoc, peaksDelta] = spectrum_highest_peak_diff(ySamples, xSamples, titleStr)
    [spectrumPeaks,freqLoc] = findpeaks(ySamples, xSamples, 'SortStr', 'descend');
    peaksDelta = spectrumPeaks(1) - spectrumPeaks(2);
    disp(titleStr);
    disp("Highets spectrum peaks difference: " + num2str(peaksDelta) + "dB");
end