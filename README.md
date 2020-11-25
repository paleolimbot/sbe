
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sbe

<!-- badges: start -->

[![R build
status](https://github.com/paleolimbot/sbe/workflows/R-CMD-check/badge.svg)](https://github.com/paleolimbot/sbe/actions)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of sbe is to provide an R interface to ‘Seabird’ files and
programs. This package is totally unofficial and very experimental.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("paleolimbot/sbe")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(sbe)

# run SBEDataProcessing tools from R
faroe_dir <- system.file("extdata/faroe", package = "sbe")
out_dir <- sbe_run_tool(
  "datcnv",
  psa = file.path(faroe_dir, "faroe.psa"),
  input = file.path(faroe_dir, "faroe.dat"),
  con = file.path(faroe_dir, "faroe.con")
)
#> Generated batchfile:
#> Datcnv /pC:\Users\dunningtond\Documents\R\win-library\4.0\sbe\extdata\faroe\faroe.psa /iC:\Users\dunningtond\Documents\R\win-library\4.0\sbe\extdata\faroe\faroe.dat /cC:\Users\dunningtond\Documents\R\win-library\4.0\sbe\extdata\faroe\faroe.con /oC:\Users\DUNNIN~1\AppData\Local\Temp\2\RtmpEZkTTH\file3da85ee6454\file3da81279a4c
#> Running \
#>   "C:/Program Files (x86)/Sea-Bird/SBEDataProcessing-Win32/SBEBatch.exe" \
#>   "C:\Users\DUNNIN~1\AppData\Local\Temp\2\RtmpEZkTTH\file3da8379367c5.txt"

# read cnv files as data frames
out_sbe_cnv <- list.files(out_dir, full.names = TRUE)
read_sbe_cnv(out_sbe_cnv)
#> # A tibble: 15,225 x 4
#>     prDM t190C `c1S/m`  flag
#>    <dbl> <dbl>   <dbl> <dbl>
#>  1  4.55  8.30    3.66     0
#>  2  4.51  8.30    3.66     0
#>  3  4.55  8.30    3.66     0
#>  4  4.51  8.30    3.66     0
#>  5  4.50  8.30    3.66     0
#>  6  4.51  8.30    3.66     0
#>  7  4.51  8.30    3.66     0
#>  8  4.51  8.30    3.66     0
#>  9  4.50  8.30    3.66     0
#> 10  4.49  8.30    3.66     0
#> # ... with 15,215 more rows
read_sbe_cnv_colmeta(out_sbe_cnv)
#> # A tibble: 4 x 4
#>   index name  long_name            unit         
#>   <dbl> <chr> <chr>                <chr>        
#> 1     1 prDM  Pressure, Digiquartz db           
#> 2     2 t190C Temperature, 2       ITS-90, deg C
#> 3     3 c1S/m Conductivity, 2      S/m          
#> 4     4 flag  Flag                 <NA>
```
