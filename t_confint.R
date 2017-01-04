### equal variances
m1 <- 3
m2 <- 5
var1 <- 0.6
var2 <- 0.68
n1 <- 10
n2 <- 10

mdiff <- m1 - m2
sd1 <- sqrt(var1)
sd2 <- sqrt(var2)
df <- n1+n2-2

pooled_variance_const_case <- ((n1-1)*var1 + (n2-1)*var2) / (n1 + n2 - 2)
pooled_variance_const_case
se_n <- sqrt(1/n1 + 1/n2)
se_n
se <- sqrt(pooled_variance_const_case) * se_n
se

confint_95 <- mdiff +  c(-1,1) * qt(0.975,df) * se
confint_95


### unequal variances
m1 <- 4
m2 <- 6
sd1 <- 0.5
sd2 <- 2
n1 <- 100
n2 <- 100

mdiff <- m2 - m1

df_num <- (sd1^2/n1 + sd2^2/n2)^2
df_denom <- (sd1^2/n1)^2/(n1-1) +  (sd2^2/n2)^2/(n2-1)
df <- df_num/df_denom

se <- sqrt(sd1^2/n1 + sd2^2/n2)

confint_95 <- mdiff +  c(-1,1) * qt(0.975,df) * se
confint_95


###
m1 <- -3
m2 <- 1
sd1 <- 1.5
sd2 <- 1.8
n1 <- 9
n2 <- 9

mdiff <- m1 - m2
df <- n1+n2-2

pooled_variance_const_case <- ((n1-1)*sd1^2 + (n2-1)*sd2^2) / (n1 + n2 - 2)
se_n <- sqrt(1/n1 + 1/n2)
se_n
se <- sqrt(pooled_variance_const_case) * se_n
se
confint_90 <- mdiff +  c(-1,1) * qt(0.95,df) * se
confint_90
