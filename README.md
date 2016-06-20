
# biostan

Materials for BioC-2016 workshop entitled "Introduction to Bayesian Inference using Stan with Applications to Cancer Genomics"

## Usage

Most of the material for this package is contained within the vignettes.

To install this package, including vignettes: 

```{r}
devtools::install_github('jburos/biostan', build_vignettes=TRUE, dependencies=TRUE)
```

To list & review the vignettes, after having installed the package:

```{r}
vignette(package = "biostan")
```

## Dependencies

This package contains most dependencies in the `Requires` section of the `DESCRIPTION` file. The above-mentioned process should install it without any problems under most circumstances.

However, special consideration should be given to the installation of `rstan` and `rstanarm`.

### clang++ C++ compiler

It is strongly recommended that you install & enable the clang++ C++ compiler on the system in addition to or instead of the more typical g++ compiler. The clang++ compiler will compile Stan models faster and with less memory, so you get get by with an Amazon AMI that has less RAM.

To install it on Ubuntu, you can do

```
sudo apt-get install clang++
```

### ~/.R/Makevars file

To configure R packages to use clang++, there needs to be a file whose path is `~/.R/Makevars` that contains the following:

```
CXX=clang++
CXXFLAGS=-g -O3
```

although on Ubuntu the clang++ executable may actually be called something slightly different (ex: `clang++-3.4`). 

In this case the `~/.R/Makevars` should use the name of the executable (`CXX=clang++-3.4`) instead of the above. 

### install packages from source

Finally, given that v2.10 is expected to be released to CRAN before the workshop (before 6/26), it is recommended for now to install the latest versions of both `rstan` and `rstanarm` from github.

The following process should work: 

* Install StanHeaders (version 2.10.0) from CRAN because it is hard to install from GitHub (due to its submodules)
* Make sure devtools is installed from CRAN
* Install rstan from GitHub via 

    ```
    devtools::install_github("stan-dev/rstan", ref = "develop", subdir = "rstan/rstan", build_vignettes = TRUE, dependencies = TRUE)
    ```
* Install rstanarm from GitHub via 

    ```
    devtools::install_github("stan-dev/rstanarm", args = "--preclean", local = FALSE, build_vignettes = TRUE, dependencies = TRUE)
    ```
    (Note the additional arg `--preclean` provided to the install of rstanarm).
