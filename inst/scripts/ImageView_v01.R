#ImageView
ImageView3D <- function(ImgArray=Dat$Train, Sample=1,
                        Lab01="Original", Lab02="Merge", Lab03="Supervised",
                        Name=paste0(DataFolder, "_train_dataset"),
                        Interval = 0.1, Dpi=72,
                        Width = 500, Height=250){
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
    }}, movie.name = paste0(Name, ".gif"), interval = Interval, dpi=Dpi,
    nmax = dim(ImgArray$Original)[4], ani.width = Width, ani.height=Height, ani.type="png")
}

ImageView2D <- function(ImgArray=Dat$Train,
                        Lab01="Original", Lab02="Merge", Lab03="Supervised", Name=DataFolder,
                        Interval = 0.25, Opac=c(0.2, 0.2), Dpi=72,
                        Width = 500, Height=250){
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
    }}, movie.name = paste0(Name, ".gif"), interval = Interval, dpi=Dpi,
    nmax = dim(ImgArray$Original)[1], ani.width = Width, ani.height=Height, ani.type="png")
}


# Read adn display GIF animations
Display.GIF <- function(GifFileName, View=T){
a <- magick::image_read(GifFileName)
if(View){print(a); return(a)}else{return(a)}
}

#Convert GIF animations
#ConvertGIF2Rda <- function(GifFileName){
#GifFileName = "./AHBioImageDbs_Output/EM_id0002_Drosophila_brain_region_5dTensor_train_dataset.gif"
#a <- magick::image_read(GifFileName)
#b <- image_convert(a, 'rgba')
#print(a)
#image_info(a)
#b <- a[[1]]
#image_info(b)
#c <- array(b, dim=c(3, 500, 250))
#image_data(img, 'rgba')
#image_info(b)
#image_browse(a)
#image_browse(b)
#saveRDS(b, "gif.Rda", compress = F)
#c <- readRDS("gif.Rda")
#plot(c)
#image_display(c, animate = TRUE)
#d <- magick::as.magick(c)
#}


