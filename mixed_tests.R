# counts of binary decisions
class_1 <- 3
n <- 4
binom.test(class_1,n, alternative = 'greater')

events <- c(1,10)
times <- c(100,1787)
poisson.test(events, times, alternative = 'greater')