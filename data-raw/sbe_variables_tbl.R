
library(tidyverse)

vars_raw <- read_tsv(
  "data-raw/Variables.txt",
  col_types = cols(
    CalcID = col_double(),
    UnitID = col_double(),
    Ordinal = col_double(),
    ShortName = col_character(),
    FullName = col_character(),
    Unit = col_character(),
    FriendlyName = col_character(),
    Min = col_double(),
    Max = col_double(),
    Seasave = col_character(),
    DatCnv = col_character(),
    ASCII_IN = col_character()
  ),
  locale = locale(encoding = "window-1252")
)

vars_raw$ShortName

sbe_variables_tbl <- vars_raw %>%
  transmute(
    # it's unclear what this (\xe9) is supposed to be...removing
    # does not cause duplicates
    name = str_replace(ShortName, fixed("\xe9"), ""),
    long_name = FullName,
    unit = Unit,
    valid_min = Min,
    valid_max = Max
  )

usethis::use_data(sbe_variables_tbl, overwrite = TRUE)
