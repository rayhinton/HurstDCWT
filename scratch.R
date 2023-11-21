library(devtools)
library(usethis)

library(wavethresh)

tiff_object <- tiff::readTIFF("/home/rayhinton/Documents/PhD_classes/600_comp/project/images_misc/misc/boat.512.tiff")

manual_dwt <- image_dwt(tiff_object, 1)
thresh_im_dwt <- wavethresh::imwd(tiff_object, filter.number = 2,
                      family = "DaubExPhase",
                      bc = "periodic")
