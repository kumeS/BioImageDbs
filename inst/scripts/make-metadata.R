titles <- c("id0001_Brain_CA1_hippocampus_region.Rda")

imaging <- c("Two image datasets in 3D of  Electron Microscopy (FIB-SEM) data with suvervised labels of mitocondoria")
samples <- c("the CA1 hippocampus region of the mouse brain")
volume <- c("1065x2048x1536 volume")
voxel <- c("approximately 5x5x5nm resolution")
descriptions <- paste0(Imaging, ", ", samples, " (", volume, ", ", voxel, ")")

SourceType <- c("PNG")
SourceUrl <- c("https://www.epfl.ch/labs/cvlab/data/data-em/")
SourceVersion <- c("Mar 30 2017")

species <- c("Mus musculus")
taxonomy_ids <- c("10090")

DataProvider <- c("https://www.epfl.ch/labs/cvlab/data/data-em/")

Tags <- c("Bioimage:3Dimage:microscope:microscopy:EM:SEM")

meta <- data.frame(
    Title = titles,
    Description = descriptions,
    BiocVersion = "3.13",
    Genome = NA,
    SourceType = SourceType,
    SourceUrl = SourceUrl,
    SourceVersion = SourceVersion,
    Species = species,
    TaxonomyId = taxonomy_ids,
    Coordinate_1_based = NA,
    DataProvider = DataProvider,
    Maintainer = "Satoshi Kume <satoshi.kume.1984@gmail.com>",
    RDataClass = "list",
    DispatchClass = "Rda",
    RDataPath = paste0('AHBioImageDbs/', titles),
    Tags = Tags
)

write.csv(meta, file="metadata.csv", row.names=FALSE)

