
#' Run SBEBatch.exe
#'
#' @param batch_file A batchfile description.
#' @param ... Additional arguments passed to the batch file processor.
#'   Typically this will be a working directory. Use [sbe_batch_path()]
#'   to convert file paths that are valid in R to file paths that are valid
#'   for SBEBatch.
#' @param quiet Use `TRUE` to suppress non-error output.
#' @param reconfigure Use `TRUE` to force automatic detection of SBEBatch.exe
#' @param drive By default this is detected from the location of the R
#'   executable; pass an explicit value if this configuration fails.
#' @param timeout See [processx::run()].
#' @param path A valid path in R.
#'
#' @export
#'
sbe_run_batch <- function(batch_file, ..., quiet = FALSE, timeout = Inf) {
  args <- rlang::list2(...)
  args <- vapply(args, as.character, character(1))
  batch_file <- sbe_batch_path(batch_file)

  processx::run(
    command = sbe_batch_configure(),
    args = c(batch_file, args),
    echo_cmd = !quiet,
    timeout = timeout
  )

  invisible(NULL)
}

#' @rdname sbe_run_batch
#' @export
sbe_batch_path <- function(path) {
  path <- gsub("/", "\\\\", fs::path_abs(path))

  has_space <- grepl(" ", path)
  if (any(has_space)) {
    files <- if (sum(has_space) != 1) "files" else "file"
    file_lab <- paste0("'", path[has_space], "'", collapse = "\n")
    abort(
      glue(
        paste0(
          "File paths containing spaces are not valid in SBEBatch.exe.\n",
          "{ files } with one or more spaces:\n{ file_lab }"
        )
      )
    )
  }

  as.character(path)
}

#' @rdname sbe_run_batch
#' @export
has_sbe_batch <- function() {
  tryCatch({
    sbe_batch_configure()
    TRUE
  },
  error = function(...) {
    FALSE
  })
}

#' @rdname sbe_run_batch
#' @export
sbe_batch_configure <- function(reconfigure = FALSE, drive = NULL) {
  # use option if it exists
  batch_exe <- getOption("sbe.batch_exe")
  if (!reconfigure && !is.null(batch_exe)) {
    return(invisible(batch_exe))
  }

  if (!identical(unname(Sys.info()["sysname"]), "Windows")) {
    abort("SBEBatch.exe is only available on Windows.")
  }

  # guess drive letter based on where R is installed
  drive <- drive %||% substr(R.home(), 1, 1)

  possible_locations <- glue(
    c(
      "{ drive }:/Program Files (x86)/Sea-Bird/SBEDataProcessing-Win32/SBEBatch.exe"
    )
  )

  # this will pop up a window when it is run, so it can't be tested
  # other than for existence
  batch_exe <- unclass(possible_locations)[file.exists(possible_locations)]

  if (length(batch_exe) == 1) {
    options(sbe.batch_exe = as.character(batch_exe[1]))
    invisible(batch_exe[1])
  } else if(length(batch_exe) > 1) {
    warning(glue("More than one SBEBatch.exe was found.\nUse `sbe_batch_detect()` to configure."))
    options(sbe.batch_exe = as.character(batch_exe[1]))
    invisible(batch_exe[1])
  } else {
    locs_label <- paste0("'", possible_locations, "'", collapse = "\n")
    abort(glue("Can't find SBEBatch.exe at any of the following locations:\n{ locs_label }"))
  }
}
