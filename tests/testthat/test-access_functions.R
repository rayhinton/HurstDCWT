# error checking for thresh_region()

test_that("requesting an improper region generates error", {
    expect_error(thresh_region("x"),
                 regexp = "does not match any region names")
})

#####

set.seed(1)
X_mat <- matrix(rnorm(512*512), ncol = 512, nrow = 512)

manual_dwt_3 <-
    HurstDCWT::image_dwt_mult(X_mat, 3,
                              family = "DaubExPhase", filter.number = 2)
thresh_im_dwt <- wavethresh::imwd(X_mat, filter.number = 2,
                                  family = "DaubExPhase",
                                  bc = "periodic")

# diagonal at 1 level
test_that("first level diagonal equals WaveThresh", {
    expect_equal(access_dwt2D(manual_dwt_3, 1, "diagonal"),
                 access_imwd(thresh_im_dwt, 1, "diagonal"))
})
