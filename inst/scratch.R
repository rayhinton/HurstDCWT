library(devtools)
library(usethis)

load_all("/home/rayhinton/Documents/PhD_classes/600_comp/project/HurstDCWT")

library(wavethresh)

data(boat)


manual_dwt <- image_dwt_mult(boat, 8)
thresh_im_dwt <- wavethresh::imwd(boat, filter.number = 2,
                      family = "DaubExPhase",
                      bc = "periodic")

manual_dwt |> access_dwt2D(1, "diagonal") |> log_e_region()

boat_energies <- get_energies(manual_dwt, location_stat = "mean")
