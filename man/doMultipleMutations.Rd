% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/doMultipleMutations.R
\name{doMultipleMutations}
\alias{doMultipleMutations}
\title{Perform Multiple Iterations of Mutations}
\usage{
doMultipleMutations(network, collection, iters = 10L,
  return.all = FALSE, upper = 1, bound.handling = "uniform")
}
\arguments{
\item{network}{An object of class "Network".}

\item{collection}{An object of class "tspgen_collection".}

\item{iters}{Number of iterations.}

\item{return.all}{Should all interim instances be returned?}

\item{upper}{Upper boundary for network points.}

\item{bound.handling}{Occasionally during instance generation points are moved outside the boundaries of the point space. The parameter bound.handling determines how to deal with these points.}
}
\value{
A netgen network.
}
\description{
Performs Multiple Mutations on a given network.
}
