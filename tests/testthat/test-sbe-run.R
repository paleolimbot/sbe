
test_that("batchfile generator works", {
  batch_txt <- sbe_batch_generate(
     "datcnv",
     "thing.psa",
     c("input1.cnv", "input2.cnv"),
     "con.xmlcon",
     "some/path"
  )

  expect_match(batch_txt, "^Datcnv.*?\nDatcnv")

  expect_error(
    sbe_batch_generate(
      "not a tool",
      "thing.psa",
      c("input1.cnv", "input2.cnv"),
      "con.xmlcon",
      "some/path"
    ),
    "is not TRUE"
  )

  expect_error(
    sbe_batch_generate(
      "datcnv",
      "thing.wrongext",
      c("input1.cnv", "input2.cnv"),
      "con.xmlcon",
      "some/path"
    ),
    "ending with '.psa'"
  )

  expect_match(
    sbe_batch_generate(
      "datcnv",
      "thing.psa"
    ),
    "^Datcnv.*?\\.psa$"
  )
})

test_that("default PSA files are found", {
  tools <- c(
    "alignctd", "binavg", "celltm",
    "datcnv", "derive", "deriveteos_10",
    "filter", "loopedit", "wildedit"
  )

  expect_true(all(file.exists(sbe_psa_default(tools))))
})

test_that("sbe_temp_dir() works", {
  temp_dir <- sbe_temp_dir()
  expect_true(is_sbe_temp_dir(temp_dir))
  expect_true(dir.exists(temp_dir))
  unlink(temp_dir, recursive = TRUE)
})
