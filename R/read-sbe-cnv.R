
#' Read Seabird .cnv files
#'
#' The .cnv file format is the primary file format used for input and output
#' to SBE Data Processing. The format is essentially a fixed-width format using
#' 11 characters for each column.
#'
#' @param file A file, URL, or connection. Files ending in .gz, .bz2, .xz, or
#'   .zip will be automatically uncompressed; URLs will be automatically
#'   downloaded. See [readr::read_lines()] for a full description of how
#'   this parameter is interpreted.
#' @param skip Number of non-header rows to skip.
#' @param n_max Maximum number of rows to read.
#' @param header A previously read value obtained from [read_sbe_header()].
#' @param n_header The starting guess for number of header lines.
#' @param col_names The column names. Defaults to the `name` column of
#'   [read_sbe_cnv_colmeta()].
#' @param widths A vector the same length as `col_names` denoting the
#'   widths of each field in characters. Defaults to 11.
#'
#' @export
#'
#' @examples
#' file <- system.file("extdata/faroe/faroe.cnv", package = "sbe")
#' read_sbe_cnv(file)
#' read_sbe_cnv_colmeta(file)
#' head(read_sbe_header(file))
#'
#' # header information is kept on read with the 'header' attribute
#' cnv <- read_sbe_cnv(file)
#' head(attr(cnv, "header"))
#'
read_sbe_cnv <- function(file, skip = 0, n_max = Inf,
                         header = read_sbe_header(file),
                         col_names = read_sbe_cnv_colmeta(file, header)$name,
                         widths = rep(11L, length(col_names))) {
  meta <- read_sbe_cnv_colmeta(file, header)
  tbl <- readr::read_fwf(
    file,
    col_positions = readr::fwf_widths(widths, col_names),
    col_types = readr::cols(.default = readr::col_double()),
    skip = length(header) + 1 + skip,
    n_max = n_max
  )

  attr(tbl, "header") <- header
  tbl
}

#' @rdname read_sbe_cnv
#' @export
read_sbe_cnv_colmeta <- function(file, header = read_sbe_header(file)) {
  header_names <- header[grepl("#\\s+name\\s+[0-9]+", header)]
  names_ext <- stringr::str_match(
    header_names,
    "name\\s+([0-9]+)\\s*=\\s*([^:]+):\\s*([^\\[]*)(\\[[^\\]]+\\])?"
  )

  # the flag column contains a payload that is not a long name
  long_name <- stringr::str_trim(names_ext[, 4])
  long_name[names_ext[, 3] == "flag"] <- "Flag"

  tibble::tibble(
    index = as.integer(names_ext[, 2]) + 1,
    name = names_ext[, 3],
    long_name = long_name,
    unit = stringr::str_remove_all(names_ext[, 5], "[\\[\\]]")
  )
}

#' @rdname read_sbe_cnv
#' @export
read_sbe_header <- function(file, n_header = 500) {
  stopifnot(n_header > 0)

  lines <- readr::read_lines(file, n_max = n_header)
  end_header <- grepl("\\s*\\*END\\*\\s*", lines)

  while ((length(lines) == n_header) && !any(end_header)) {
    n_header <- n_header * 2
    lines <- readr::read_lines(file, n_max = n_header)
    end_header <- grepl("\\s*\\*END\\*\\s*", lines)
  }

  if (!any(end_header)) {
    abort(glue("Can't find '*END*' of header in '{ file }'."))
  }

  lines[seq_len(which(end_header)[1] - 1)]
}
