#install.packages("PopGenome")
library("PopGenome")
library("tidyverse")
library("parallelsugar")

vcf_file <- list.files("../../data/ag1000",  full.names = TRUE, pattern = "*filtered.vcf.gz$")

# getting windows from the pixy run
wind_list <- read.table("../pixy/data/ag1000/ag1000__pi.txt", h = T) %>%
  select(window_pos_1, window_pos_2) %>%
  distinct

# bad windows (???)

wind_list <- wind_list[-526,]
wind_list <- wind_list[-732,]
wind_list <- wind_list[-1504,]
wind_list <- wind_list[-2035,]
wind_list <- wind_list[-2263,]
wind_list <- wind_list[-2316,]
wind_list <- wind_list[-2384,]
wind_list <- wind_list[-2388,]


# get the sample names and populations
pop_dat <- read.table("../pixy/Ag1000_sampleIDs_popfile.txt", h = F, stringsAsFactors = FALSE)

popgenome_pi_dxy <- function(wind_row){
  
  cat("\n")
  cat(wind_row)
  cat("\n")
  
  pos1 <- wind_list$window_pos_1[wind_row]
  pos2 <- wind_list$window_pos_2[wind_row]
  
  ag1000_vcf <- readVCF(vcf_file, tid = "X", include.unknown = TRUE, numcols = 1000,
                        samplenames = pop_dat[,1], frompos = pos1, topos = pos2, out = ".")
  
  #ag1000_vcf <- set.populations(ag1000_vcf, new.populations = list(pop_dat[,2][1:18],pop_dat[,2][19:36]))
  pop1 <- get.individuals(ag1000_vcf)[[1]][1:36]
  pop2 <- get.individuals(ag1000_vcf)[[1]][37:72]
  
  # pi 
  
  #div_dat <- set.populations(div_dat, list(rep(1,18), rep(2,18)))
  ag1000_vcf <- diversity.stats(ag1000_vcf, new.populations = list(pop1, pop2))
  
  pi <- ag1000_vcf@nuc.diversity.within / ag1000_vcf@n.sites 
  pi <- as.numeric(pi)
  
  
  # dxy
  dxy_dat <- diversity.stats.between(ag1000_vcf, new.populations = list(pop1, pop2))
  dxy <- dxy_dat@nuc.diversity.between/dxy_dat@n.sites
  dxy <- as.numeric(dxy)
  
  data.frame(window_pos_1 = pos1, window_pos_2 = pos2, pop_genome_pi_BFS = pi[1], pop_genome_pi_KES = pi[2], pop_genome_dxy = dxy)
  
  #write.table(data.frame(vcf_file, n_missing, popgenome_pi = pi[1]), 
             # file = paste0("data/pi_est/", random_slug, ".txt"))
  
}

#pg_pi_dxy <- mclapply(1:nrow(wind_list), popgenome_pi_dxy, mc.cores = 3, mc.preschedule = FALSE)

#pg_pi_dxy1 <- lapply(1:730, popgenome_pi_dxy)
#saveRDS(pg_pi_dxy1, file = "data/pge_pi_dxy1.rds")


wind_index <- seq(1, 2440, by = 100)
wind_index[wind_index > 100] <- wind_index[wind_index > 100] - 1
wind_index[25] <- 2440

for (i in 1:(length(wind_index)-1)){
  
  file_name <- paste0("data/out/pge_pi_dxy_", wind_index[i], ".rds")
  
  if(!file.exists(file_name)){
    
    pg_pi_dxy <- lapply(wind_index[i]:wind_index[i+1], popgenome_pi_dxy)
    
    saveRDS(pg_pi_dxy, file = file_name)
    
  } else{
    
    cat(paste0(file_name, " exists, skipping..."))
    
  }
  
}

index <- 2300
file_name <- paste0("data/out/pge_pi_dxy_", index, ".rds")
pg_pi_dxy <- lapply(2300:2432, popgenome_pi_dxy)
saveRDS(pg_pi_dxy, file = file_name)

pg_files <- list.files("data/out/", full.names = TRUE)
pg_dat <- lapply(pg_files, function(x) readRDS(x) %>% bind_rows())
pg_dat <- bind_rows(pg_dat)

write_rds(pg_dat, "data/popgenome_pi_dxy_ag1000g.rds")  

