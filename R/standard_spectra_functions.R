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

#' calculate the spectra slope
#'
#' @param energies_obj a list as provided by [HurstDCWT::get_energies()]
#' @param levels_select a vector with a selection of the levels to use for fitting. either a list of the specific levels, or a list of the level indexes within the `energies_obj$level_vec` vector.
#' @param level_by_index whether to select the levels themselves or by index
#' @param fit_method currently, only ordinary least squares via `"lm"` is supported.
#'
#' @returns a list with:
#' - `fit_slope` slope of the fit line
#' - `fit_int` intercept of the fit line
#' @export
get_slope <- function(energies_obj, levels_select = NULL,
                      level_by_index = FALSE, fit_method = "lm") {
    if (is.null(levels_select)) {
        levels_select <- energies_obj$level_vec
    }

    # provide the specific levels, not the index of the levels within the level
    # vector.
    if (level_by_index == FALSE) {
        fit_mask <- energies_obj$level_vec %in% levels_select
        fit_levels <- energies_obj$level_vec[fit_mask]
        fit_energies <- energies_obj$spectra_energies[fit_mask]
    }

    # TODO handle selection of levels by index

    if (fit_method == "lm") {
        lm_fit <- lm(fit_energies ~ fit_levels)
        fit_slope <- coef(lm_fit)[2]
        fit_int <- coef(lm_fit)[1]
    }

    return(list(fit_slope = fit_slope,
                fit_int = fit_int))
}

# TODO write function to calculate the Hurst exponent
