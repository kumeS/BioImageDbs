#NotRun
if(FALSE){
  #install the packages in Docker/Bioconductor
  getwd()
  BiocManager::install("AnnotationHub")
  BiocManager::install("ExperimentHub")
  BiocManager::install("BiocStyle")
  BiocManager::install("BiocCheck")
  install.packages(c('EBImage', 'magick', 'filesstrings', 'animation'))
  
  ##install tex/pdfLatex on Terminal window by Root User
  #sudo apt-get update
  #sudo apt-get install texlive-latex-base texlive-latex-extra texinfo
  #sudo apt-get install texlive-fonts-recommended texlive-fonts-extra
  
  library(AnnotationHub)
  library(ExperimentHub)
  
  ## install test for BioImageDbs package
  system("R CMD INSTALL BioImageDbs")
  system("R CMD build --keep-empty-dirs --no-resave-data BioImageDbs")
  system("R CMD check --no-vignettes --timings --no-multiarch BioImageDbs_0.99.3.tar.gz")
  BiocCheck::BiocCheck("./BioImageDbs_0.99.3.tar.gz")
  
}
