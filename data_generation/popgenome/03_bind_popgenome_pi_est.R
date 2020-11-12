library("dplyr")

# expected pi
Ne <- 1e6
Mu <- 1e-8
exp_pi <- 4*Ne*Mu

# bind files into a dataframe

pg_pi <- lapply(list.files("data/pi_est", full.names = TRUE), read.table)
pg_pi <- bind_rows(pg_pi)

pg_pi$exp_pi <- exp_pi

pg_pi <- pg_pi %>%
  mutate(missing_type = ifelse(grepl("geno", vcf_file), "genos", "sites"))%>%
  mutate(missing_type = ifelse(grepl("accuracy", vcf_file), "accuracy", missing_type)) %>%
  mutate(n_missing = ifelse(missing_type == "genos", gsub(".*=|.vcf.gz", "", vcf_file), n_missing)) %>%
  mutate(n_missing = ifelse(missing_type == "accuracy", 0, n_missing)) %>%
  mutate(n_missing = as.numeric(n_missing))

pg_org <- read.csv("data/popgenome_pi_dxy_est.csv") %>%
  filter(!(vcf_file %in% pg_pi$vcf_file))

pg_pi <- bind_rows(pg_pi, pg_org)

write.csv(pg_pi, file = "data/popgenome_pi_dxy_est.csv", row.names = FALSE, quote = FALSE)
