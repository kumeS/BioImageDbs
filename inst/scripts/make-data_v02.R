################################################################
## Library
################################################################
library(purrr)
library(magrittr)
library(EBImage)
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
#if(!dir.exists("AHBioImageDbs_Data")){ dir.create("AHBioImageDbs_Data") }
#download.file("https://gist.githubusercontent.com/kumeS/6f67b4b9085b3d2580c51b8ae4953beb/raw/8a00395c533bd8bb16a284568d82b3318b84d3a2/gdrive_download.sh", destfile="gdrive_download.sh")

#EM_id0001_Brain_CA1_hippocampus_region
#id <- "1kxT5ebWKLJs2Z2uNuiT4mvjuSpC2RF3_"
#system(paste0("source gdrive_download.sh; gdrive_download ", id, " ./output.zip; unzip output.zip"))
#system("mv EM_id0001_Brain_CA1_hippocampus_region ./AHBioImageDbs_Data")

################################################################
##R Functions to read image files and convert them to the Rdata files
################################################################
ImgDataImport_3d_seg <- function(WIDTH  = 256, HEIGHT = 256, Z=-1, CHANNELS = 1,
                       data="./AHBioImageDbs_Data",
                       path01="id0001_Brain_CA1_hippocampus_region",
                       path02="01_Training",
                       Original_path="OriginalData",
                       GroundTruth_path="mitochondria_GT",
                       OriginalDataOnly=F){
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
    xTensor2 <- aperm(xTensor1, c(5, 1, 2, 4, 3))

    if(!OriginalDataOnly){
    #Teacher Data
    m2 <- paste0(GroundTruth_PATH, "/", dir(GroundTruth_PATH))
    m3 <- length(paste0(GroundTruth_PATH, "/", dir(GroundTruth_PATH)))
    DatY <- c()
    for(n in seq_len(m3)){
    ImageFileTrain = paste0(m2[n], "/", dir(m2[n]))[1:Z]
    Y = map(ImageFileTrain, processing_2d_image_GT, shape = SHAPE)
    DatY[[n]] <- simplify2array(Y)
    }

    yTensor1 <- simplify2array(DatY)
    yTensor2 <- aperm(yTensor1, c(5, 1, 2, 4, 3))

    Img <- list(Original=xTensor2, GroundTruth=yTensor2)
    return (Img)

    }else{
    Img <- list(Original=xTensor2)
    return (Img)
    }
}

DataImport_3d_seg <- function(WIDTH = 1024, HEIGHT = 769, Z=-1, CHANNELS = 1,
                       data="./AHBioImageDbs_Data",
                       path01="id0001_Brain_CA1_hippocampus_region",
                       Original_path="OriginalData",
                       GroundTruth_path="mitochondria_GT",
                       OriginalDataOnlyinTest=F,
                       FileName="id0001_Brain_CA1_hippocampus_region",
                       Binary=F){
a <- ImgDataImport_3d_seg(WIDTH  = WIDTH, HEIGHT = HEIGHT, Z=Z, CHANNELS = CHANNELS,
                 data=data, path01=path01, path02="01_Training",
                 Original_path=Original_path, GroundTruth_path=GroundTruth_path)
#str(a)
names(a) <- c("Train_Original", "Train_GroundTruth")

if(!OriginalDataOnlyinTest){
b <- ImgDataImport_3d_seg(WIDTH  = WIDTH, HEIGHT = HEIGHT, Z=Z, CHANNELS = CHANNELS,
                 data=data, path01=path01, path02="02_Testing",
                 Original_path=Original_path, GroundTruth_path=GroundTruth_path)
#str(b)
names(b) <- c("Test_Original", "Test_GroundTruth")
}else{
b <- ImgDataImport_3d_seg(WIDTH  = WIDTH, HEIGHT = HEIGHT, Z=Z, CHANNELS = CHANNELS,
                 data=data, path01=path01, path02="02_Testing",
                 Original_path=Original_path, GroundTruth_path=GroundTruth_path,
                 OriginalDataOnly=T)
#str(b)
names(b) <- c("Test_Original")
}

if(!Binary){
Img <- list(Train=a, Test=b)
saveRDS(Img, paste0(FileName, ".Rda"), compress = T)
}else{
if(!OriginalDataOnlyinTest){
a$Train_GroundTruth[a$Train_GroundTruth > 0] <- 1
names(a) <- c("Train_Original", "Train_GroundTruth_Binary")

b$Test_GroundTruth[b$Test_GroundTruth > 0] <- 1
names(b) <- c("Test_Original", "Test_GroundTruth_Binary")

Img <- list(Train=a, Test=b)
saveRDS(Img, paste0(FileName, "_Binary.Rda"), compress = T)
}else{
a$Train_GroundTruth[a$Train_GroundTruth > 0] <- 1
names(a) <- c("Train_Original", "Train_GroundTruth_Binary")

Img <- list(Train=a, Test=b)
saveRDS(Img, paste0(FileName, ".Rda"), compress = T)
}
}
}

