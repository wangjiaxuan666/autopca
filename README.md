
<!-- README.md is generated from README.Rmd. Please edit that file -->

# autopca

<!-- badges: start -->

<!-- badges: end -->

Originally,this R package `autopca` was a script I used to draw PCA. PCA
can analyze batch effects in experimental processing, and also analyze
experimental processing factors. In my point, it is very important in
checking omics data. At present, this R package Features are very few
But are under active development. The basic function is already there,
so I placed on `github`, if necessary, you can download and use it
yourself.

## Installation

The R packages only can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("wangjiaxuan666/autopca")
```

## Example

Before we start the PCA analysis, we first need to tidy the input data.
We can use the function `pca_data_tidy`to make the data clean for the
next PCA analysis.It should be noted that the format of the input data
is very important to determine the success of subsequent analysis.

Here, Emphasize the format of the input data. First, PCA analysis use
the function `stat::prcomp`, Consequently the result given the every
observed values’ Variance in principal components. the observed values
is the `prcomp` data’ rownames. For example, the data iris

``` r
head(iris)
#>   Sepal.Length Sepal.Width Petal.Length
#> 1          5.1         3.5          1.4
#> 2          4.9         3.0          1.4
#> 3          4.7         3.2          1.3
#> 4          4.6         3.1          1.5
#> 5          5.0         3.6          1.4
#> 6          5.4         3.9          1.7
#>   Petal.Width Species
#> 1         0.2  setosa
#> 2         0.2  setosa
#> 3         0.2  setosa
#> 4         0.2  setosa
#> 5         0.2  setosa
#> 6         0.4  setosa
```

the rownames is every iris ID number, in iris, we want to demonstrate
the proportion of each iris flower in terms of petal length and width
and so on. That is we want, so for iris data, we just tidy a little for
next analysis. Just like

``` r
library(autopca)
irisgroup <- iris[,5] 
iristidy <- iris[,-5]
pca(iristidy,sample_group = as.data.frame(irisgroup))
#> ...Notice: the sequence of sample names
#> ...must be matched for the input data rownames
#> ...If not,the result probably is wrong
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" /> the
group information is Grouping information is required, otherwise an
error will be reported\!

``` r
#pca(iris)
```

As for why and how to use `autopca`, We need to start from the
beginning.

## Illustration

the `autopca` designed for transcriptome data, The classic transcriptome
data is rownames is gene id, the column names is every observed sample.
sometime it also add some annotation information in the tail. like this.

``` r
test = matrix(rnorm(200), 20, 10)
test[1:10, seq(1, 10, 2)] = test[1:10, seq(1, 10, 2)] + 3
test[11:20, seq(2, 10, 2)] = test[11:20, seq(2, 10, 2)] + 2
test[15:20, seq(2, 10, 2)] = test[15:20, seq(2, 10, 2)] + 4
colnames(test) = paste("Test", 1:10, sep = "")
rownames(test) = paste("Gene", 1:20, sep = "")
annot <- c(rep("KEGG",20))
test <- data.frame(test,annot)
head(test)
#>          Test1       Test2    Test3       Test4
#> Gene1 2.672491 -1.46949959 3.252826 -0.06280428
#> Gene2 2.768949 -0.44892401 2.494386  0.74132818
#> Gene3 1.698751 -0.61545118 3.013371 -0.25985327
#> Gene4 1.583889 -0.58912730 3.427422 -0.74294740
#> Gene5 3.219542 -0.06015898 2.593541  1.01296907
#> Gene6 3.966006  1.12396478 2.956866 -0.72447530
#>          Test5      Test6    Test7      Test8
#> Gene1 3.235160  1.5198640 1.382669  0.4984374
#> Gene2 2.872426  0.9858101 2.941147 -1.5424356
#> Gene3 3.712901 -0.7299233 2.186138 -0.8485324
#> Gene4 3.386010 -0.1949071 1.831074  0.9943122
#> Gene5 4.190842  0.1630293 2.902171  0.3229494
#> Gene6 3.848001  0.7799471 3.962820  1.3969977
#>          Test9     Test10 annot
#> Gene1 1.974234 -1.2025494  KEGG
#> Gene2 3.583025  1.5028618  KEGG
#> Gene3 3.523533 -0.1408430  KEGG
#> Gene4 2.913314  0.8756251  KEGG
#> Gene5 3.837058 -0.2416067  KEGG
#> Gene6 5.665606  2.2361524  KEGG
```

Through the above steps, we obtained a classic transcriptome data frame.
**NOW WE explain the sample variance in PC. So we need tidy the data by
the function`pca_data_tidy`.**

``` r
pca_data_tidy(as.data.frame(test)) -> test_tidy
#> ... Notice: the input data is a data frame not a tibble
#> ... Problem: the input data vaule in every column must be numberic value
#> ... Problem: the error because the character type value in data
#> ... Successed! the pca data save in the object
```

NEXT, we can use the tidy data to analysis, just like this

``` r
as.data.frame(c(rep("A",5),rep("B",5))) -> group
rownames(group) <- colnames(test[,-11])
colnames(group) <- "group"
head(group)
#>       group
#> Test1     A
#> Test2     A
#> Test3     A
#> Test4     A
#> Test5     A
#> Test6     B
pca(test_tidy,sample_group = group)
#> ...Notice: the sequence of sample names
#> ...must be matched for the input data rownames
#> ...If not,the result probably is wrong
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

Of course, as a fan of `tidyverse`, all function in `autopca` also
support `tibble` data input. If there are any questions and suggestions
in use, welcome questions and suggestions
