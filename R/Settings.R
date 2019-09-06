#' Server Module for Settings
#'
#' This Module provides server logic for Settings
#'
#' @param input Shiny input object.
#' @param output Shiny output object.
#' @param session Shiny session object.
#' @return A reactive object holding the current settings.
#' @export

Settings = function(input, output, session)
{
  # just return reactive version of settings inputs
  return(shiny::reactive({list(compute.features = input$compute_features, plot.colors = input$plot_colors, plot.bg.color = input$plot_bg_color)}))
}
