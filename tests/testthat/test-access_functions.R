set.seed(1)
X_mat <- matrix(rnorm(512*512), ncol = 512, nrow = 512)

manual_dwt_3 <- HurstDCWT::image_dwt_mult(X_mat, 3)
thresh_im_dwt <- wavethresh::imwd(X_mat, filter.number = 2,
                                  family = "DaubExPhase",
                                  bc = "periodic")

# diagonal at 1 level
testthat::expect_equal(access_dwt2D(manual_dwt_3, 1, "diagonal"),
                       access_imwd(thresh_im_dwt, 1, "diagonal"))
