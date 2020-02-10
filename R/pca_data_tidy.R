#' the Principal Components Analysis need the data must be transformed
#'
#' @param data the input data must be a dataframe or tibble which' rownames is gene id and colnames is sample name
#' @param id the rowid, can be a character or the column number
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
#' annot <- c(rep("KEGG",20))
#' test <- data.frame(test,annot)
#' pca_data_tidy(as.data.frame(test)) -> test
pca_data_tidy <- function(data,id = NULL){
  if(is.data.frame(data)){
    if(tibble::is_tibble(data)){
      data = data
      cat("...","Notice:","the input data is a tibble\n")
    } else {
      cat("...","Notice:","the input data is a data frame not a tibble\n")
      data = tibble::rownames_to_column(data)
      data = tibble::as_tibble(data)
      id = "rowname"
    }

    if(is.null(id)){
      data_new =  data[,-1]
      geneid = data[,1]
    } else {
      if(is.numeric(id)){
        data_new =  data[,-id]
        geneid = data[,id]
      } else {
        data_new = data[,-grep(id,colnames(data),ignore.case = TRUE)]
        geneid =  data[,grep(id,colnames(data),ignore.case = TRUE)]
      }
    }

    if(!all(unlist(lapply(data_new, is.numeric)))){
      cat("...","Problem:","the input data vaule in every column must be numberic value\n")
      cat("...","Problem:","the error because the character type value in data\n" )
      data_new = data_new[,unlist(lapply(data_new, is.numeric))]
    } else {
      cat("...","Wonderful:","the input data vaule in every column all be numberic value\n")
    }

    data_id <- cbind(geneid,data_new)
    pca_data=t(as.matrix(data_id))
    exp_data <- pca_data[-1,]
    mode(exp_data)="numeric"
    cat("...","Successed!","the pca data save in the object","\n")
    return(exp_data)

  } else {
    print("...","Failed!!!:","please input the data that must be a data.frame or a tibble")
  }
}
