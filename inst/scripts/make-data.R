#rm(list=ls())
library(EBImage)

## Image processing
processing_2d_image_train_test <- function(file, type="png", shape, filter="bilinear",
                                           normalize=F, clahe=F, GammaVal=1.0){
  image <- readImage(file, type=type)
  image <- resize(image, w = shape[1], h = shape[2], filter = filter)
  if(normalize){image <- normalize(image)}
  if(clahe){image <- clahe(image)}
  if(is.numeric(GammaVal)){image <- image^GammaVal}
  array(image, dim=c(shape[1], shape[2], shape[3]))
}

processing_2d_image_GT <- function(file, type="png", shape){
  image <- readImage(file, type=type)
  image <- resize(image, w = shape[1], h = shape[2], filter = "none")
  array(image, dim=c(shape[1], shape[2], shape[3]))
}

##Download image data
#ちょっと怪しい

#options(timeout=60^8)
#url1 <- c("https://documents.epfl.ch/groups/c/cv/cvlab-unit/www/data/%20ElectronMicroscopy_Hippocampus/training.tif")
#download.file(url=url, destfile=basename(url1))
#url2 <- c("https://documents.epfl.ch/groups/c/cv/cvlab-unit/www/data/%20ElectronMicroscopy_Hippocampus/training_groundtruth.tif")
#download.file(url=url, destfile=basename(url2))
#url3 <- c("https://documents.epfl.ch/groups/c/cv/cvlab-unit/www/data/%20ElectronMicroscopy_Hippocampus/testing.tif")
#download.file(url=url, destfile=basename(url3))
#url4 <- c("https://documents.epfl.ch/groups/c/cv/cvlab-unit/www/data/%20ElectronMicroscopy_Hippocampus/testing_groundtruth.tif")
#download.file(url=url, destfile=basename(url4))

#library(googledrive)
#library(fs)
#DownloadImageData <- function(FileName = "id0001_Brain_CA1_hippocampus_region.zip"){
#    googledrive::drive_download(file=FileName)
#    unzip(FileName)
#    if(!dir.exists("Dat")){dir.create("Dat")}
#    fs::file_move(sub(".zip", "", FileName), "./Dat")
#    file.remove(FileName)
#}

#WIDTH=256; HEIGHT=256; Z=165; CHANNELS = 1; data="./Dat/"; path01="Brain_CA1_hippocampus_region"
#path02="01_Training";OriginalData="OriginalData"; TeacherData="mitochondria_GT"

library(purrr)
#library(magrittr)
ImgDataImport_3d <- function(WIDTH  = 256, HEIGHT = 256, Z=0, CHANNELS = 1,
                       data="./dat/",
                       path01="id0001_Brain_CA1_hippocampus_region",
                       path02="01_Training",
                       Original_path="OriginalData",
                       Teacher_path="mitochondria_GT"){
    DataDIR <- paste0(data, path01, "/", path02)
    ORIGINAL_PATH = paste0(DataDIR, "/", Original_path)
    Teacher_PATH = paste0(DataDIR, "/", Teacher_path)

    SHAPE = c(WIDTH, HEIGHT, CHANNELS)

    #Original Data
    m0 <- paste0(ORIGINAL_PATH, "/", dir(ORIGINAL_PATH))
    m1 <- length(paste0(ORIGINAL_PATH, "/", dir(ORIGINAL_PATH)))
    DatX <- c()
    if(Z==0){Z <- length(dir(m0[n]))}
    for(n in seq_len(m1)){
    ImageFileTrain = paste0(m0[n], "/", dir(m0[n]))[1:Z]
    X = map(ImageFileTrain, processing_2d_image_train_test, shape = SHAPE)
    DatX[[n]] <- simplify2array(X)
    }

    xTensor1 <- simplify2array(DatX)
    #str(xTensor1)
    xTensor2 <- aperm(xTensor1, c(5, 1, 2, 4, 3))
    #str(xTensor2)

    #Teacher Data
    m2 <- paste0(Teacher_PATH, "/", dir(Teacher_PATH))
    m3 <- length(paste0(Teacher_PATH, "/", dir(Teacher_PATH)))
    DatY <- c()
    for(n in seq_len(m3)){
    ImageFileTrain = paste0(m2[n], "/", dir(m2[n]))[1:Z]
    Y = map(ImageFileTrain, processing_2d_image_GT, shape = SHAPE)
    DatY[[n]] <- simplify2array(Y)
    }

    #str(DatY)
    yTensor1 <- simplify2array(DatY)
    #str(yTensor1)
    yTensor2 <- aperm(yTensor1, c(5, 1, 2, 4, 3))
    #str(yTensor2)

    Img <- list(Original=xTensor2, GroundTruth=yTensor2)
    #str(Img)
    return (Img)
}


DataImport <- function(WIDTH = 1024, HEIGHT = 769, Z=0, CHANNELS = 1,
                       data="./Dat/",
                       path01="id0001_Brain_CA1_hippocampus_region",
                       Original_path="OriginalData",
                       Teacher_path="mitochondria_GT"){
a <- ImgDataImport_3d(WIDTH  = WIDTH, HEIGHT = HEIGHT, Z=Z, CHANNELS = CHANNELS,
                 data=data, path01=path01, path02="01_Training",
                 Original_path=Original_path, Teacher_path=Teacher_path)
#str(a)
names(a) <- c("Train_Original", "Train_GroundTruth")
b <- ImgDataImport_3d(WIDTH  = WIDTH, HEIGHT = HEIGHT, Z=Z, CHANNELS = CHANNELS,
                 data=data, path01=path01, path02="02_Testing",
                 Original_path=Original_path, Teacher_path=Teacher_path)
#str(b)
names(b) <- c("Test_Original", "Test_GroundTruth")
Img <- list(Train=a, Test=b)
#str(Img)
#str(Img$Train)
#str(Img$Test)

saveRDS(Img, paste0(path01, ".Rda"), compress = T)

}



