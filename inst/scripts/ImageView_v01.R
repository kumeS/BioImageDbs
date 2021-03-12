#ImageView
library(EBImage)
library(animation)

ImageView3D <- function(ImgArray=Dat$Train, Sample=1,
                        Lab01="Original", Lab02="Merge", Lab03="Supervised",
                        Name=paste0(DataFolder, "_train_dataset"),
                        Interval = 0.1){
    options(EBImage.display = "raster")
    XYsize = 256
    names(ImgArray) <- c("Original", "GroundTruth")

    saveGIF({
    for(n in seq_len(dim(ImgArray$Original)[4])){
      #n <- 1
      par(bg = 'grey')
      Image_color01 <- paintObjects(resize(ImgArray$GroundTruth[Sample,,,n,], XYsize, XYsize, filter="none")/2,
                                      toRGB(resize(ImgArray$Original[Sample,,,n,], XYsize, XYsize, filter="none")), opac=c(0.25, 0.25),
                                      col=c("red","red"), thick=T, closed=F)
      EBImage::display(EBImage::combine(resize(toRGB(ImgArray$Original[Sample,,,n,]), XYsize, XYsize, filter="none"),
                                          resize(Image_color01, XYsize, XYsize, filter="none"),
                                          resize(toRGB(ImgArray$GroundTruth[Sample,,,n,]), XYsize, XYsize, filter="none")),
                         nx=3, all=TRUE, spacing = 0.01, margin = 70)
      text(x = XYsize*0.5, y = -XYsize*0.175,
             label = Lab01, adj = c(0,1), col = "black", cex = 1.2, pos=1, srt=0)
      text(x = XYsize*0.5+XYsize, y = -XYsize*0.175,
             label = Lab02, adj = c(0,1), col = "black", cex = 1.2, pos=1, srt=0)
      text(x = XYsize*0.5+XYsize*2, y = -XYsize*0.175,
             label = Lab03, adj = c(0,1), col = "black", cex = 1.2, pos=1, srt=0)
      text(x = XYsize*0.5+XYsize, y = XYsize + XYsize*0.05,
             label = paste("Image section: ", n),
             adj = c(0,1), col = "black", cex = 1.2, pos=1, srt=0)
    }}, movie.name = paste0(Name, ".gif"), interval = Interval, dpi=100,
    nmax = dim(ImgArray$Original)[4], ani.width = 600, ani.height=300, ani.type="png")
}

ImageView2D <- function(ImgArray=Dat$Train,
                        Lab01="Original", Lab02="Merge", Lab03="Supervised", Name=DataFolder,
                        Interval = 0.25, Opac=c(0.2, 0.2)){
    options(EBImage.display = "raster")
    XYsize = 256
    names(ImgArray) <- c("Original", "GroundTruth")

    saveGIF({
    for(n in seq_len(dim(ImgArray$Original)[1])){
      #n <- 1
      par(bg = 'grey')
      Image_color01 <- paintObjects(resize(ImgArray$GroundTruth[n,,,], XYsize, XYsize, filter="none")/2,
                                      toRGB(resize(ImgArray$Original[n,,,], XYsize, XYsize, filter="none")), opac=Opac,
                                      col=c("red","red"), thick=T, closed=F)
      EBImage::display(EBImage::combine(resize(toRGB(ImgArray$Original[n,,,]), XYsize, XYsize, filter="none"),
                                          resize(Image_color01, XYsize, XYsize, filter="none"),
                                          resize(toRGB(ImgArray$GroundTruth[n,,,]), XYsize, XYsize, filter="none")),
                         nx=3, all=TRUE, spacing = 0.01, margin = 70)
      text(x = XYsize*0.5, y = -XYsize*0.175,
             label = Lab01, adj = c(0,1), col = "black", cex = 1.2, pos=1, srt=0)
      text(x = XYsize*0.5+XYsize, y = -XYsize*0.175,
             label = Lab02, adj = c(0,1), col = "black", cex = 1.2, pos=1, srt=0)
      text(x = XYsize*0.5+XYsize*2, y = -XYsize*0.175,
             label = Lab03, adj = c(0,1), col = "black", cex = 1.2, pos=1, srt=0)
      text(x = XYsize*0.5+XYsize, y = XYsize + XYsize*0.05,
             label = paste("Image section: ", n),
             adj = c(0,1), col = "black", cex = 1.2, pos=1, srt=0)
    }}, movie.name = paste0(Name, ".gif"), interval = Interval, dpi=100,
    nmax = dim(ImgArray$Original)[1], ani.width = 600, ani.height=300, ani.type="png")
}

ImageViewGif <- function(FileName){
browseURL(FileName, browser = getOption("browser"))
}





