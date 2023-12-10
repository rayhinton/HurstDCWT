# HurstDCWT - estimate the Hurst exponent for 2D signals using discrete complex wavelet transforms

This package can be used to calculate the Hurst exponent for 2D signals such as images using discrete complex wavelet transforms. 

## Install

```
devtools::install_github("rayhinton/HurstDCWT", dependencies = TRUE, build_vignettes = TRUE)
```

## Example usage

See the vignette for a more detailed example: `vignette("simple-usage", "HurstDCWT")`.

```R
# load a provided sample data matrix of simulated fractional Brownian motion
data(fbm2d_512_75)

# compute the DCWT to 8 levels of decomposition
fbm_dwt <- image_dwt_mult(fbm2d_512_75, 8, 
                          family = "LinaMayrand", filter.number = 5.1)

# access the 1st level diagonal region
diag_1 <- access_dwt2d(fbm_dwt, 1, "diagonal")

# calculate the level-wise energies
fbm_energies <- get_energies(fbm_dwt, location_stat = "mean")
# estimate the slope of the wavelet spectra
fbm_slope_params <- get_slope(fbm_energies)

# estimate the Hurst exponent
est_H(fbm_slope_params)
```
