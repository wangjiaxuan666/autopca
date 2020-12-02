
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

Notice : if you install `autopca` failed , please check the R installed
envirment. maybe you need install `tidyverse` or `plyr` before. IF YOU
FAILED WITH ANGRY AND BOOM ERRORS. Please contact me with
<poormouse@126.com> , I’ m sorry about what happen to you. Although it’s
me, I also have to admit that this is a bug-filled R package.

> Every time I use this R packages , it will spend 95% time to fix new
> bug\! Although it will spend a little time if i use the scicpt not R
> packages. Automation is always very difficult because it is suitable
> for all kinds of situations and data type. BUT IT IS A FUN WHEN A
> PROBLEM NEED TO THINK

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
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa
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
#>          Test1       Test2     Test3       Test4    Test5
#> Gene1 2.642318  0.01075823 1.9318349  1.14098262 5.112472
#> Gene2 2.044672 -1.38949156 4.2521659 -0.63611784 2.544465
#> Gene3 3.919184 -1.54281478 0.5474906 -0.06008812 3.497520
#> Gene4 3.121889  0.39156311 2.8473876 -0.41146476 3.741726
#> Gene5 4.102010  0.12145176 3.8684541  0.78510128 2.834575
#> Gene6 1.950746  1.80108926 3.4667097 -0.53656806 3.342860
#>             Test6    Test7      Test8    Test9     Test10
#> Gene1 -0.77909277 3.776393 -1.0024396 2.275687 -0.2687162
#> Gene2 -0.10227370 2.231693 -0.8370866 1.668522 -1.2718992
#> Gene3 -0.77420999 3.765379 -0.9111919 2.003686  1.0643598
#> Gene4 -1.87039530 2.353270  0.1492055 2.283257 -0.8706385
#> Gene5 -0.02644458 2.875756  1.5934489 3.165864  1.4495411
#> Gene6 -1.61785791 3.052599  1.5223910 2.276190 -1.1291582
#>       annot
#> Gene1  KEGG
#> Gene2  KEGG
#> Gene3  KEGG
#> Gene4  KEGG
#> Gene5  KEGG
#> Gene6  KEGG
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
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

But `pca` function not only that, It supports regular matching
characters to replace the names of sample or group. When the sample
names is “CK-1\_fokm, CK-2\_fokm,” and so on , It will be very
useful.

``` r
#pca(data = re,# the data didn't exist,just a example to display the parameter
#    display_sample = TRUE,
#    rename = "replace",
#    str_sample = "_.*",
#    str_group = "-\\d$",
#    add_ploy = TRUE)
```

ALL parameters explain :

**Usage**:

    pca(
      data = data,
      center = T,
      retx = T,
      scale = FALSE,
      display_sample = FALSE,
      rename = c("diy", "replace"),
      sample_group = NULL,
      str_sample = NULL,
      str_group = "-.*",
      add_ploy = FALSE
    )

**Arguments**

    data:iput data form the function 'pca_data_tidy'
    
    center:the prcomp param, detail see '?prcomp'
    
    retx:the prcomp param, detail see '?prcomp'
    
    scale:the prcomp param, detail see '?prcomp'
    
    display_sample:if TRUE will add the text labels on points.
    
    rename：the method for change the sample and group names, two argment can choose, "diy" is for the creat a data for name,"replace" is use regexp to replace or change the name
    
    sample_group：a data for change the sample and group name, the rownames is sample and the first column is group
    
    str_sample:the 'regexp' for the sample name to become the target name
    
    str_group:the 'regexp' for the group name to become the target name
    
    add_ploy:if TRUE will add the polygon on points.

Of course, as a fan of `tidyverse`, all function in `autopca` also
support `tibble` data input. If there are any questions and suggestions
in use, welcome questions and suggestions
