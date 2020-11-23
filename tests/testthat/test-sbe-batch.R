
test_that("sbe_batch_path() errors for filenames with spaces", {
  expect_error(sbe_batch_path(" "), "one or more spaces")
  expect_identical(
    sbe_batch_path(R.home()),
    gsub("/", "\\\\", R.home())
  )
})

test_that("sbe_batch_configure() works", {
  # different expectations based on whether or not sbe_batch()
  # is available and/or which OS is used
  is_windows <- identical(unname(Sys.info()["sysname"]), "Windows")

  if (is_windows) {
    try(sbe_batch_configure(), silent = TRUE)

    if (is.null(getOption("sbe.batch_exe"))) {
      expect_error(sbe_batch_configure(), "Can't find SBEBatch\\.exe")
    } else {
      expect_true(file.exists(sbe_batch_configure(reconfigure = TRUE)))
    }
  } else {
    expect_error(sbe_batch_configure(), "only available on Windows")
  }
})

test_that("sbe_run_batch() works", {
  skip_if_not(has_sbe_batch())

  # popups mean that this can't be run without some interaction
  # so instead, test using a timeout error
  expect_error(
    sbe_run_batch("C:/bogus.txt", timeout = 0.1, quiet = TRUE),
    class = "system_command_timeout_error"
  )
})
