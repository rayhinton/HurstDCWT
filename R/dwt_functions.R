#' Perform limited 1D DWT with wavethresh::wd()
#'
#' perform and return a (potentially) limited number of levels of DWT decomposition with [wavethresh::wd()], rather than the full decomposition which `wd()` returns be default.
#' @param fulldecomp a [wavethresh::wd()] object
#'
#' @param num_decomp integer, starting from 1. the number of levels of decomposition to return
#'
#' @returns a vector containing the smooth and detail coefficients at the desired level (in that order, increasing in levels of detail).
#'
#' @export

decomp_at_level <- function(fulldecomp, num_decomp = NULL) {
    num_levels <- log2(length(wavethresh::accessC(fulldecomp))) - 1
    if (is.null(num_decomp)) {
        num_decomp <- num_levels
    }
    start_level <- num_levels - num_decomp + 1
    end_level <- start_level + num_decomp - 1

    decomp_vec <- c(wavethresh::accessC(fulldecomp, level = start_level))

    for (i in start_level:end_level) {
        decomp_vec <- c(decomp_vec, wavethresh::accessD(fulldecomp, level = i))
    }
    return(decomp_vec)
}

#' perform DWT on a matrix, i.e. a 2D signal.
#' @param image_mat a square matrix
#' @inheritParams decomp_at_level
#'
#' @returns a square matrix
#'
#' @export
image_dwt <- function(image_mat, num_decomp = NULL) {
    # TODO check that input image_mat is square
    # TODO and check that dimensions are power of 2

    # the number of levels of decomposition that are performed
    if (is.null(num_decomp)) {
        num_decomp <- log2(nrow(image_mat))
    }

    mid_wave <- matrix(NA, nrow = nrow(image_mat), ncol = ncol(image_mat))
    for (i in 1:nrow(image_mat)) {
        # TODO need to extract the single level coefficients (detail and smooth)
        # - needs to be done by giving the index of the level to extract
        # - the "first" level is not 1; need to calculate the level I want based on the size of the matrix
        # - alternatively - could I just do the full decomposition all in one shot?
        # - or, can WaveThresh limit the levels of decomposition?
        this_wd <- wavethresh::wd(image_mat[i, ],
                      family = "DaubExPhase", filter.number = 2)
        this_decomp <- decomp_at_level(this_wd, num_decomp)
        # mid_wave[i, ] <- c(accessC(this_wd, level = num_levels),
        #                    accessD(this_wd, level = num_levels))
        mid_wave[i, ] <- this_decomp
    }

    out_wave <- matrix(NA, nrow = nrow(mid_wave), ncol = ncol(mid_wave))
    for (i in 1:ncol(mid_wave)) {
        this_wd <- wavethresh::wd(mid_wave[, i],
                      family = "DaubExPhase", filter.number = 2)
        this_decomp <- decomp_at_level(this_wd, num_decomp)
        # out_wave[, i] <- c(accessC(this_wd, level = num_levels),
        # accessD(this_wd, level = num_levels))
        out_wave[, i] <- this_decomp
    }

    return(out_wave)
}

#' perform multiple levels of DWT decomposition on a matrix, i.e. 2D signal.
#' @param image_mat a square matrix
#' @inheritParams decomp_at_level
#'
#' @returns a list with the following
#' * `dwt`
#' * `nlevels`
#'
#' @export
image_dwt_mult <- function(image_mat, num_decomp) {
    # TODO check image is square
    # TODO check dimensions are a power of 2

    output_dwt <- image_mat
    im_size <- nrow(image_mat)

    for (j in 1:num_decomp) {
        bound <- im_size / 2^(j-1)
        output_dwt[1:bound, 1:bound] <-
            image_dwt(output_dwt[1:bound, 1:bound], 1)
    }

    return(list(dwt = output_dwt, nlevels = num_decomp))
}
