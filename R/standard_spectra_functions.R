#' log energy of one region
#'
#' @param region_mat matrix for a single region of a 2D DWCT
#' @param location_stat which statistic to use for estimating the energy. currently only "mean" is supported.
#'
#' @return scalar, the log2 of the estimated coefficient energy in the region
#' @export
log_e_region <- function(region_mat, location_stat = "mean") {
    if (location_stat == "mean") {
        log_energy <- log2(mean(Mod(region_mat)^2))
    }

    return(log_energy)
}
