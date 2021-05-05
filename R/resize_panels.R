#' @export
set_panel_dims <- function(ggplot=NULL, ggplot_gtable=ggplotGrob(ggplot), height=width, width=height) {
  if(gtable::is.gtable(ggplot))
      ggplot_gtable <- ggplot

  panels <- grep('panel', ggplot_gtable$layout$name)
  panel_index_w <- unique(ggplot_gtable$layout$l[panels])
  panel_index_h <- unique(ggplot_gtable$layout$t[panels])

  width_ratios <- ggplot_gtable$widths[panel_index_w] %>% as.numeric() %>% (function(x) x/max(x))
  height_ratios <- ggplot_gtable$heights[panel_index_h] %>% as.numeric() %>% (function(x) x/max(x))

  if (getRversion() < '3.3.0')
      stop('[set_panel_dims] R 3.3.0 is required!')

  if (!is.null(width))
      ggplot_gtable$widths[panel_index_w] <- width_ratios * width

  if (!is.null(height))
      ggplot_gtable$heights[panel_index_h] <- height_ratios * height

  invisible(ggplot_gtable)
}

#' @export
show_resized_plot <- function(x) {
  grid::grid.newpage()
  grid::grid.draw(x=x)
}

#' @export
remove_clipping <- function(x) {
  x$layout$clip <- 'off'
  for(i in seq(x$grobs))
    if(!is.null(x$layout$clip))
      x$grobs[[i]]$layout$clip <- 'off'
  x
}

#' Render a ggplot as a gtable
#' 
#' Accepts a \code{ggplot} object and converts it to a \code{gtable} before setting panel dimensions and returning (and showing) the modified \code{gtable}.
#' 
#' @param x Either a \code{ggplot} or \code{gtable}/\code{pheatmap}
#' @param size Value of both \code{width} and \code{height}, if defined
#' @param width,height Numeric values for size of the dimensions
#' @param unit Character for units of \code{width} and \code{height}, passed to \code{grid::unit}
#' 
#' @seealso grid::unit
#' 
#' @imports grid
#' 
#' @export
#'
resize_and_show <- function(x, size, width=height*1.6, height=width/1.6, unit='in') {
  # wrangle dimensions
  if(missing(size) && missing(width) && missing(height))
    stop('(resize_and_show) at least one of size, height or width must be defined!', call.=FALSE)

  if(!missing(size))
    width <- height <- as.numeric(size)

  width %<>% as.numeric() %>% unit(units=unit)
  height %<>% as.numeric() %>% unit( units=unit)

  # wrangle x into a gtable
  x %<>%
    when(class(.) %>% is.element(el='ggplot') ~ ggplotGrob(.),
         class(.) %>% is.element(el='pheatmap') ~ pluck(., 'gtable') %>% (function(x) {x$layout$name[x$layout$name=='matrix'] <- 'panel' ; x}),
         class(.) %>% is.element(el='gtable') ~ .,
         TRUE~class(.) %>% str_c(collapse='/') %>% sprintf(fmt='(resize_and_show) do not know what to do when x is a %s') %>% stop(call.=FALSE))

  # resize the panel(s)
  set_panel_dims(ggplot_gtable=x, height=height, width=width) %>%
    remove_clipping() %>%
    show_resized_plot()
}