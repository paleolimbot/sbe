
#' Read Seabird .hex files
#'
#' The Seabird hex format is not publicly defined anywhere, but is a mix of
#' binary integer representations scaled in various ways to represent
#' voltage, frequency, count, and NMEA output. These functions are best
#' considered as entertainment only.
#'
#' @inheritParams read_sbe_cnv
#'
#' @export
#'
read_sbe_hex_lines <- function(file, skip = 0, n_max = Inf, header = read_sbe_header(file)) {
  readr::read_lines(
    file,
    skip = length(header) + 1 + skip,
    n_max = n_max
  )
}
