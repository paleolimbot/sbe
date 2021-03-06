% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sbe-run.R
\name{sbe_run_tool}
\alias{sbe_run_tool}
\alias{sbe_psa_default}
\alias{sbe_temp_dir}
\alias{is_sbe_temp_dir}
\title{Run Seabird Data Processing using SBEBatch.exe}
\usage{
sbe_run_tool(
  tool,
  psa,
  input = NULL,
  con = NULL,
  output = sbe_temp_dir(),
  quiet = FALSE
)

sbe_psa_default(tool)

sbe_temp_dir()

is_sbe_temp_dir(path)
}
\arguments{
\item{tool}{A vector of tool names. Currently supported names are
alignctd, binavg, celltm, datcnv, derive, deriveteos_10, filter,
loopedit, and wildedit.}

\item{psa}{A vector of configuration files. See \code{\link[=sbe_psa_default]{sbe_psa_default()}} for default
configuration files for each tool.}

\item{input}{A vector of input files. This can include the wildcard \code{*}
to select multiple files.}

\item{con}{A vector of .con or .xmlcon files, recycled along \code{input}.}

\item{output}{An output directory, defaulting to \code{\link[=sbe_temp_dir]{sbe_temp_dir()}}.}

\item{quiet}{Use \code{TRUE} to suppress non-error output.}

\item{path}{A valid path in R.}
}
\value{
The \code{output} directory.
}
\description{
These functions generate suitable batch file specifications and run them
using \code{\link[=sbe_run_batch]{sbe_run_batch()}}.
}
\examples{
\dontrun{
# only works if SeaSoft has been installed
faroe_dir <- system.file("extdata/faroe", package = "sbe")
out_dir <- sbe_run_tool(
  "datcnv",
  psa = file.path(faroe_dir, "faroe.psa"),
  input = file.path(faroe_dir, "faroe.dat"),
  con = file.path(faroe_dir, "faroe.con")
)

out_sbe_cnv <- list.files(out_dir, full.names = TRUE)
read_sbe_cnv(out_sbe_cnv)
}

}
