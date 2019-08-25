Settings = function(input, output, session)
{
  # just return reactive version of settings inputs
  return(shiny::reactive({list(compute.features = input$compute_features, plot.colors = input$plot_colors, plot.bg.color = input$plot_bg_color, plot.axis.color = input$plot_axis_color)}))
}