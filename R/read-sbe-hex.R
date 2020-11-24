
#' Read Seabird .hex files
#'
#' @inheritParams read_sbe_cnv
#'
#' @export
#'
read_sbe_hex <- function(file, skip = 0, n_max = Inf,
                         header = read_sbe_header(file)) {
  readr::read_lines(
    file,
    skip = length(header) + 1 + skip,
    n_max = n_max
  )


}

line_to_raw <- function(line) {
  lapply(line, function(line) {
    line_raw <- stringr::str_sub(
      line,
      seq(1, nchar(line) - 1, 2),
      seq(2, nchar(line), 2)
    )
    as.raw(paste0("0x", line_raw))
  })
}

hack_raw <- function(x, what = "integer", size = 4, endian = "little", signed = TRUE, offset = 0) {
  con <- rawConnection(x)
  on.exit(close(con))
  readBin(con, "raw", n = offset)
  readBin(con, what, n = (length(x) - offset) %/% size, size = size, signed = signed, endian = endian)
}

# lines_raw <- line_to_raw(head(lines, 1000))
# cnv <- read_sbe_cnv(system.file("extdata/cast1/cast1.cnv", package = "sbe"))
#
# cnv[c("v0", "v1", "v2", "v3", "f0", "f1", "f2")]
# lines_raw %>% head(10) %>%
#   lapply(hack_raw, "integer", 2, "big", signed = FALSE, offset = 0) %>%
#   do.call(rbind, .)
#
# library(tidyverse)
# tbl <- tibble(
#   lines_raw = line_to_raw(head(lines, 20000)),
#   scan = seq_along(lines_raw),
#   pos = lapply(lines_raw, seq_along)
# )
#
# tbl %>%
#   unnest(c(lines_raw, pos)) %>%
#   ggplot(aes(x = pos, y = scan, fill = as.integer(lines_raw))) +
#   geom_raster() +
#   scale_y_reverse()

# http://mooring.ucsd.edu/software/matlab/doc/toolbox/data/sbe/read_hex.html
#  Structure of HEX-DataLine (SeaCat SBE 16plus):
#
#  tttttt    6  Temperature A/D-counts
#  cccccc    6  CondFreq          = val / 256
#
#  vvvv      4  PressTempCompVolt = val / 13.107  % PressureType 1 (StrainGauge)
#
#  pppppp    6  PressFreq         = val / 256     % PressureType 3 (Quartz)
#  vvvv      4  PressTempCompVolt = val / 13.107  % PressureType 3 (Quartz)
#
#  vvvv      4  Ext0Volt          = val / 13.107  % [mV]
#  vvvv      4  Ext1Volt          = val / 13.107
#  vvvv      4  Ext2Volt          = val / 13.107
#  vvvv      4  Ext3Volt          = val / 13.107
#
#  tttttt    6  SBE38Temp         = val / 100 - 10
#
#  ssssssss  8  seconds since 01.01.1980
#
#           20 .. 40/46/52 Counts
