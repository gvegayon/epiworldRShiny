% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions-server.R
\name{find_scale}
\alias{find_scale}
\title{Find the right plotting-scale}
\usage{
find_scale(x)
}
\arguments{
\item{x}{The maximum value found in the model state counts}
}
\value{
An integer representing the scale for the y-axis. A max counts value
of 10000 will return a scale of 1, 100000 will return a scale of 1000,
1000000 will return a scale of 10000.
}
\description{
This function determines the scale of the y-axis for plot_epi.
}
\examples{
find_scale(100000)

}
\seealso{
Other Server side functions: 
\code{\link{plot_epi}()},
\code{\link{plot_reproductive_epi}()},
\code{\link{pop_generator}()}
}
\concept{Server side functions}
