################################################################
## Image processing
################################################################
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

################################################################
##Download image data
################################################################
if(!dir.exists("AHBioImageDbs_Data")){ dir.create("AHBioImageDbs_Data") }
download.file("https://gist.githubusercontent.com/kumeS/6f67b4b9085b3d2580c51b8ae4953beb/raw/8a00395c533bd8bb16a284568d82b3318b84d3a2/gdrive_download.sh",
               destfile="gdrive_download.sh")

#EM_id0001_Brain_CA1_hippocampus_region
id <- "1kxT5ebWKLJs2Z2uNuiT4mvjuSpC2RF3_"
system(paste0("source gdrive_download.sh; gdrive_download ", id, " ./output.zip; unzip output.zip"))
system("mv EM_id0001_Brain_CA1_hippocampus_region ./AHBioImageDbs_Data")

################################################################
##R Functions to read image files and convert them to the Rdata files
################################################################
library(purrr)
library(magrittr)
library(EBImage)
ImgDataImport_3d <- function(WIDTH  = 256, HEIGHT = 256, Z=-1, CHANNELS = 1,
                       data="./AHBioImageDbs_Data",
                       path01="id0001_Brain_CA1_hippocampus_region",
                       path02="01_Training",
                       Original_path="OriginalData",
                       GroundTruth_path="mitochondria_GT"){
    DataDIR <- paste0(data, "/", path01, "/", path02)
    Original_PATH = paste0(DataDIR, "/", Original_path)
    GroundTruth_PATH = paste0(DataDIR, "/", GroundTruth_path)

    SHAPE = c(WIDTH, HEIGHT, CHANNELS)

    #Original Data
    m0 <- paste0(Original_PATH, "/", dir(Original_PATH))
    m1 <- length(paste0(Original_PATH, "/", dir(Original_PATH)))
    DatX <- c()
    if(Z== -1){Z <- length(dir(m0))}
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
    m2 <- paste0(GroundTruth_PATH, "/", dir(GroundTruth_PATH))
    m3 <- length(paste0(GroundTruth_PATH, "/", dir(GroundTruth_PATH)))
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

DataImport_3d <- function(WIDTH = 1024, HEIGHT = 769, Z=-1, CHANNELS = 1,
                       data="./AHBioImageDbs_Data",
                       path01="id0001_Brain_CA1_hippocampus_region",
                       Original_path="OriginalData",
                       GroundTruth_path="mitochondria_GT"){
a <- ImgDataImport_3d(WIDTH  = WIDTH, HEIGHT = HEIGHT, Z=Z, CHANNELS = CHANNELS,
                 data=data, path01=path01, path02="01_Training",
                 Original_path=Original_path, GroundTruth_path=GroundTruth_path)
#str(a)
names(a) <- c("Train_Original", "Train_GroundTruth")
b <- ImgDataImport_3d(WIDTH  = WIDTH, HEIGHT = HEIGHT, Z=Z, CHANNELS = CHANNELS,
                 data=data, path01=path01, path02="02_Testing",
                 Original_path=Original_path, GroundTruth_path=GroundTruth_path)
#str(b)
names(b) <- c("Test_Original", "Test_GroundTruth")
Img <- list(Train=a, Test=b)
#str(Img)
#str(Img$Train)
#str(Img$Test)

saveRDS(Img, paste0(path01, ".Rda"), compress = T)

}

DataImport_2d_classification <- function(WIDTH = 256, HEIGHT = 256, CHANNELS = 1,
                       data="./AHBioImageDbs_Data",
                       path01="id0002_Human_Chest_Xray_image_Gender_classification"){

    DataDIR <- paste0(data, "/", path01)
    Train_PATH = paste0(DataDIR, "/01_Training")
    SHAPE = c(WIDTH, HEIGHT, CHANNELS)

    #01_Training
    m0 <- paste0(Train_PATH, "/", dir(Train_PATH))
    m1 <- length(dir(Train_PATH))
    DatX <- c()

    file1 <- c()
    file2 <- c()
    for(n in seq_len(m1)){
    file1 <- c(file1, paste0(m0[n], "/", dir(m0[n])))
    file2 <- c(file2, rep(dir(Train_PATH)[n], length(dir(m0[n]))))
    }

    X = map(file1, processing_2d_image_train_test, shape = SHAPE)
    #str(X)
    DatX <- simplify2array(X)
    #str(DatX)
    xTensor1 <- aperm(DatX, c(4, 1, 2, 3))
    #str(xTensor1)
    x <- list(xTensor1, file2)
    #str(x)

    #02_Testing
    Test_PATH = paste0(DataDIR, "/02_Testing")
    m0 <- paste0(Test_PATH, "/", dir(Test_PATH))
    m1 <- length(dir(Test_PATH))
    DatY <- c()

    file1 <- c()
    file2 <- c()
    for(n in seq_len(m1)){
    file1 <- c(file1, paste0(m0[n], "/", dir(m0[n])))
    file2 <- c(file2, rep(dir(Test_PATH)[n], length(dir(m0[n]))))
    }

    Y = map(file1, processing_2d_image_train_test, shape = SHAPE)
    #str(Y)
    DatY <- simplify2array(Y)
    #str(DatY)
    yTensor1 <- aperm(DatY, c(4, 1, 2, 3))
    #str(yTensor1)
    y <- list(yTensor1, file2)
    #str(y)

    Img <- list(Training=x, Test=y)
    #str(Img)

    saveRDS(Img, paste0(path01, ".Rda"), compress = T)

}

ImgDataImport_2d_seg  <- function(WIDTH = 256, HEIGHT = 256, CHANNELS = 1,
                       data="./AHBioImageDbs_Data",
                       path01="id0003_Human_chest_Xray_image_lung_area_extraction",
                       path02="01_Training",
                       Original_path="OriginalData",
                       GroundTruth_path="lung_GroundTruth"){

    DataDIR <- paste0(data, "/", path01)
    Original_PATH = paste0(DataDIR, "/", path02, "/", Original_path)
    SHAPE = c(WIDTH, HEIGHT, CHANNELS)

    #01_Training
    m0 <- paste0(Original_PATH, "/", dir(Original_PATH))
    DatX <- c()

    X = map(m0, processing_2d_image_train_test, shape = SHAPE)
    #str(X)
    DatX <- simplify2array(X)
    #str(DatX)
    xTensor1 <- aperm(DatX, c(4, 1, 2, 3))
    #str(xTensor1)

    #02_Testing
    GroundTruth_PATH = paste0(DataDIR, "/", path02, "/", GroundTruth_path)
    m0 <- paste0(GroundTruth_PATH, "/", dir(GroundTruth_PATH))
    DatY <- c()

    Y = map(m0, processing_2d_image_train_test, shape = SHAPE)
    #str(Y)
    DatY <- simplify2array(Y)
    #str(DatY)
    yTensor1 <- aperm(DatY, c(4, 1, 2, 3))
    #str(yTensor1)

    Img <- list(Training=xTensor1, Test=yTensor1)
    #str(Img)

    return(Img)

}

DataImport_2d_seg <- function(){
a <- ImgDataImport_2d_seg(WIDTH = 256, HEIGHT = 256, CHANNELS = 1,
                       data="./AHBioImageDbs_Data",
                       path01="id0003_Human_chest_Xray_image_lung_area_extraction",
                       path02="01_Training",
                       Original_path="OriginalData",
                       GroundTruth_path="lung_GroundTruth")
}

################################################################
#Convert the images to the array data in R
################################################################
#EM_id0001_Brain_CA1_hippocampus_region
Folder <- "EM_id0001_Brain_CA1_hippocampus_region"
DataImport_3d(WIDTH = 1024, HEIGHT = 768, Z=-1, CHANNELS = 1,
           data="./AHBioImageDbs_Data",
           path01=Folder,
           Original_path="OriginalData",
           GroundTruth_path="mitochondria_GT")

test <- readRDS( paste0(Folder, ".Rda") )
str(test)
#rm(list="test")

#EM_id0002_Drosophila_brain_region
Folder <- "EM_id0002_Drosophila_brain_region"
DataImport_3d(WIDTH = 512, HEIGHT = 512, Z=-1, CHANNELS = 1,
           data="./AHBioImageDbs_Data",
           path01=Folder,
           Original_path="OriginalData",
           GroundTruth_path="membrane_GT")
test <- readRDS( paste0(Folder, ".Rda") )
str(test)


#id0003_Human_chest_Xray_image_lung_area_extraction



#id0004_Human_chest_Xray_image_lung_multilabeling




