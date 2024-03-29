% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/slurm.R
\name{write_parameters_file}
\alias{write_parameters_file}
\title{Write parameters file}
\usage{
write_parameters_file(
  x,
  filename = "parameters.csv",
  format = get_file_extension(filename),
  add_id = is_in("data.frame", class(x))
)
}
\arguments{
\item{x}{\code{data.frame} or \code{list} of parameters to be written as a \code{format} file.}

\item{filename}{Path to output file.}

\item{format}{Output file format using \code{readr} \verb{write_*} functions. Currently only \code{csv} or \code{rds}!}

\item{add_id}{Should an \code{id} variable be included, which is just a zero-padded row number. Defaults to \code{true} when \code{x} is some type of \code{data.frame}.}
}
\value{
Invisibly returns the filename that was written.
}
\description{
Writes an object of parameters to file ready for use in an \code{sbatch} job array.
}
