## code to prepare `fbm2d_512_75` dataset goes here

fbm2d_512_75 <- as.matrix(read.csv("data-raw/fbm2d_512_0.75.csv", header = FALSE))

usethis::use_data(fbm2d_512_75, overwrite = TRUE, compress = "xz")
