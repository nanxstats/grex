# grex

[![Build Status](https://travis-ci.org/road2stat/grex.svg?branch=master)](https://travis-ci.org/road2stat/grex)
[![CRAN Version](http://www.r-pkg.org/badges/version/grex)](http://www.r-pkg.org/badges/version/grex)
[![Downloads from the RStudio CRAN mirror](http://cranlogs.r-pkg.org/badges/grex)](http://cranlogs.r-pkg.org/badges/grex)

`grex` offers a minimal dependency solution for mapping Ensembl gene IDs to Entrez IDs, HGNC gene symbols, and UniProt IDs, for Genotype-Tissue Expression (GTEx) data.

## Installation

Install `grex` from CRAN:

```r
install.packages("grex")
```

Or try the development version on GitHub:

```r
# install.packages("devtools")
devtools::install_github("road2stat/grex")
```

To load the package in R, simply use

```r
library("grex")
```

and you are all set. See [the vignette](http://nanx.me/grex/doc/) (or open with `vignette("grex")` in R) for a quick-start guide.

## Links

* Project website: [http://nanx.me/grex](http://nanx.me/grex)
* GitHub: [https://github.com/road2stat/grex](https://github.com/road2stat/grex)
