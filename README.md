# HurstDCWT - estimate the Hurst exponent for 2D signals using discrete complex wavelet transforms

This package can be used to calculate the Hurst exponent for 2D signals such as images using discrete complex wavelet transforms. 

## Install

`devtools::install_github("rayhinton/HurstDCWT")`

## Example usage

```
# Get the DCWT of an image X (square matrix with side lengths a power of 2) at 5 levels of decomposition
dcwt_X <- image_dwt_mult(X, 5)

# access the 1st level diagonal region
diag_1 <- access_dwt2d(dcwt, 1, "diagonal")
```