ImgDataImport_2d_seg  <- function(WIDTH = 256, HEIGHT = 256, CHANNELS = 1,
                       data="./AHBioImageDbs_Data",
                       path01="LM_id0001_DIC_C2DH_HeLa",
                       path02="01_Training",
                       Original_path="OriginalData",
                       GroundTruth_path="Cell_GroundTruth_8b" ){

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

DataImport_2d_seg <- function(WIDTH = 512, HEIGHT = 512, CHANNELS = 1,
                       data="./AHBioImageDbs_Data",
                       path01="LM_id0001_DIC_C2DH_HeLa",
                       Original_path="OriginalData",
                       GroundTruth_path="Cell_GroundTruth_8b",
                       FileName="LM_id0001_DIC_C2DH_HeLa",
                       Binary=F){
a <- ImgDataImport_2d_seg(WIDTH = WIDTH, HEIGHT = HEIGHT, CHANNELS = CHANNELS,
                       data=data,
                       path01=path01,
                       path02="01_Training",
                       Original_path=Original_path,
                       GroundTruth_path="Cell_GroundTruth_8b")
names(a) <- c("Train_Original", "Train_GroundTruth")

b <- ImgDataImport_2d_seg(WIDTH = WIDTH, HEIGHT = HEIGHT, CHANNELS = CHANNELS,
                       data=data,
                       path01=path01,
                       path02="02_Testing",
                       Original_path=Original_path,
                       GroundTruth_path=GroundTruth_path)
names(b) <- c("Test_Original", "Test_GroundTruth")

if(!Binary){
Img <- list(Train=a, Test=b)
saveRDS(Img, paste0(FileName, ".Rda"), compress = T)
}else{
a$Train_GroundTruth[a$Train_GroundTruth > 0] <- 1
names(a) <- c("Train_Original", "Train_GroundTruth_Binary")

b$Test_GroundTruth[b$Test_GroundTruth > 0] <- 1
names(b) <- c("Test_Original", "Test_GroundTruth_Binary")

Img <- list(Train=a, Test=b)
saveRDS(Img, paste0(FileName, "_Binary.Rda"), compress = T)
}
}

################################################################
#Convert the images to the array data in R
################################################################
#EM_id0001_Brain_CA1_hippocampus_region
DataFolder <- "EM_id0001_Brain_CA1_hippocampus_region"
DataImport_3d_seg(WIDTH = 1024, HEIGHT = 768, Z=-1, CHANNELS = 1,
           data="./AHBioImageDbs_Data",
           path01=DataFolder,
           Original_path="OriginalData",
           GroundTruth_path="mitochondria_GT",
           FileName=paste0(DataFolder, "_5dTensor"))

Dat <- readRDS( paste0(DataFolder, "_5dTensor.Rda") )
str(Dat); str(Dat$Train)
ImageView3D(Dat$Train, Name=paste0(DataFolder, "_5dTensor_train_dataset"))
#rm(list="Dat")

#EM_id0002_Drosophila_brain_region
DataFolder <- "EM_id0002_Drosophila_brain_region"
DataImport_3d_seg(WIDTH = 512, HEIGHT = 512, Z=-1, CHANNELS = 1,
           data="./AHBioImageDbs_Data",
           path01=DataFolder,
           Original_path="OriginalData",
           GroundTruth_path="membrane_GT_inv",
           OriginalDataOnlyinTest=T,
           FileName=paste0(DataFolder, "_5dTensor"))

Dat <- readRDS( paste0(DataFolder, "_5dTensor.Rda") )
str(Dat); str(Dat$Train)
ImageView3D(Dat$Train, interval=0.25, Name=paste0(DataFolder, "_5dTensor_train_dataset"))
#rm(list="Dat")

#LM_id0001_DIC_C2DH_HeLa
DataFolder <- "LM_id0001_DIC_C2DH_HeLa"
DataImport_2d_seg(WIDTH = 512, HEIGHT = 512, CHANNELS = 1,
                  data="./AHBioImageDbs_Data",
                  path01=DataFolder,
                  Original_path="OriginalData",
                  GroundTruth_path="Cell_GroundTruth_8b",
                  FileName=paste0(DataFolder, "_4dTensor"))
Dat <- readRDS( paste0(DataFolder, "_4dTensor.Rda") )
str(Dat); str(Dat$Train)
ImageView2D(Dat$Train, interval=0.25, Name=paste0(DataFolder, "_4dTensor_train_dataset"))
#ImageViewGif("LM_id0001_DIC_C2DH_HeLa.gif")

DataImport_2d_seg(WIDTH = 512, HEIGHT = 512, CHANNELS = 1,
                  data="./AHBioImageDbs_Data",
                  path01=DataFolder,
                  Original_path="OriginalData",
                  GroundTruth_path="Cell_GroundTruth_8b",
                  FileName=paste0(DataFolder, "_4dTensor"),
                  Binary=T)
Dat <- readRDS( paste0(DataFolder, "_4dTensor_Binary.Rda") )
str(Dat); str(Dat$Train)
ImageView2D(Dat$Train, interval=0.25, Name=paste0(DataFolder, "_4dTensor_Binary_train_dataset"))

DataImport_3d_seg(WIDTH = 512, HEIGHT = 512, Z=-1, CHANNELS = 1,
           data="./AHBioImageDbs_Data",
           path01=DataFolder,
           Original_path="OriginalData_3D",
           GroundTruth_path="Cell_GroundTruth_8b_3D",
           OriginalDataOnlyinTest=F,
           FileName=paste0(DataFolder, "_5dTensor"))

Dat <- readRDS( paste0(DataFolder, "_5dTensor.Rda") )
str(Dat); str(Dat$Train)
ImageView3D(Dat$Train, interval=0.25, Name=paste0(DataFolder, "_5dTensor_train_dataset"))
#rm(list="Dat")

#LM_id0002_PhC_C2DH_U373



#LM_id0003_Fluo_N2DH_GOWT1





