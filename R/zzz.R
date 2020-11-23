
sbe_temp_dir_base <- NULL

.onLoad <- function(...) {
  sbe_temp_dir_base <<- tempfile()
  dir.create(sbe_temp_dir_base)
}

.onUnload <- function(...) {
  unlink(sbe_temp_dir_base, recursive = TRUE)
}
