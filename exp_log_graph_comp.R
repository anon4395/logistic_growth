#Get data
growth_data <- read.csv("/cloud/project/experiment1.csv")

#install required packages
install.packages(ggplot2)
library(ggplot2)

#Define parameters, as obtained from linear approximations
N0 <- exp(6.888e+00) 
r <- 1.002e-02 
K <- 6.00e+10 

#Define function for logistic model
logistic_fun <- function(t) {
  N <- (N0*K*exp(r*t))/(K-N0+N0*exp(r*t))
  return(N)
}

#Define function for exponential model
exp_fun <- function(t) {
  N <- (N0*exp(r*t))
  return(N)
}


#Plot the data
ggplot(aes(t,N), data = growth_data) +
  geom_function(fun=logistic_fun, colour="#481567FF") +
  geom_function(fun=exp_fun, colour="#1F968BFF")+
  geom_text(aes(x = 2500, y = logistic_fun(2500), 
                label = "Logistic model"), color = "#481567FF", vjust = -0.5, hjust = -0.25) +
  geom_text(aes(x = 2500, y = exp_fun(2500), 
                label = "Exponential model"), color = "#1F968BFF", vjust = -5, hjust = 0.6)+
  scale_y_continuous(trans='log10')+
  theme_light()+
  labs(title="Logistic vs Exponential Growth Models", 
       x="time (mins)", y="log(N)")+
  theme(plot.title = element_text(hjust = 0.5))