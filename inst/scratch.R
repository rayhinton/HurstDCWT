library(devtools)
library(usethis)

load_all("/home/rayhinton/Documents/PhD_classes/600_comp/project/HurstDCWT")

library(wavethresh)

data(boat)


manual_dwt <- image_dwt(boat, 1)
thresh_im_dwt <- wavethresh::imwd(boat, filter.number = 2,
                      family = "DaubExPhase",
                      bc = "periodic")
