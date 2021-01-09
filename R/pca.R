#' PCA plot
#'
#' @param data iput data form the function 'pca_data_tidy' or a matrix of column(gene) and row(sample).
#' @param center the prcomp param, detail see '?prcomp'
#' @param retx the prcomp param, detail see '?prcomp'
#' @param scale the prcomp param, detail see '?prcomp'
#' @param rename the very important parameter,if don't input the rename parameter, will take it as no group.
#' and rename default is "diy", the method for change the sample and group names, two argment
#' can choose, "diy" is for the creat a data for name use the parameter "sample_group", if rename = "replace" is use regexp to
#' replace for change the name by the parameter "str_sample" and "str_group".
#' @param str_sample need the parameter only when rename = "replace", the 'regexp'
#' for the sample name to become the target name
#' @param str_group need the parameter only when rename = "replace", the 'regexp'
#' for the group name base on the sample names haved changed by "str_sample".
#' @param sample_group need the parameter only when rename = "diy", a data frame
#'  for change the sample and group name, the rownames is sample and the first
#'  column is group. or a tibble ,the first column is sample name and the second column is group names.
#' @param display_name if TRUE will add the text labels on points.
#' @param add_ploy will add the ploy line to encircle the sample points, can
#' choose the ploy style form "ellipse","encircle","polygon", see the plot in
#' example. the default is "polygon".
#' @param name_size the font size of sample name.
#' @param point_size the size of the piont
#'
#' @return a ggplot object
#' @export
#' @importFrom ggplot2 ggplot aes geom_point geom_vline geom_hline theme_bw labs theme element_text element_line theme geom_polygon stat_ellipse
#' @importFrom dplyr mutate_at vars
#' @importFrom tibble is_tibble as_tibble
#' @importFrom stats prcomp
#' @importFrom ggalt geom_encircle
#'
#' @examples library(autopca)
#' pca(iris[,-5],sample_group = as.data.frame(iris[,5]))
#' pca(iris[,-5],sample_group = as.data.frame(iris[,5]),add_ploy = "ellipse")
#' pca(iris[,-5],sample_group = as.data.frame(iris[,5]),add_ploy = "encircle")
#' pca(iris[,-5],sample_group = as.data.frame(iris[,5]),add_ploy = "polygon")

pca <- function(data = data,
                center = T,
                retx = T,
                scale = FALSE,
                display_name = FALSE,
                rename = c("diy","replace"),
                sample_group = NULL,
                str_sample = NULL,
                str_group = "-.*",
                add_ploy = c("null","ellipse","encircle","polygon"),
                name_size = 4,
                point_size = 2
){
  info = stats::prcomp(data,center = center,retx = retx,scale. = scale)
  pca_info = summary(info)
  tmp = pca_info$importance
  pc = pca_info$x
  sample = rownames(data)
  rename = match.arg(rename)
  ploy_style = match.arg(add_ploy)

  if(rename == "replace"){
    if(is.null(str_sample)){
      stop("the 'str_sample' argment must be existed")
    } else {
      sample <- sub(str_sample,"",sample)
      group <- sub(str_group,"",sample)
      if_n = length(unique(sample))/length(unique(group))
    }
  }

  if(rename == "diy"){
    if(is.null(sample_group)){
      sample = rownames(data)
      group = rownames(data)
      cat("...Notice:","the sequence of sample names\n")
      cat("...must be same with the input data rownames\n")
    } else {
      if(is.data.frame(sample_group)){
        if(tibble::is_tibble(data)){
          sample = sample_group[,1]
          group = sample_group[,2]
        } else {
          sample = rownames(sample_group)
          group = as.character(sample_group[,1])
        }
      } else {
        cat("...the sample_group must be a dataframe or tibble\n")
      }
    }
    if_n = length(unique(sample))/length(unique(group))
  }

  rownames(pc) <- sample
  pc <- cbind(pc,group,sample)

  if(all(rownames(pc) == sample)){
    pc <- tibble::as_tibble(pc)
    pc <- dplyr::mutate_at(pc, dplyr::vars("PC1","PC2"),as.double)
  } else {
    stop("ERROR!!!!!!, the sample name sequece is not match the input data rowname")
  }
  plot <- ggplot2::ggplot(data = pc,mapping = ggplot2::aes(x = PC1,y = PC2))+
    ggplot2::geom_point(size = point_size,mapping = ggplot2::aes(color = group))+
    ggplot2::geom_hline(yintercept = 0,linetype = 4,color = "grey")+
    ggplot2::geom_vline(xintercept = 0,linetype = 4,color = "grey")+
    ggplot2::labs(
      x = paste("PC1","(",as.numeric(sprintf("%.3f",tmp[2,1]))*100,"%)",sep=""),
      y = paste("PC2","(",as.numeric(sprintf("%.3f",tmp[2,2]))*100,"%)",sep=""),
      title = "PCA")+
    ggplot2::theme_bw()+
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5,size =12))

  if(display_name == FALSE){
    plot = plot
  } else {
    plot = plot + ggplot2::geom_text(ggplot2::aes(label = sample),size = name_size)
  }

  # add plot line
  if(!ploy_style == "null"){
    # must be first vector and select from three input
    if(ploy_style[1] %in% c("ellipse","encircle","polygon")){
      ploy_style = ploy_style[1]
    } else {
      ploy_style = "polygon"
    }
    # three sample can't caculate ellipse will change to
    if(if_n <= 3 & ploy_style == "ellipse"){
      ploy_style = "polygon"
    }

    if(ploy_style == "ellipse"){
      plot = plot + ggplot2::stat_ellipse(geom = "polygon", mapping = ggplot2::aes(fill = group),type = "t", level = 0.95, linetype = 2,alpha = 0.2)
    }

    if(ploy_style == "encircle"){
      plot = plot + ggalt::geom_encircle(ggplot2::aes(group = group,fill = group),alpha=0.4)
    }

    if(ploy_style == "polygon"){
      plot = plot + ggalt::geom_encircle(ggplot2::aes(group = group,fill = group),alpha=0.4,s_shape=1, expand=0)
    }
  }
  # end
  return(plot)
}
