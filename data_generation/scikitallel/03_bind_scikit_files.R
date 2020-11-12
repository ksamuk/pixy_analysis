library("dplyr")

# expected pi
Ne <- 1e6
Mu <- 1e-8
exp_pi <- 4*Ne*Mu

# bind files into a dataframe


sk_pi <- lapply(list.files("data/pi_out", full.names = TRUE), function(x) read.table(x, h = T))
sk_pi <- bind_rows(sk_pi)

sk_pi$exp_pi <- exp_pi


sk_dxy <- lapply(list.files("data/dxy_out", full.names = TRUE), function(x) read.table(x, h = T))
sk_dxy <- bind_rows(sk_dxy)

sk_dxy <- left_join(sk_pi, sk_dxy) %>%
  select(-sk_allel_no_sites, sk_allel_no_sites)

sk_dxy_org <- read.csv("data/scikit_pi_dxy_est_bak.csv", h = T)
sk_dxy_org <- sk_dxy_org[,1:8]

sk_dxy_org <- bind_rows(sk_dxy, sk_dxy_org) %>% 
  distinct

write.csv(sk_dxy_org, file = "data/scikit_pi_dxy_est.csv", row.names = FALSE, quote = FALSE)
