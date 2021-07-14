################################################################
## Load the package
################################################################
library(EBImage)
library(magick)
library(purrr)
library(magrittr)
library(filesstrings)
library(animation)

################################################################
#Convert the images to the array data in R
################################################################
################################################################
#EM_id0001_Brain_CA1_hippocampus_region
################################################################
#Set parameters
DataFolder <- "EM_id0001_Brain_CA1_hippocampus_region"
Ori <- "OriginalData"
GT <- "mitochondria_GT"
WIDTH00 <- 1024; HEIGHT00 <- 768; CHANNELS00 <- 1

#Run the conversion
DataImport_3d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, Z=-1, CHANNELS = CHANNELS00,
           data="./BioImageDbs_Data",
           path01=DataFolder,
           Original_path=Ori,
           GroundTruth_path=GT,
           FileName=paste0(DataFolder, "_5dTensor"))

filesstrings::file.move(files=paste0(DataFolder, "_5dTensor.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)

Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_5dTensor.Rds") )
#str(Dat); str(Dat$Train)
for(n in 1:dim(Dat$Train$Train_Original)[1]){
Sample <- paste0(DataFolder, "_5dTensor_train_dataset_",  n)
ImageView3D(Dat$Train, Name=, Sample=n, Interval = 0.5)
filesstrings::file.move(files=paste0(Sample, ".gif"), destinations="./DL_analysis_v01",
                        overwrite = TRUE)
}

################################################################
#EM_id0002_Drosophila_brain_region
################################################################
#Set parameters
DataFolder <- "EM_id0002_Drosophila_brain_region"
WIDTH00 <- 512; HEIGHT00 <- 512; CHANNELS00 <- 1

#Run the conversion
DataImport_3d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, Z=-1, CHANNELS = CHANNELS00,
           data="./BioImageDbs_Data",
           path01=DataFolder,
           Original_path="OriginalData",
           GroundTruth_path="membrane_GT_inv",
           OriginalDataOnlyinTest=TRUE,
           FileName=paste0(DataFolder, "_5dTensor"))

filesstrings::file.move(files=paste0(DataFolder, "_5dTensor.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_5dTensor.Rds") )
str(Dat); str(Dat$Train)
ImageView3D(Dat$Train, Interval=0.4, Name=paste0(DataFolder, "_5dTensor_train_dataset"))
filesstrings::file.move(files=paste0(DataFolder, "_5dTensor_train_dataset.gif"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)

################################################################
#EM_id0003_Drosophila_brain_region
################################################################
#Set parameters
DataFolder <- "EM_id0003_J558L"
WIDTH00 <- 1024; HEIGHT00 <- 1024; CHANNELS00 <- 1

#Run the conversion
DataImport_2d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, CHANNELS = CHANNELS00,
                  data="./BioImageDbs_Data",
                  path01=DataFolder,
                  Original_path="OriginalData",
                  GroundTruth_path="GroundTruth_8b",
                  FileName=paste0(DataFolder, "_4dTensor"))

filesstrings::file.move(files=paste0(DataFolder, "_4dTensor.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_4dTensor.Rds") )
#str(Dat); str(Dat$Train)
#table(Dat$Train$Train_GroundTruth)
Dat$Train$Train_GroundTruth[Dat$Train$Train_GroundTruth < 0.4] <- 0
ImageView2D(Dat$Train, Interval=0.8, Name=paste0(DataFolder, "_4dTensor_train_dataset"))
filesstrings::file.move(files=paste0(DataFolder, "_4dTensor_train_dataset.gif"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)

################################################################
#EM_id0004_PrHudata
################################################################
#Set parameters
DataFolder <- "EM_id0004_PrHudata"
WIDTH00 <- 1024; HEIGHT00 <- 1024; CHANNELS00 <- 1
#Run the conversion
DataImport_2d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, CHANNELS = CHANNELS00,
                  data="./BioImageDbs_Data",
                  path01=DataFolder,
                  Original_path="OriginalData",
                  GroundTruth_path="GroundTruth_8b",
                  FileName=paste0(DataFolder, "_4dTensor"))

filesstrings::file.move(files=paste0(DataFolder, "_4dTensor.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_4dTensor.Rds") )
#str(Dat); str(Dat$Train)
#table(Dat$Train$Train_GroundTruth)
Dat$Train$Train_GroundTruth[Dat$Train$Train_GroundTruth < 0.4] <- 0
ImageView2D(Dat$Train, Interval=0.8, Name=paste0(DataFolder, "_4dTensor_train_dataset"))
filesstrings::file.move(files=paste0(DataFolder, "_4dTensor_train_dataset.gif"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)

################################################################
#LM_id0001_DIC_C2DH_HeLa
################################################################
#Set parameters
DataFolder <- "LM_id0001_DIC_C2DH_HeLa"
WIDTH00 <- 512; HEIGHT00 <- 512; CHANNELS00 <- 1
#Run the conversion
#Multi-label / 4d-tensor
DataImport_2d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, CHANNELS = CHANNELS00,
                  data="./BioImageDbs_Data",
                  path01=DataFolder,
                  Original_path="OriginalData",
                  GroundTruth_path="Cell_GroundTruth_8b",
                  FileName=paste0(DataFolder, "_4dTensor"))

filesstrings::file.move(files=paste0(DataFolder, "_4dTensor.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_4dTensor.Rds") )
str(Dat); str(Dat$Train)
ImageView2D(Dat$Train, Interval=0.25, Name=paste0(DataFolder, "_4dTensor_train_dataset"))
filesstrings::file.move(files=paste0(DataFolder, "_4dTensor_train_dataset.gif"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
#ImageViewGif("LM_id0001_DIC_C2DH_HeLa.gif")

#Binary label / 4d-tensor
DataImport_2d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, CHANNELS = CHANNELS00,
                  data="./BioImageDbs_Data",
                  path01=DataFolder,
                  Original_path="OriginalData",
                  GroundTruth_path="Cell_GroundTruth_8b",
                  FileName=paste0(DataFolder, "_4dTensor"),
                  Binary=TRUE)
filesstrings::file.move(files=paste0(DataFolder, "_4dTensor_Binary.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_4dTensor_Binary.Rds") )
str(Dat); str(Dat$Train)
ImageView2D(Dat$Train, Interval=0.25, Name=paste0(DataFolder, "_4dTensor_Binary_train_dataset"))
filesstrings::file.move(files=paste0(DataFolder, "_4dTensor_Binary_train_dataset.gif"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)

#Multi-label / 5d-tensor
DataImport_3d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, Z=-1, CHANNELS = CHANNELS00,
           data="./BioImageDbs_Data",
           path01=DataFolder,
           Original_path="OriginalData_3D",
           GroundTruth_path="Cell_GroundTruth_8b_3D",
           OriginalDataOnlyinTest=FALSE,
           FileName=paste0(DataFolder, "_5dTensor"))

filesstrings::file.move(files=paste0(DataFolder, "_5dTensor.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_5dTensor.Rds") )
str(Dat); str(Dat$Train)
ImageView3D(Dat$Train, Interval=0.25, Name=paste0(DataFolder, "_5dTensor_train_dataset"))
filesstrings::file.move(files=paste0(DataFolder, "_5dTensor_train_dataset.gif"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)

################################################################
#LM_id0002_PhC_C2DH_U373
################################################################
#Set parameters
DataFolder <- "LM_id0002_PhC_C2DH_U373"
WIDTH00 <- 696; HEIGHT00 <- 520; CHANNELS00 <- 1
#Multi-label / 4d-tensor
DataImport_2d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, CHANNELS = CHANNELS00,
                  data="./BioImageDbs_Data",
                  path01=DataFolder,
                  Original_path="OriginalData",
                  GroundTruth_path="Cell_GroundTruth_8b",
                  FileName=paste0(DataFolder, "_4dTensor"))

filesstrings::file.move(files=paste0(DataFolder, "_4dTensor.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_4dTensor.Rds") )
str(Dat); str(Dat$Train)
ImageView2D(Dat$Train, Interval=0.25, Name=paste0(DataFolder, "_4dTensor_train_dataset"))
filesstrings::file.move(files=paste0(DataFolder, "_4dTensor_train_dataset.gif"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
#ImageViewGif("LM_id0001_DIC_C2DH_HeLa.gif")

#Binary label / 4d-tensor
DataImport_2d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, CHANNELS = CHANNELS00,
                  data="./BioImageDbs_Data",
                  path01=DataFolder,
                  Original_path="OriginalData",
                  GroundTruth_path="Cell_GroundTruth_8b",
                  FileName=paste0(DataFolder, "_4dTensor"),
                  Binary=TRUE)
filesstrings::file.move(files=paste0(DataFolder, "_4dTensor_Binary.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_4dTensor_Binary.Rds") )
str(Dat); str(Dat$Train)
ImageView2D(Dat$Train, Interval=0.25, Name=paste0(DataFolder, "_4dTensor_Binary_train_dataset"))
filesstrings::file.move(files=paste0(DataFolder, "_4dTensor_Binary_train_dataset.gif"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)

#Multi-label / 5d-tensor
DataImport_3d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, Z=-1, CHANNELS = CHANNELS00,
           data="./BioImageDbs_Data",
           path01=DataFolder,
           Original_path="OriginalData_3D",
           GroundTruth_path="Cell_GroundTruth_8b_3D",
           OriginalDataOnlyinTest=FALSE,
           FileName=paste0(DataFolder, "_5dTensor"))

filesstrings::file.move(files=paste0(DataFolder, "_5dTensor.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_5dTensor.Rds") )
str(Dat); str(Dat$Train)
#ImageView3D(Dat$Train, Interval=0.25, Name=paste0(DataFolder, "_5dTensor_train_dataset"))
#filesstrings::file.move(files=paste0(DataFolder, "_5dTensor_train_dataset.gif"),
#                        destinations="./BioImageDbs_Output",
#                        overwrite = TRUE)

################################################################
#LM_id0003_Fluo_N2DH_GOWT1
################################################################
#Set parameters
DataFolder <- "LM_id0003_Fluo_N2DH_GOWT1"
WIDTH00 <- 1024; HEIGHT00 <- 1024; CHANNELS00 <- 1
#Multi-label / 4d-tensor
DataImport_2d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, CHANNELS = CHANNELS00,
                  data="./BioImageDbs_Data",
                  path01=DataFolder,
                  Original_path="OriginalData",
                  GroundTruth_path="Cell_GroundTruth_8b",
                  FileName=paste0(DataFolder, "_4dTensor"))

filesstrings::file.move(files=paste0(DataFolder, "_4dTensor.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_4dTensor.Rds") )
str(Dat); str(Dat$Train)
ImageView2D(Dat$Train, Interval=0.25, Name=paste0(DataFolder, "_4dTensor_train_dataset"))
filesstrings::file.move(files=paste0(DataFolder, "_4dTensor_train_dataset.gif"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)

#Binary label / 4d-tensor
DataImport_2d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, CHANNELS = CHANNELS00,
                  data="./BioImageDbs_Data",
                  path01=DataFolder,
                  Original_path="OriginalData",
                  GroundTruth_path="Cell_GroundTruth_8b",
                  FileName=paste0(DataFolder, "_4dTensor"),
                  Binary=TRUE)
filesstrings::file.move(files=paste0(DataFolder, "_4dTensor_Binary.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_4dTensor_Binary.Rds") )
str(Dat); str(Dat$Train)
ImageView2D(Dat$Train, Interval=0.25, Name=paste0(DataFolder, "_4dTensor_Binary_train_dataset"))
filesstrings::file.move(files=paste0(DataFolder, "_4dTensor_Binary_train_dataset.gif"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)

#Multi-label / 5d-tensor
DataImport_3d_seg(WIDTH = WIDTH00, HEIGHT = HEIGHT00, Z=-1, CHANNELS = CHANNELS00,
           data="./BioImageDbs_Data",
           path01=DataFolder,
           Original_path="OriginalData_3D",
           GroundTruth_path="Cell_GroundTruth_8b_3D",
           OriginalDataOnlyinTest=FALSE,
           FileName=paste0(DataFolder, "_5dTensor"))

filesstrings::file.move(files=paste0(DataFolder, "_5dTensor.Rds"),
                        destinations="./BioImageDbs_Output",
                        overwrite = TRUE)
Dat <- readRDS( paste0("./BioImageDbs_Output/", DataFolder, "_5dTensor.Rds") )
str(Dat); str(Dat$Train)
#ImageView3D(Dat$Train, Interval=0.25, Name=paste0(DataFolder, "_5dTensor_train_dataset"))
#filesstrings::file.move(files=paste0(DataFolder, "_5dTensor_train_dataset.gif"),
#                        destinations="./BioImageDbs_Output",
#                        overwrite = TRUE)

################################################################
#Display the GIF animations
################################################################
#Set parameters
#DataFolder <- "EM_id0001_Brain_CA1_hippocampus_region"
#Display the GIF image
#id0001 <- Display.GIF(GifFileName=paste0("./BioImageDbs_Output/", DataFolder, "_5dTensor_train_dataset.gif"), View=TRUE)
#id0001
#str(id0001)
#class(id0001)


