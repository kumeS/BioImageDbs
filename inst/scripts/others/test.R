getwd()
source("./R/ImageDataImport_v02.R")
source("./R/ImageProcessing_v01.R")

library(keras)
library(tidyverse)
#install.packages("BiocManager")
#BiocManager::install("EBImage")
library(EBImage); options(EBImage.display = "raster")
#install.packages("reticulate")
library(reticulate)
#install.packages("tkrplot")
library(tkrplot)
#install.packages("tensorA")
library(tensorA)

A <- TrainDataImport(WIDTH  = 1024, HEIGHT = 768)
str(A)

B <- A$GroundTruth
str(B)

k <- backend(convert = TRUE)
C <- k$k_resize_volumes(as.tensor(B), depth_factor=165, height_factor=512, width_factor=768, data_format="channels_last")
str(C)
#https://keras.rstudio.com/reference/k_resize_volumes.html

install.packages("misc3d")
library(misc3d)
B[B == 0] <- 7.011393e-11
B[B == 1] <- 2.102916e-01
image3d(B, col = c("#FFFFFF00", "red"), sprites = F, jitter = T)
range(B)
table(B)

con <- computeContour3d(B, max(B), 1)
drawScene(makeTriangles(con, alpha=0.5))

#
slices3d(B)
str(v)

quakes

slices3d(v)
range(v)
str(v)

###################################
library(misc3d)
x <- seq(-2,2,len=50)
g <- expand.grid(x = x, y = x, z = x)
v <- array(g$x^4 + g$y^4 + g$z^4, rep(length(x),3))
image3d(v)
con <- computeContour3d(v, max(v), 1)
drawScene(makeTriangles(con, alpha=1))

###################################
library(raster)
## Original data (4x4)
rr <- raster(ncol=4, nrow=4)
rr[] <- 1:16
## Resize to 5x5
ss <- raster(ncol=5,  nrow=5)
ss <- resample(rr, ss)
## Resize to 3x3
tt <- raster(ncol=3, nrow=3)
tt <- resample(rr, tt)
## Plot for comparison
par(mfcol=c(2,2))
plot(rr, main="original data")
plot(ss, main="resampled to 5-by-5")
plot(tt, main="resampled to 3-by-3")
###################################
#install.packages("misc3d")
library(misc3d)
nmix3 <- function(x, y, z, m, s) {
0.4 * dnorm(x, m, s) * dnorm(y, m, s) * dnorm(z, m, s) +
0.3 * dnorm(x, -m, s) * dnorm(y, -m, s) * dnorm(z, -m, s) +
0.3 * dnorm(x, m, s) * dnorm(y, -1.5 * m, s) * dnorm(z, m, s)
}
f <- function(x,y,z) nmix3(x,y,z,.5,.5)
x<-seq(-2,2,len=50)
g <- expand.grid(x = x, y = x, z = x)
v <- array(f(g$x, g$y, g$z), c(length(x), length(x), length(x)))

str(v)

image3d(v)
image3d(v, jitter = TRUE)


#パッケージの読み込み
install.packages("raster")
install.packages("rasterVis")
library(raster)
library(rasterVis)

plot3D(DEM)

data(volcano)
str(volcano)

###データ例の作成#####
#ラスターオブジェクトを作成:rasterコマンド
r <- raster(nrow = 100, ncol = 100)
#class       : RasterLayer
#dimensions  : 10, 10, 100  (nrow, ncol, ncell)
#resolution  : 36, 18  (x, y)
#extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
#coord. ref. : +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0
#ラスターオブジェクトにデータが無いので代入

r[] <- sample(1:30000, 10000, replace = TRUE)
########

#ラスターデータのプロット:levelplotコマンド
#下部のスケール表示:scalesオプション
#スケール位置:marginオプション
#セル色の設定:par.settingsオプション
#rasterTheme, RdBuTheme, BuRdTheme, GrTheme, BTCTheme, PuOrTheme, streamTheme
#およびcustom.themeの使用が可能
levelplot(r, xlab = "TEST1", ylab = "TEST2",
          colorkey = TRUE, margin = TRUE,
          par.settings = custom.theme(pch = 19, cex = 0.7,
                                      region = c("#00bfd4", "#6e5f72")))

#ラスターデータの3Dプロット:plot3Dコマンド
plot3D(r, col = c("#00bfd4", "#6e5f72"))

#ラスターデータの出現数をプロット:histogramコマンド
histogram(r)
