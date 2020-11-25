
#' Run Seabird Data Processing using SBEBatch.exe
#'
#' These functions generate suitable batch file specifications and run them
#' using [sbe_run_batch()].
#'
#' @param tool A vector of tool names. Currently supported names are
#'   alignctd, binavg, celltm, datcnv, derive, deriveteos_10, filter,
#'   loopedit, and wildedit.
#' @param psa A vector of configuration files. See [sbe_psa_default()] for default
#'   configuration files for each tool.
#' @param input A vector of input files. This can include the wildcard `*`
#'   to select multiple files.
#' @param con A vector of .con or .xmlcon files, recycled along `input`.
#' @param output An output directory, defaulting to [sbe_temp_dir()].
#' @inheritParams sbe_run_batch
#'
#' @rdname sbe_run
#'
#' @return The `output` directory.
#' @export
#'
#' @examples
#' \dontrun{
#' # only works if SeaSoft has been installed
#' faroe_dir <- system.file("extdata/faroe", package = "sbe")
#' out_dir <- sbe_run_tool(
#'   "datcnv",
#'   psa = file.path(faroe_dir, "faroe.psa"),
#'   input = file.path(faroe_dir, "faroe.dat"),
#'   con = file.path(faroe_dir, "faroe.con")
#' )
#'
#' out_sbe_cnv <- list.files(out_dir, full.names = TRUE)
#' read_sbe_cnv(out_sbe_cnv)
#' }
#'
sbe_run_tool <- function(tool, psa, input = NULL, con = NULL, output = sbe_temp_dir(), quiet = FALSE) {
  batch_txt <- sbe_batch_generate(tool, psa, input, con, output)
  if (!quiet) {
    message(glue("Generated batchfile:\n{ batch_txt }"))
  }

  batch_file <- tempfile(fileext = ".txt")
  write(batch_txt, batch_file)

  sbe_run_batch(batch_file, quiet = quiet)

  output
}

sbe_batch_generate <- function(tool, psa, input = NULL, con = NULL, output = NULL) {
  stopifnot(is.character(tool))
  tool <- tolower(tool)
  stopifnot(all(tool %in% c(
    "alignctd", "binavg", "celltm",
    "datcnv", "derive", "deriveteos_10",
    "filter", "loopedit", "wildedit"
  )))
  tool <- stringr::str_to_title(tool)

  stopifnot(is.character(psa))
  assert_extension(psa, "psa", "psa")
  psa <- stringr::str_c("/p", sbe_batch_path(psa))


  if (!is.null(input)) {
    assert_extension(input, c("dat", "hex", "cnv"), "input")
    input <- stringr::str_c("/i", sbe_batch_path(input))
  }

  if (!is.null(con)) {
    assert_extension(con, c("con", "xmlcon"), "con")
    con <- stringr::str_c("/c", sbe_batch_path(con))
  }

  if (!is.null(output)) {
    # too many options for output to check
    output <- stringr::str_c("/o", sbe_batch_path(output))
  }

  args <- list(tool, psa, input, con, output)
  args <- args[!vapply(args, is.null, logical(1))]
  do.call(stringr::str_c, c(args, list(sep = " ", collapse = "\n")))
}

#' @rdname sbe_run
#' @export
sbe_psa_default <- function(tool) {
  tool <- tolower(tool)
  default_psa_dir <- system.file("extdata/psa", package = "sbe")
  file.path(default_psa_dir, glue("{ tool }.psa"))
}

#' @rdname sbe_run
#' @export
sbe_temp_dir <- function() {
  temp_dir <- tempfile(tmpdir = sbe_temp_dir_base)
  dir.create(temp_dir)
  as.character(fs::path_abs(temp_dir))
}

#' @rdname sbe_run
#' @export
is_sbe_temp_dir <- function(path) {
  fs::path_abs(dirname(path)) == fs::path_abs(sbe_temp_dir_base)
}

assert_extension <- function(x, ext, arg) {
  if (!is.character(x)) {
    abort(glue("`{ arg }` must be a character vector."))
  }

  bad_ext <- is.na(x) | !(tools::file_ext(x) %in% ext)
  if (any(bad_ext)) {
    abort(glue("`{ arg }` must be a vector of files ending with '.{ ext }'\n"))
  }

  invisible(x)
}
