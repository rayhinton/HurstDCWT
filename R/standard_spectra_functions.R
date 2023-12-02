#' log energy of one region
#'
#' @param region_mat matrix for a single region of a 2D DWCT
#' @param location_stat which statistic to use for estimating the energy. currently only "mean" is supported.
#'
#' @returns scalar, the log2 of the estimated coefficient energy in the region
#' @export
log_e_region <- function(region_mat, location_stat = "mean") {
    if (location_stat == "mean") {
        log_energy <- log2(mean(Mod(region_mat)^2))
    }

    return(log_energy)
}

#' Calculate log energies for selected levels
#'
#' @param level_vec a vector of the levels of decomposition to use
#' @param region_vec a single string or vector of the strings of the regious to use
#' @inheritParams access_dwt2D
#' @inheritParams log_e_region
#'
#' @returns a list with:
#' - `spectra_energies`,
#' - `level_vec`,
#' - `region_vec`,
#' - `location_stat`
#' @export
get_energies <- function(dwt2D_object, level_vec = NULL, region_vec = "diagonal",
                       location_stat) {
# TODO option to just enter the DWT object, and calculate all levels
    if (is.null(level_vec)) {
        level_vec <- 1:dwt2D_object$nlevels
    }

    if (length(region_vec) == 1) {
        region_vec <- rep(region_vec, length(level_vec))
    }

    spectra_energies <- vector("numeric", length(level_vec))
    for (j in 1:length(level_vec)) {
        level_region <- access_dwt2D(dwt2D_object, level_vec[j], region_vec[j])
        spectra_energies[j] <- log_e_region(level_region, location_stat)
    }

    return(list(spectra_energies = spectra_energies,
                level_vec = level_vec,
                region_vec = region_vec,
                location_stat = location_stat))
}
