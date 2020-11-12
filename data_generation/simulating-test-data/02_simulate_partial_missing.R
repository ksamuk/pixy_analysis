# simulate partial missing data (missing genotypes, not sites)

library("tidyverse")
library("vcfR")
library("paralell")

simulate_partial_missing_data <- function(vcf_file, missingness = 0, regenerate = FALSE){
  
  # get the file slug
  file_name <- vcf_file %>% gsub(".*/", "", .) %>% 
    gsub(".vcf.gz", paste0("_missing_genos=",missingness, ".vcf.gz"), .)  
  
  # check if file already exists, or if regeneration is being forced
  if(!(file.exists(paste0("data/simulated_missing_genos/",missing_level, "/",missingness, "/",file_name ))) |  regenerate){
  
  # read in the VCF
  vcf_df <- read.vcfR(vcf_file)
  
  # inject fake bases (for compatibility with downstream programs)
  # msprime sets REF and ALT to 0 and 1 respectively
  vcf_df@fix[,4] <- rep("A", length(vcf_df@fix[,4]))
  vcf_df@fix[,5] <- rep("T", length(vcf_df@fix[,5]))
  
  # generate a missingness mask
  
  # determine the dimensions of the gt matrix
  rows <- nrow(vcf_df@gt)
  cols <- ncol(vcf_df@gt) - 1
  
  # case 1
  # missingness rate is enforced at the level of the whole genotype matrix
  # i.e. the missinginess rate is the MEAN missingness at the site level
  # but it is variable among sites
    
  n_missing <- floor(rows*missingness)
  gt_vec <- c(rep(FALSE, n_missing), rep(TRUE, rows - n_missing))
  mask <- replicate(cols, sample(gt_vec))
  
  # case 2 (not run)  
  # enforce missingness proportion at site level
  
  #n_missing <- floor(cols*missingness)
  #gt_vec <- c(rep(FALSE, n_missing), rep(TRUE, cols - n_missing))
  #mask <- replicate(rows, sample(gt_vec)) %>% t()

  # apply the mask + preserve the GT field
  vcf_df@gt[,-1][!mask] <- "./."
  vcf_df@gt[,1] <- "GT"
  
  # write to file
  dir.create(paste0("data/simulated_missing_genos/", missingness))
  write.vcf(vcf_df, file = paste0("data/simulated_missing_genos/", missingness, "/",file_name ))
  } 
  
  else{
    
    message("file already exists, skipping...")
    
  }
}


# apply the function to all the invariant sites VCFs

vcf_files <- list.files("data/simulated_invar", full.names = TRUE)

for (i in 1:100*(0.01)){
  
  mclapply(vcf_files, simulate_partial_missing_data, missingness = i, regenerate = FALSE, cores = 12)
  
}

