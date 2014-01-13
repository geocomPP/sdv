# code to build the chapter (as a series of .md files)
library(knitr)
rmd_files <- paste0(paste0("S", 1:6), ".Rmd")
for(i in rmd_files){
  knit(i)
}
