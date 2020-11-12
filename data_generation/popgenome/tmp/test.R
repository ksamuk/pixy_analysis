library("PopGenome")
library("vcfR")
library("ids")
library("dplyr")
library("parallel")

test_dat <- readVCF(paste0("data/f48c024acf8e100fcd24f5f6f2a2acae.vcf.gz"), numcols = 1000, tid = "1", include.unknown = TRUE, from=1, to=10000, approx = FALSE)
test_dat <- diversity.stats(test_dat)
get.diversity(test_dat)
pop1 <- get.individuals(test_dat)[[1]][1:25]
pop2 <- get.individuals(test_dat)[[1]][25:50]
dxy_dat <- set.populations(test_dat, list(pop1, pop2))
dxy_dat <- diversity.stats.between(dxy_dat)
fst_dat <- F_ST.stats(dxy_dat)
test_dat@nuc.diversity.within / test_dat@n.sites
dxy_dat@nuc.diversity.between/dxy_dat@n.sites
fst_dat@nuc.diversity.between/fst_dat@n.sites


test_dat <- readVCF(paste0("data/f48c024acf8e100fcd24f5f6f2a2acae.vcf.gz"), numcols = 1000, tid = "1", include.unknown = FALSE, from=1, to=10000, approx = FALSE)
test_dat <- diversity.stats(test_dat)
get.diversity(test_dat)
pop1 <- get.individuals(test_dat)[[1]][1:25]
pop2 <- get.individuals(test_dat)[[1]][25:50]
dxy_dat <- set.populations(test_dat, list(pop1, pop2))
dxy_dat <- diversity.stats.between(dxy_dat)
test_dat@nuc.diversity.within / test_dat@n.sites
dxy_dat@nuc.diversity.between/dxy_dat@n.sites