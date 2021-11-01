###################################
#Check data on Bioconductor Docker
###################################

install.packages(c('BiocManager'))
BiocManager::install("ExperimentHub")
library(ExperimentHub)

eh <- ExperimentHub()
qr <- query(eh, c("BioImageDbs"))
qr

