library(devtools)
library(usethis)
library(ggplot2)

load_all("/home/rayhinton/Documents/PhD_classes/600_comp/project/HurstDCWT")

library(wavethresh)

data(boat)

manual_dwt <- image_dwt_mult(boat, 8,
                             family = "Lawton", filter.number = 3)
                             # family = "LinaMayrand", filter.number = 5.4)
thresh_im_dwt <- wavethresh::imwd(boat, filter.number = 2,
                      family = "DaubExPhase",
                      bc = "periodic")

manual_dwt |> access_dwt2D(1, "diagonal") |> log_e_region()

boat_energies <- get_energies(manual_dwt, location_stat = "mean")
spectra_fit <- lm(boat_energies$spectra_energies ~ boat_energies$level_vec)

get_slope_params <- get_slope(boat_energies, levels_select = 2:5)
-(-get_slope_params$fit_slope + 2) / 2
est_H(get_slope_params)

# calc H. negative slope because I am plotting the opposite way?
-(-coef(spectra_fit)[2] + 2) / 2

data.frame(level_vec = boat_energies$level_vec,
           spectra_energies = boat_energies$spectra_energies) |>
    ggplot(aes(x = level_vec, y = spectra_energies)) +
    geom_point() +
    geom_abline(intercept = coef(spectra_fit)[1],
                slope = coef(spectra_fit)[2],
                color = "red")

#####

# load test fBm data

fbm_data <- data("fbm2d_512_75")
# fbm_mat <- read.table("~/Documents/PhD_classes/600_comp/project/Hurst_DCWT_explore/fbm_data.csv")
# image(fbm_mat)
image(t(fbm_data[512:1, ]))

fbm_dwt <- image_dwt_mult(fbm_data, 8,
                          family = "Lawton", filter.number = 3)
                        # family = "LinaMayrand", filter.number = 5.4)
fbm_energies <- get_energies(fbm_dwt, location_stat = "mean")
fbm_slope_params <- get_slope(fbm_energies)
est_H(fbm_slope_params)

plot(fbm_energies$level_vec, fbm_energies$spectra_energies)
abline(fbm_slope_params$fit_int, fbm_slope_params$fit_slope, col = "red")

image(t(sqrt(Mod(fbm_dwt$dwt[512:1, ]))), col = gray.colors(256))

boat_dwt_forplot <- sqrt(Mod(manual_dwt$dwt))
boat_dwt_forplot <- (boat_dwt_forplot - min(boat_dwt_forplot)) /
    (max(boat_dwt_forplot) - min(boat_dwt_forplot))
image(t(boat_dwt_forplot[512:1, ]), col = gray.colors(256))

image(t(boat[512:1, ]), col = gray.colors(256))

summary(as.vector(boat_dwt_forplot))
