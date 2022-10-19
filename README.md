# Noise Estimation, Denoising, and Deblurring

This software is a collection of algorithms for noise estimation, denoising, and deblurring developed by the Signal and Image Restoration group of the Tampere Univesrsity. It has been first developed to process the data described in the paper E. Mäntylä, T.Montonen, L. Azzari, S. Mattola, M. Hannula, M. Vihinen-Ranta, J. Hyttinen, M. Vippola, A. Foi, S. Nymark, T. O. Ihalainena, _Signal-resolved intensity-enhanced nanoscopy of nuclear lamina_. 

## Algorithm steps:
    
    1) estimate the noise affecting the stack,
    2) denoise according to the estimated parameters,
    3) [optional] apply a linear deconvolution to perform deblurring.

The processing pipeline is fully automated, thus given an input path and an output path the software is capable of returning a _decently_ processed stack. However, we also give the user the possibility of changing few processing parameters that will help to get better results. The optional processing parameters are explained in detail in the help of the **processData.m** function (main function).

This software is a wrapper for a collection of other algorithms. Thus, the necessary packages must be downloaded separately. Below we list the required packages and relative links. NOTE: the **demo.m** script automatically downloads and extracts the necessary packages and adds them to the working path of Matlab.

## List of required external packages:

* [clipPoisGaus](https://webpages.tuni.fi/foi/ClipPoisGaus_stdEst2D_v232.zip) for noise estimation.
* [invansc_v3](https://webpages.tuni.fi/foi/invansc/invansc_v3.zip) for variance stabilization.
* [rf3d](https://webpages.tuni.fi/foi/GCF-BM3D/RF3D_v1p1p1.zip) for denoising.

## How to efficiently process a sequence:

The RF3D denoising filter is not optimized for large data. This wrapper tries to cope with this by dividing and processing a sequence tile-by-tile. That is, a 3D sequence is divided in spatially overlapping NxMxF tiles, where F is the total number of frames. As the amount of memory required for the processing increases linearly with F, if F is too large then Matlab will run out of memory fast enough. To avoid this problem, we recommend to temporally divide a sequence in the desired amount of frames, and to process each chunk of sequence independently. As an example, a video of size 1080x1080x350 is enough to eat up to 120GB of RAM. Thus, for a working laptop with 16GB/32GB we do not recommend to try to process more than 50 frames per time (at 1080x1080 resolution).


---

The codes are available for non-commercial use only. For details, see LICENSE.

Author of the wrapper: Lucio Azzari [lucio.azzari@tuni.fi](lucio.azzari@tuni.fi)
