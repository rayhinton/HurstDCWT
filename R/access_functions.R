#' a function to return the region label numbers used by WaveThresh
#' @param input_label string that specifies one of the regions in the 2D DWT. will match on the first character.
#'
#' @returns an integer that corresponds to the region as labeled by WaveThresh
#' @export
thresh_region <- function(input_label) {
    region_pattern <- paste0("^", input_label)
    region_names <- c("horizontal", "vertical", "diagonal", "scaling")
    return_label <- which(grepl(region_pattern, region_names, ignore.case = TRUE,
                                perl = TRUE))
    # test for invalid labels
    if (length(return_label) == 0) {
        stop(paste0("region label '", input_label ,"' does not match any region names."))
    }

    return(return_label)
}

# a function to access one region from a level of a WaveThresh imwd object
# TODO consider making this work with either string or integer inputs for the region, i.e., so that you can loop through the numbers of the region labels

# TODO if I just return the vectors, could I neatly turn a vector of all the levels of coefficients into the final matrix in one step?

#' Access a particular region from a WaveThresh imwd object
#' @param imwd_object a WaveThresh [wavethresh::imwd()] class object
#'
#' @param my_level integer. the desired level of the DWT return, where 1 is the largest level (most detailed). Note that this is the opposite of how the levels are numbered in WaveThresh (and starts at 1, not 0).
#' @param my_region character, to match one of c("horizontal", "vertical", "diagonal", "scaling"). will match the whole string or just initial character(s).
#' @returns a matrix containing the DWT coefficients from the selected level.
#' @export
access_imwd <- function(imwd_object, my_level, my_region) {
    t_level <- imwd_object$nlevels - my_level
    t_region <- thresh_region(my_region)

    t_level_region <- paste0("w", t_level, "L", t_region)

    region_vec <- imwd_object[[t_level_region]]

    region_matrix <- matrix(region_vec, ncol = sqrt(length(region_vec)),
                            byrow = FALSE)

    return(region_matrix)
}

#' Access a particular region from a DWT calculated with image_dwt_mult().
#' @param dwt2D_object an object returned from [image_dwt_mult()].
#' @inheritParams access_imwd
#'
#' @returns a matrix containing the DWT coefficients from the selected level.
#' @export
access_dwt2D <- function(dwt2D_object, my_level, my_region) {
    region_names <- c("horizontal", "vertical", "diagonal", "scaling")
    selected_name_filter <- grepl(paste0("^", my_region), region_names,
                                  perl = TRUE, ignore.case = TRUE)
    # TODO add a check that fails if 0 or more than 1 matching region is found
    selected_region <- region_names[selected_name_filter]

    if (selected_region == "scaling" & my_level < dwt2D_object$nlevels) {
        stop(paste0("Cannot select scaling level ", my_level, ". Only scaling level ", dwt2D_object$nlevels, " is available."))
    }

    # the bound is the length of the side of the DWT, divided by 2 to the level
    bound <- nrow(dwt2D_object$dwt) / (2^my_level)

    # upper right, horizontal
    # say, for 512 by 512, first level
    # 1:256, 257:512
    # 1 to bound, bound+1 to 2*bound
    if (selected_region == "horizontal") {
        returned_region <- dwt2D_object$dwt[1:bound, (bound+1):(2*bound)]
    } else if (selected_region == "diagonal") {
        returned_region <- dwt2D_object$dwt[(bound+1):(2*bound),
                                            (bound+1):(2*bound)]
    } else if (selected_region == "vertical") {
        returned_region <- dwt2D_object$dwt[(bound+1):(2*bound), 1:bound]
    } else if (selected_region == "scaling") {
        # upper left, scaling
        # TODO can only access scaling for the final level of decomposition
        returned_region <- dwt2D_object$dwt[1:bound, 1:bound]
    }

    return(returned_region)

    # lower right, diagonal

    # lower left, vertical

    # levels for 512 to 512,
    # 65:128, 1:64, bound = 64
    # 129:256, 1:128, bound = 128
    # 257:512, 1:256, bound = 512 / (2^1) = 256

}
