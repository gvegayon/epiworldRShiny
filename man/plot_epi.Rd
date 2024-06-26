% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions-server.R
\name{plot_epi}
\alias{plot_epi}
\title{Plot daily incidence}
\usage{
plot_epi(model, mark_max)
}
\arguments{
\item{model}{The number of individuals in the population.}

\item{mark_max}{The state which will have a mark at the peak}
}
\value{
A plot displaying each state from the model over the course of the
simulation
}
\description{
This function generates a plot of the model states over time
}
\examples{
library(epiworldR) # for ModelSEIRCONN function
model <- ModelSEIRCONN("COVID-19", n = 1000, prevalence = 0.05,
                       contact_rate = 4, transmission_rate = 0.1,
                       incubation_days = 7, recovery_rate = 0.14)
run(model, ndays = 100, seed = 123)
plot_epi(model, mark_max = "Infected")

}
\seealso{
Other Server side functions: 
\code{\link{find_scale}()},
\code{\link{plot_reproductive_epi}()},
\code{\link{pop_generator}()}
}
\concept{Server side functions}
