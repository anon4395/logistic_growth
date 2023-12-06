#Script to plot data and model

#load data
growth_data <- read.csv("/cloud/project/experiment1.csv")

#define function for logistic growth
logistic_fun <- function(t) {
  N <- (N0*K*exp(r*t))/(K-N0+N0*exp(r*t))
  return(N)
}

#define paramters derived from linear models
N0 <- exp(6.888e+00)
r <- 1.002e-02
K <- 6.00e+10

#plot logistic model against data
ggplot(aes(t,N), data = growth_data) +
  geom_function(fun=logistic_fun, colour="red") +
  geom_point()+
scale_y_continuous(trans='log10')

#Create list of required packages
sink(file = "package-versions.txt")
sessionInfo()
sink()


