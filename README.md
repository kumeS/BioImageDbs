# BioImageDbs
Supplies ExperimentHub with 4D/5D arrays of microscopy-based imaging dataset 
including the original images and their supervised labels. 
This dataset is used for an evaluation of the bioimage analytical model using 
machine learning and deep learning. 
The dataset is provided as R list data of the multiple 4D/5D arrays that can be 
loaded to Keras/tensorflow in R. 
The original dataset is available in [Google Drive](https://drive.google.com/drive/folders/1pVCE1JukoY8U1VN4YZmVPFaGtPg80OY-?usp=sharing). 

# [Data source (GoogleDrive)](https://drive.google.com/drive/folders/1pVCE1JukoY8U1VN4YZmVPFaGtPg80OY-?usp=sharing)

# [Vignettes](https://kumes.github.io/BioImageDbs/vignettes/BioImageDbs.html)

# Installation

1. Start R.app

2. Run the following commands in the R console.

```r
if (!requireNamespace("BiocManager", quietly = TRUE)){ install.packages("BiocManager") }
BiocManager::install("BioImageDbs")

library(ExperimentHub)
library(BioImageDbs)
```

# Usage

1. Load the image dataset.

```r
eh <- ExperimentHub()

qr <- query(eh, c("BioImageDbs", "EM_id0001"))

#EM_id0001
N <- 1
qr[N]
str(qr[N])

#Data download
ImgData <- qr[[N]]
str(ImgData)
```

2. Display the GIF animation.

```r
library(magick)
qr <- query(eh, c("BioImageDbs", "EM_id0001"))

N <- 2
qr[N]
magick::image_read(qr[[N]])
```

# License
Copyright (c) 2021 Satoshi Kume released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

# Authors
- Satoshi Kume
- Kozo Nishida

