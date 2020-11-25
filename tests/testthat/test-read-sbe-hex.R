
test_that("read_sbe_hex_lines() works", {
  file <- system.file("extdata/cast1/cast1.hex", package = "sbe")
  lines <- read_sbe_hex_lines(file, n_max = 100)
  expect_length(lines, 100)
})
