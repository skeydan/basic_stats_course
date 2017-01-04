# Use power.t.test to determine power
# Or use it to determine required n, mean difference, or sd

power.t.test(n = 16, delta = 0.5, sd = 1, type = "one.sample", alt = "one.sided")
# obtain power
power.t.test(n = 16, delta = 0.5, sd = 1, type = "one.sample", alt = "one.sided")$power


# vary delta, n, or sd
power.t.test(n = 16, delta = 1, sd = 1, type = "one.sample", alt = "one.sided")$power
power.t.test(n = 8, delta = 0.5, sd = 1, type = "one.sample", alt = "one.sided")$power
power.t.test(n = 16, delta = 0.5, sd = 2, type = "one.sample", alt = "one.sided")$power

# obtain n for desired power
power.t.test(power = 0.5, delta = 0.5, sd = 1, type = "one.sample", alt = "one.sided")$n

# obtain delta for desired power
power.t.test(power = 0.5, n= 8, sd = 1, type = "one.sample", alt = "one.sided")$delta

# obtain sd for desired power
power.t.test(power= 0.5, n = 16, delta = 0.5, sd = NULL, type = "one.sample", alt = "one.sided")$sd
