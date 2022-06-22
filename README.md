# Noise Estimation, Denoising, and Deblurring (NEDD)

This software is a collection of algorithms for noise estimation, denoising, and deblurring developed by the Signal and Image Restoration group of the Tampere Univesrsity.

This software automatically denoises and deblurs a noisy stack of images by:
    
    1) first estimating the noise affecting the stack,
    2) denoising according to the estimated parameters,
    3) applying a linear deconvolution to perform deblurring.

The processing pipeline is fully automated, thus given an input path and an output path the software is capable of returning a _decently_ processed stack. However, we also give the user the possibility of changing few processing parameters that will help him/her to get better results. The optional processing parameters are explained in detail in the help of the **processData.m** function (main function).

This software is basically a wrapper for a collection of other algorithms. Thus, the necessary packages need to be downloaded separately. Below we will list the required softwares and relative links, but if the user runs the **demo.m** script, the demo will automatically download and extract the necessary packages and add them to the working path of Matlab.

List of required external packages:
* [clipPoisGaus Package](https://webpages.tuni.fi/foi/ClipPoisGaus_stdEst2D_v232.zip) for noise estimation.
* [invansc_v3 Package](https://webpages.tuni.fi/foi/invansc/invansc_v3.zip) for variance stabilization.
* [rf3d Package](https://webpages.tuni.fi/foi/GCF-BM3D/RF3D_v1p1p1.zip) for denoising.

The codes are available for non-commercial use only. For details, see LICENSE.

Author of the wrapper: Lucio Azzari [lucio.azzari@tuni.fi](lucio.azzari@tuni.fi)
