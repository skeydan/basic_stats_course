library(rethinking)

data <- data.frame(y = rnorm(20, mean = 1.22, sd= 0.2))
data

f <- alist(
  y ~ dnorm( mu , sigma ),
  mu ~ dnorm( 0 , 10 ),
  sigma ~ dcauchy( 0 , 1 )
)
f

fit <- map( 
  flist = f , 
  data=data , 
  start=list(mu=0,sigma=1)#,
  #debug = TRUE,
  #verbose = TRUE
)
fit
summary(fit)
sim(fit, n=10)

fit.stan <- map2stan( 
  f , 
  data=data , 
  start=list(mu=0,sigma=1),
  debug = TRUE
)
fit.stan
stancode(fit.stan)
