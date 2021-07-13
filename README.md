# BioImageDbs

## Description

This package supplies ExperimentHub with 4D/5D arrays of microscopy-based imaging dataset 
including the original images and their supervised labels. 
This dataset is used for an evaluation of the bioimage analytical model using 
machine learning and deep learning. 
The dataset is provided as R list data of the multiple 4D/5D arrays that can be 
loaded to Keras/tensorflow in R. 

## Topics in this project
- R language usage / Bioconductor
- 2D/3D cellular images and their supervised labels for deep learning in R
- Sharing the bioimage dataset with 4D/5D array (tensor) structures via Bioconductor


  - Future plan
    - Sharing the trained deep learning models in R
    - Integrated usage with rMiW 

## Data source (GoogleDrive)

The original dataset is available in [Google Drive](https://drive.google.com/drive/folders/1pVCE1JukoY8U1VN4YZmVPFaGtPg80OY-?usp=sharing). 

## Vignettes

- [Providing Bioimage Dataset for ExperimentHub](https://kumes.github.io/BioImageDbs/vignettes/BioImageDbs.html)

## Installation

1. Start R.app

2. Run the following commands in the R console.

```r
if (!requireNamespace("BiocManager", quietly = TRUE)){ install.packages("BiocManager") }
BiocManager::install("BioImageDbs")

library(ExperimentHub)
library(BioImageDbs)
```

## Simple usage

1. Search and download the image dataset.

```r
eh <- ExperimentHub()

#Data search
qr <- query(eh, c("BioImageDbs", "EM_id0001"))

#Show the metadata of EM_id0001
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

## License
Copyright (c) 2021 Satoshi Kume released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

## Cite

If any scientific publications derive from this project, you must cite:

Kume S, Nishida K (2021). BioImageDbs: Bio- and biomedical imaging dataset for machine learning and deep learning (for ExperimentHub). Bioconductor: ExperimentHub package.

```
#BibTeX
@misc{Kume2021bioc,
  title={BioImageDbs: Bio- and biomedical imaging dataset for machine learning and deep learning (for ExperimentHub)},
  author={Kume, Satoshi and Nishida, Kozo},
  year={2021},
  publisher={Bioconductor},
  note={Experiment Packages - Release 3.13},
  howpublished={\url{https://bioconductor.org/packages/release/data/experiment/html/BioImageDbs.html}},
}
```

## Authors
- Satoshi Kume
- Kozo Nishida

