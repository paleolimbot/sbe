
test_that("read_sbe_cnv() works", {
  file <- system.file("extdata/faroe/faroe.cnv", package = "sbe")
  colmeta <- read_sbe_cnv_colmeta(file)
  cnv <- read_sbe_cnv(file)
  expect_is(cnv, "tbl_df")
  expect_identical(names(cnv), colmeta$name)
  expect_identical(attr(cnv, "header"), read_sbe_header(file))
})

test_that("read_sbe_cnv_colmeta() works", {
  file <- system.file("extdata/faroe/faroe.cnv", package = "sbe")
  colmeta <- read_sbe_cnv_colmeta(file)
  expect_true(all(!is.na(colmeta$index)))
  expect_true(all(!is.na(colmeta$name)))
  expect_true(all(!is.na(colmeta$long_name)))
  expect_identical(colmeta$long_name[6], "Flag")
  expect_true(all(!is.na(colmeta$unit[-6])))
})

test_that("read_sbe_header() works", {
  file <- system.file("extdata/faroe/faroe.cnv", package = "sbe")

  # regular usage
  header <- read_sbe_header(file)
  expect_length(header, 180)

  # force detection of header size
  header <- read_sbe_header(file, n_header = 10)
  expect_length(header, 180)

  # invalid file
  tmpfile <- tempfile()
  write("totally bogus information", tmpfile)
  expect_error(read_sbe_header(tmpfile), "Can't find")
})
