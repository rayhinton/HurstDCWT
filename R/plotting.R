#' Plot the wavelet spectra
#'
#' @inheritParams get_slope
#' @inheritParams est_H
#'
#' @returns a ggplot plot object
#'
#' @export
plot_spectra <- function(energies_obj, slope_obj = NULL) {
    p <- data.frame(level_vec = energies_obj$level_vec,
                    spectra_energies = energies_obj$spectra_energies) |>
        ggplot(aes(x = .data$level_vec, y = .data$spectra_energies)) +
        geom_point()
    if (!is.null(slope_obj)) {
        p <- p +
            geom_abline(intercept = slope_obj$fit_int,
                        slope = slope_obj$fit_slope,
                        color = "red")
    }

    return(p)
}
