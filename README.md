
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

## Update

### fix bug 20201211

-   [x] pca(dat) :Error in if (sample\_group == FALSE) { : 参数长度为零
-   [ ] 将数据整理放在pca\_data\_tidy中，为后续loading 图做准备
-   [x] sample\_group必须是tibble，要提取第二列
-   [x]
    要加上一个注释说明，str\_group必须在str\_sample已经更改的基础上修改

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
> bug! Although it will spend a little time if i use the scicpt not R
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
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width
#> 1          5.1         3.5          1.4         0.2
#> 2          4.9         3.0          1.4         0.2
#> 3          4.7         3.2          1.3         0.2
#> 4          4.6         3.1          1.5         0.2
#> 5          5.0         3.6          1.4         0.2
#> 6          5.4         3.9          1.7         0.4
#>   Species
#> 1  setosa
#> 2  setosa
#> 3  setosa
#> 4  setosa
#> 5  setosa
#> 6  setosa
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
error will be reported!

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
#>          Test1       Test2    Test3      Test4
#> Gene1 1.725887  0.04764380 2.058779 -1.6059854
#> Gene2 3.760881 -0.65371784 4.874061  0.5028785
#> Gene3 2.929488 -0.44336587 4.445698 -1.8696498
#> Gene4 3.150790 -1.29402215 1.148138 -1.5302857
#> Gene5 1.613527  0.09243078 4.689739 -1.2367590
#> Gene6 2.771555 -0.02040210 1.145823  1.3783527
#>          Test5       Test6    Test7      Test8
#> Gene1 1.073998 -0.50857934 2.896407 -0.4028826
#> Gene2 3.353186  0.90609343 2.991523 -0.5426889
#> Gene3 2.394529  1.05414925 2.062414 -0.5419103
#> Gene4 2.625141  0.01600571 2.581460  1.7061903
#> Gene5 3.523545  1.40460527 4.097694 -0.4929172
#> Gene6 3.908658 -0.01227529 3.268325 -2.0671006
#>          Test9     Test10 annot
#> Gene1 2.186983  0.2255060  KEGG
#> Gene2 3.862698  0.3333618  KEGG
#> Gene3 4.192628  0.8081068  KEGG
#> Gene4 3.582339 -0.1848677  KEGG
#> Gene5 4.736640 -1.1797428  KEGG
#> Gene6 3.897739 -0.3944432  KEGG
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
names is “CK-1\_fokm, CK-2\_fokm,” and so on , It will be very useful.

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
