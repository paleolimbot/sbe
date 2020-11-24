
test_that("read_sbe_hex() works", {
  skip("Nope!")

  file <- system.file("extdata/cast1/cast1.hex", package = "sbe")
  lines <- read_sbe_hex(file)

})
