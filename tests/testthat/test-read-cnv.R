
test_that("read_cnv() works", {
  file <- system.file("extdata/faroe/faroe.cnv", package = "sbe")
  colmeta <- read_cnv_colmeta(file)
  cnv <- read_cnv(file)
  expect_is(cnv, "tbl_df")
  expect_identical(names(cnv), colmeta$name)
  expect_identical(attr(cnv, "header"), read_cnv_header(file))
})

test_that("read_cnv_colmeta() works", {
  file <- system.file("extdata/faroe/faroe.cnv", package = "sbe")
  colmeta <- read_cnv_colmeta(file)
  expect_true(all(!is.na(colmeta$index)))
  expect_true(all(!is.na(colmeta$name)))
  expect_true(all(!is.na(colmeta$long_name)))
  expect_identical(colmeta$long_name[6], "Flag")
  expect_true(all(!is.na(colmeta$unit[-6])))
})

test_that("read_cnv_header() works", {
  file <- system.file("extdata/faroe/faroe.cnv", package = "sbe")

  # regular usage
  header <- read_cnv_header(file)
  expect_length(header, 181)
  expect_equal(header[181], "*END*")

  # force detection of header size
  header <- read_cnv_header(file, n_header = 10)
  expect_length(header, 181)
  expect_equal(header[181], "*END*")

  # invalid file
  tmpfile <- tempfile()
  write("totally bogus information", tmpfile)
  expect_error(read_cnv_header(tmpfile), "Can't find")
})
