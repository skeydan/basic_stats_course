# Easy correction of p values using R

alpha = .05


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
