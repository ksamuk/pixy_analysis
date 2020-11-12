#install.packages("PopGenome")
library("PopGenome")
library("vcfR")
library("ids")
library("dplyr")
library("parallel")

args <- commandArgs(trailingOnly=TRUE)
vcf_folder <- args[[1]]
n_cores <- args[[2]]

# get the paths for bgzip and tabix (required for popgenome)
bgzip_path <- system("which bgzip", intern = TRUE)
tabix_path <- system("which tabix", intern = TRUE)

# for local debugging
#bgzip_path <- "/Users/ksamuk/anaconda3/bin/bgzip"
#tabix_path <- "/Users/ksamuk/anaconda3/bin/tabix"
#vcf_folder <- "../simulating-test-data/data/simulated_missing_genos"
#vcf_file <- "../simulating-test-data/data/simulated_missing_genos/0.85/pi_sim_Ne=1.0e+06_mu=1e-08_samples=100_sites=10000_0_invar_missing_genos=0.85.vcf.gz"

compute_pi_pop_genome <- function(vcf_file){
  
#  cat(vcf_file)
  random_slug <- random_id()
  tmp <- read.vcfR(vcf_file)
  tmp@fix[,4] <- rep("A", length(tmp@fix[,4]))
  tmp@fix[,5] <- rep("T", length(tmp@fix[,5]))
  
  tmp_file_name <- paste0(random_slug, ".vcf")
  write.vcf(tmp, paste0("data/", tmp_file_name, ".gz"))
  system(paste0("gunzip ", paste0("data/", tmp_file_name, ".gz")))
  #file.remove(paste0("data/", tmp_file_name))
  
  system(paste0(bgzip_path, " data/", tmp_file_name))
  system(paste0(tabix_path, " data/", tmp_file_name, ".gz"))
  
  test_dat <- readVCF(paste0("data/", tmp_file_name, ".gz"), numcols = 1000, tid = "1", include.unknown = TRUE, 
                      from=1, to=10000, approx = FALSE, out = random_slug)
  file.remove(paste0("data/", tmp_file_name, ".gz"))
  file.remove(paste0("data/", tmp_file_name, ".gz.tbi"))
  
  file.remove(paste0("SNPRObjects", random_slug))
  #system("rm data/*.vcf*")
  
  test_dat <- diversity.stats(test_dat)
  get.diversity(test_dat)
  
  # this is the suggested per site pi method from the popgenome manual
  # "The nucleotide diversities have to be devided by GENOME.class@n.sites to give diversities per
  # site." - PopGenome manual
  # NOTE: it also says that missing data causes haplotype based statistics to be biased
  # people should read the manual.
  pi <- test_dat@nuc.diversity.within / test_dat@n.sites
  
  # same for dxy
  # again the approach of splitting the data into two fake populations
  # and so the expected value of dxy = pi (of the full true population)
  pop1 <- get.individuals(test_dat)[[1]][1:25]
  pop2 <- get.individuals(test_dat)[[1]][25:50]
  dxy_dat <- set.populations(test_dat, list(pop1, pop2))
  dxy_dat <- diversity.stats.between(dxy_dat)
  dxy <- dxy_dat@nuc.diversity.between/dxy_dat@n.sites
  
  if(grepl("missing_genos", vcf_file)){
    
    n_missing <- vcf_file %>% gsub(".*invar_missing_genos=", "", .) %>% 
      gsub(".vcf.gz", "", .) %>%
      as.numeric
    
    n_missing <- 10000*n_missing
    
    
  } else{
    
    n_missing <- vcf_file %>% gsub(".*nvar.missing_", "", .) %>% 
      gsub(".vcf", "", .) %>%
      as.numeric
    
    n_missing <- 10000 - n_missing
    
  }
  
  #data.frame(vcf_file, n_missing, pop_genome_pi = pi)
  
  write.table(data.frame(vcf_file, n_missing, popgenome_pi = pi[1], popgenome_dxy = dxy[1], n_sites = test_dat@n.sites), 
              file = paste0("data/pi_est/", random_slug, ".txt"))
  
}

vcf_files <- list.files(vcf_folder, recursive = TRUE, full.names = TRUE)
#popgenome_df <- lapply(vcf_files, compute_pi_pop_genome)
popgenome_df <- mclapply(vcf_files, compute_pi_pop_genome, mc.cores = n_cores)

#out_df <- bind_rows(popgenome_df)
#write.table(out_df, "data/pop_genome_pi_summary.txt", row.names = FALSE, quote = FALSE)


