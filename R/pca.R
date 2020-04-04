#' PCA plot
#'
#' @param data iput data form the function 'pca_data_tidy'
#' @param center the prcomp param, detail see '?prcomp'
#' @param retx the prcomp param, detail see '?prcomp'
#' @param str_sample the 'regexp' for the sample name to become the target name
#' @param str_group the 'regexp' for the group name to become the target name
#' @param scale the prcomp param, detail see '?prcomp'
#' @param rename the method for change the sample and group names, two argment can choose, "diy" is for the creat a data for name,"replace" is use regexp to replace or change the name
#' @param sample_group a data for change the sample and group name, the rownames is sample and the first column is group
#' @param display_sample if TRUE will add the text labels on points.
#'
#' @return a ggplot object
#' @export
#'
#' @examples pca(iris[,-5],sample_group = as.data.frame(iris[,5]))

pca <- function(data = data,
                center = T,
                retx = T,
                scale = FALSE,
                display_sample = FALSE,
                rename = c("diy","replace"),
                sample_group = NULL,
                str_sample = NULL,
                str_group = "-.*"){
  info = stats::prcomp(data,center = center,retx = retx,scale. = scale)
  pca_info <- summary(info)
  tmp <- pca_info$importance
  pc <- pca_info$x
  sample <- rownames(data)
  rename <- match.arg(rename)
  if(rename == "replace"){
    if(is.null(str_sample)){
      stop("the 'str_sample' argment shoud be existed")
    } else {
      sample <- sub(str_sample,"",sample)
      group <- sub(str_group,"",sample)
    }
  }
  if(rename == "diy"){
    if(is.null(sample_group)){
      sample_group = data.frame(sample = rownames(data),group = rownames(data))
    } else {
      cat("...Notice:","the sequence of sample names\n")
      cat("...must be matched for the input data rownames\n")
      cat("...If not,the result probably is wrong")
    }
    if(is.data.frame(sample_group)){
      if(tibble::is_tibble(data)){
        sample = sample_group[,1]
        group = sample_group[,2]
      } else {
        sample = rownames(sample_group)
        group = as.character(sample_group[,1])
      }
    }
  }
  rownames(pc) <- sample
  pc <- cbind(pc,group,sample)

  if(all(rownames(pc) == sample)){
    pc <- tibble::as_tibble(pc)
    pc <- dplyr::mutate_at(pc, dplyr::vars("PC1","PC2"),as.double)
  } else {
    stop("ERROR!!!!!!, the sample name sequece is not match the input data rowname")
  }
  p1 <- ggplot2::ggplot(data = pc,mapping = ggplot2::aes(x = PC1,y = PC2))+
  ggplot2::geom_point(size = 2,mapping = ggplot2::aes(color = group))+
  ggplot2::geom_hline(yintercept = 0,linetype = 4,color = "grey")+
  ggplot2::geom_vline(xintercept = 0,linetype = 4,color = "grey")+
  ggplot2::stat_ellipse(geom = "polygon", mapping = ggplot2::aes(fill = group),type = "t", level = 0.95, linetype = 2,alpha = 0.2)+
  ggplot2::labs(
    x = paste("PC1","(",as.numeric(sprintf("%.3f",tmp[2,1]))*100,"%)",sep=""),
    y = paste("PC2","(",as.numeric(sprintf("%.3f",tmp[2,2]))*100,"%)",sep=""),
    title = "PCA")+
  ggplot2::scale_fill_brewer(palette = "Set1")
  ggplot2::theme_bw()+
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5,size =12))
  if(display_sample == FALSE){
    plot = p1
  } else {
    plot = p1 + ggplot2::geom_text(ggplot2::aes(label = sample),size = 2)
  }
  return(plot)
}
