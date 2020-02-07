#' the Principal Components Analysis need the data must be transformed
#'
#' @param data the input data must be a dataframe or tibble which' rownames is gene id and colnames is sample name
#'
#' @return a dataframe
#' @export
#'
#' @examples
#' test = matrix(rnorm(200), 20, 10)
#' test[1:10, seq(1, 10, 2)] = test[1:10, seq(1, 10, 2)] + 3
#' test[11:20, seq(2, 10, 2)] = test[11:20, seq(2, 10, 2)] + 2
#' test[15:20, seq(2, 10, 2)] = test[15:20, seq(2, 10, 2)] + 4
#' colnames(test) = paste("Test", 1:10, sep = "")
#' rownames(test) = paste("Gene", 1:20, sep = "")
#' pca_data_tidy(as.data.frame(test))
pca_data_tidy <- function(data){
  if(is.data.frame(data)){
    if(tibble::is_tibble(data)){
      data = data
    } else {
      data = tibble::rownames_to_column(data)
      data = tibble::as_tibble(data)
    }
    data_new =  data[,-1]
    geneid = data[,1]
    data_id <- dplyr::bind_cols(geneid,data_new)
    pca_data=t(as.matrix(data_id))
    exp_data <- pca_data[-1,]
    mode(exp_data)="numeric"
    return(exp_data)
    print("the pca data save in the object 'expr'")
  } else {
    print("please input the data that must be a data.frame")
  }
}
