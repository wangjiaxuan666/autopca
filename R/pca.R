#' PCA plot
#'
#' @param data iput data form the function 'pca_data_tidy'
#' @param center the prcomp param, detail see '?prcomp'
#' @param retx the prcomp param, detail see '?prcomp'
#' @param str_sample the 'regexp' for the sample name to become the target name
#' @param str_group the 'regexp' for the group name to become the target name
#'
#' @return a ggplot object
#' @export
#'
#' @examples pca(iris[,-5])

pca <- function(data = exp_data,center = T,retx = T,scale = FALSE,str_sample = "_.*m", str_group = "-.*"){
  info = prcomp(data,center = center,retx = retx,scale. = scale)
  pca_info <- summary(info)
  tmp <- pca_info$importance
  pc <- pca_info$x
  sample <- rownames(data)
  sample <- stringr::str_replace_all(sample,str_sample,"")
  group <- stringr::str_replace_all(sample,str_group,"")
  rownames(pc) <- sample
  pc <- cbind(pc,group,sample)
  pc <- tibble::as_tibble(pc)
  pc <- dplyr::mutate_at(pc, dplyr::vars("PC1","PC2"),as.double)
  plot <- ggplot2::ggplot(data = pc,mapping = ggplot2::aes(x=PC1,y=PC2))+
    ggplot2::geom_point(size = 2,mapping = ggplot2::aes(color =group))+
    ggplot2::geom_hline(yintercept = 0,linetype = 4,color = "grey")+
    ggplot2::geom_vline(xintercept = 0,linetype = 4,color = "grey")+
    ggplot2::geom_polygon(alpha = 0.5,ggplot2::aes(fill = group))+
    ggplot2::labs(
      x = paste("PC1","(",as.numeric(sprintf("%.3f",tmp[2,1]))*100,"%)",sep=""),
      y = paste("PC2","(",as.numeric(sprintf("%.3f",tmp[2,2]))*100,"%)",sep=""),
      title = "PCA")+
    ggplot2::theme_bw()+
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5,size =12))
  return(plot)
}
