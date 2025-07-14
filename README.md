# Radar Matched Filtering

## About the Project

This repository provides a complete simulation for radar signal processing using matched filtering. It demonstrates how rectangular and LFM (linear frequency modulation) pulses behave in time and frequency domains, and how matched filters can enhance signal detection under noisy conditions. The simulation includes several thresholding techniques for target detection, showcasing their effectiveness through detailed plots.

## Built With

- MATLAB
- Signal processing concepts (matched filtering, LFM, SNR improvement)
- Custom MATLAB functions and plotting classes

## Getting Started

To run the project locally:

1. Clone the repository:
   ```bash
   git clone git@github.com:RonBartov/radar-matched-filtering.git
   cd radar-matched-filtering
   ```

2. Open MATLAB in this folder.

3. Run the main script:
   ```matlab
   main.m
   ```

### Project Structure

- `main.m` – The main simulation script containing the entire radar analysis flow.
- `functions_library/` - Folder with helper functions:
  - `PlotClass.m` - Custom plotting utilities.
  - `classify_targets_from_th.m` - Threshold-based target classification.
  - `spectrum_highest_peak_diff.m` - Spectrum peak comparison tool.
- `radar_detection_and_matched_filter.pdf` - Accompanying explanation and results report.

## Acknowledgment

Implemented by Ron Bartov as part of a radar signal processing project.  
The simulation is grounded in concepts such as convolution, spectral analysis, and statistical thresholding in noisy radar environments.

## Rights

This repository is shared for educational and academic purposes only.  
Do not use for commercial or unauthorized purposes without permission.  
To contribute or reuse, please contact the repository owner.
