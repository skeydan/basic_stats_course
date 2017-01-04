# Easy correction of p values using R

alpha = .05

# no relationship between x and y, so all positive p values must be by chance
pValues <- rep(NA,1000)
for(i in 1:1000){
  y <- runif(20)
  x <- runif(20)
  pValues[i] <- summary(lm(y ~ x))$coeff[2,4]
}
head(pvalues)

uncorrected <- sum(pvalues < alpha)
uncorrected

# use p.adjust
head(pvalues)
head(p.adjust(pvalues, method = 'bonferroni'))
head(p.adjust(pvalues, method = 'BH'))

# Bonferroni
bonferroni_adjusted <- sum(p.adjust(pValues, method = 'bonferroni') < .05)
bonferroni_adjusted

# control false discovery rate
BH_adjusted <- sum(p.adjust(pValues, method = 'BH') < .05)
BH_adjusted


### how about false negatives?
# in this dataset, there is a true relationship
pvalues2 <- rep(NA,1000)
for(i in 1:1000){
  x <- rnorm(20)
  if(i <= 500){
    y <- rnorm(20)}
  else{
    y <- rnorm(20, mean=2*x)
  }
  pvalues2[i] <- summary(lm(y ~ x))$coeff[2,4]
}
related <- rep(c("no","yes"),each=500)

table(pvalues2 <.05, related)

table(p.adjust(pvalues2, method = 'bonferroni') <.05, related)
table(p.adjust(pvalues2, method = 'BH') <.05, related)
            
            
