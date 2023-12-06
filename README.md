# logistic_growth
# Question 1: Analysis
## Step 1: Plotting the Data
*(10 points) Annotate the README.md file in your logistic growth repo with more detailed information about the analysis. Add a section on the results and include the estimates for N0, r and K (mention which .csv file you used).*

First, the data must be obtained, from the experiment1 csv file:
```
growth_data <- read.csv("/cloud/project/experiment1.csv")
```

Plotting the raw data, of time in minutes on the x axis (t) and number of cells on the y axis (N), a classic S-shaped logistic growth curve is produced. We see the graph plateau as the carrying capacity is approached.
```
ggplot(aes(t,N), data = growth_data) +
  geom_point() +
  xlab("t") +
  ylab("y") +
  theme_bw()
```
To better visualise growth rate patterns, the y variable can be log-transformed, which will produce a graph with a linear relationship. This shows the a steady increase in growth rate over time, then a slower rate as the population size plateaus at carrying capacity.
```
ggplot(aes(t,N), data = growth_data) +
  geom_point() +
  xlab("t") +
  ylab("y") +
  scale_y_continuous(trans='log10')
```

## Step 2: Estimate model parameters using linear approximation
In order to estimate initial popultion size (*N0*), carrying capacity(*K*) and growth rate (*r*), linear models can be described and used. 
### Case 1. K >> N0, t is small
When inital population size (*N0*) is much smaller than the carrying capacity (*K*), population growth will be exponential. This occurs when t is small (in this model, we have used the range *t<1250* as on the logistic growth graph above, this appears to be the point as which the population size starts to increase dramatically).

Taking the logistic growth equation, solved for *N(t)*:
(insert equation)
in this case, we can then approximate *K - N0 + N0e^rt ~ K*, hence the denominator of the expression becomes K. The Ks in the numerator and denominator then cancel out, giving the expression:

*N(t) = N0 x e^rt*

If we take logs of both sides of this expression, we get a linear approximation:

*ln(N) = ln(N0) + rt*

This is in the same form as the equation of a line: 

*y = c + mx*

So we can specifiy this linear approximation where *y* is *ln(N)* (here, a mutated variable called *N_log*), and *x is t*. The *summary()* function will then give as an estimate for the intercept, in this case the log of the initial population size (*ln(N0)*), and the gradient, in this case the growth rate (*r*).

```
data_subset1 <- growth_data %>% filter(t<1250) %>% mutate(N_log = log(N))
model1 <- lm(N_log ~ t, data_subset1)
summary(model1)
```
From this, we get that:

*ln(N0) ~ 6.888e+00*

*r ~ 1.002e-02*
### Case 2. N(t) = K
As t tends to infinity, the population size can be assumed to be equal to the carrying capacity. In this model we have used *t>2500*, as on the logistic growth graph, this appears to be the point as which the population size starts to plateau. 

To use a linear approximation, we can then write this again in the form y = c + mx as:

*N(t) = K + 0t*

So here, *y* is *N(t)*, and doesn't vary according to any other variable, so where we would have the *x* value is instead just *1*. The *summary()* function will then give an estimate for the intercept, in this case the carrying capacity of the population, *K*.
```
data_subset2 <- growth_data %>% filter(t>2500)
model2 <- lm(N ~ 1, data_subset2)
summary(model2)
```
From this, we get that:

*K ~ 6.00e+10*
## Step 3: Plotting the data against the model
The estimates obtained from the linear approximations can then be used to define a model logistic growth curve, which can then be compared to the acutal logistic growth curve produced from our data in step 1. We can plot the log transformed curves to enable better comparison.
```
logistic_fun <- function(t) {
  N <- (N0*K*exp(r*t))/(K-N0+N0*exp(r*t))
  return(N)
}

N0 <- exp(6.888e+00)
r <- 1.002e-02 
K <- 6.00e+10 

ggplot(aes(t,N), data = growth_data) +
  geom_function(fun=logistic_fun, colour="red") +
  geom_point()+
  scale_y_continuous(trans='log10')
```
# Question 2: Calculating predicted population sizes according to exponential growth
*(10 points) Use your estimates of N0 and r to calculate the population size at t = 4980 min, assuming that the population grows exponentially. How does it compare to the population size predicted under logistic growth?*

An exponential growth model can be defined using the formula:

*N(t) = N0 x e^rt*

Substituting in the values obtained from our linear model we get that:

*N(t) = e^(6.888e+00) x e^4980(1.002e-02)*
*N(t) = 4.598e+24* or *4.598 x 10^24*

Compared to under logistic growth:
(insert equation)
*N(t) = 6.00e+10* or *6 x10^10*

Under logistic growth, at t=4980 min, the population size has already reached carrying capacity (6 x10^10), hence this is the value for population size. However under exponential growth, per capita growth rate remains the same even as population size increases, and there is no carrying capacity limit. Hence, the population size predicted by the exponential model is signficantly larger (4.6 x 10^24). 

# Question 3: Comparing exponential and logistic growth curves
*(20 points) Add an R script to your repository that makes a graph comparing the exponential and logistic growth curves (using the same parameter estimates you found). Upload this graph to your repo and include it in the README.md file so it can be viewed in the repo homepage.*

![Graph to show comparison of exponential and logistical growth curves]

