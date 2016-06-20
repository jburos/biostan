
# biostan

Materials for BioC-2016 workshop entitled "Introduction to Bayesian Inference using Stan with Applications to Cancer Genomics"

## Use

Most of the material for this package is contained within the vignettes.

To install this package, including vignettes: 

```{r}
devtools::install_github('jburos/biostan', build_vignettes=TRUE, dependencies=TRUE)
```

To list & review the vignettes, after having installed the package:

```{r}
vignette(package = "biostan")
```

