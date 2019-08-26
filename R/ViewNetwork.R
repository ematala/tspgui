#' Server Module for Network Plotting
#'
#' This Module provides functionality for Network Plotting
#'
#' @param input Shiny input object.
#' @param output Shiny output object.
#' @param session Shiny session object.
#' @param parentSession Shiny session object of parent session.
#' @param network A reactive object that holds a TSP instance of class "Network".
#' @param settings A reactive object that holds a list including several settings.

ViewNetwork = function(input, output, session, parentSession, network, settings)
{
  ns = session$ns

  # just change the view
  shiny::observeEvent({input$to_generate},{shiny::updateNavbarPage(parentSession, "mainpage", "generate")})
  shiny::observeEvent({input$to_modify},{shiny::updateNavbarPage(parentSession, "mainpage", "modify")})

  #isolate correct???
  output$plot_main = plotly::renderPlotly({
    network = network$modifiedNetwork
    coordinates = if("ClusteredNetwork" %in% class(network()))
      data.frame(X = network()$coordinates[,1], Y = network()$coordinates[,2], C = network()$membership)
    else
      data.frame(X = network()$coordinates[,1], Y = network()$coordinates[,2], C = rep(1, length(network()$coordinates[,1])))

    #TODO take care of color change-> with dark bg, labels should be white
    ax = list(titlefont = list(color = plotly::toRGB(settings()$plot.axis.color)), tickfont = list(color = plotly::toRGB(settings()$plot.axis.color)), gridcolor = plotly::toRGB(settings()$plot.axis.color), zerolinecolor = plotly::toRGB(settings()$plot.axis.color), linecolor = plotly::toRGB(settings()$plot.axis.color))
    plotly::hide_colorbar(plotly::plot_ly(data = coordinates, x=~X, y=~Y, color=~C, colors = settings()$plot.colors, type = "scatter", mode = "markers")) %>%
      layout(plot_bgcolor=settings()$plot.bg.color, paper_bgcolor=settings()$plot.bg.color)# %>%
      #layout(paper_bgcolor=settings()$plot.bg.color) #%>%
      # layout(xaxis = ax, yaxis = ax)
    })

  # collection print below plot
  output$currentCollection = shiny::renderPrint({network$currentCollection()})

  #sidebar outputs
  output$name = shiny::renderText({paste0("Network name: ", network$modifiedNetwork()$name)})
  output$points = shiny::renderText({paste0("#Nodes: ", length(network$modifiedNetwork()$coordinates[,1]))})
  output$cluster = shiny::renderText({if(!identical(network$modifiedNetwork()$membership, NULL)) paste0("#Cluster: ", max(network$modifiedNetwork()$membership))})


  # download handler
  output$export = downloadHandler(
    filename = function() {network$modifiedNetwork()$name},
    content = function(file) {netgen::exportToTSPlibFormat(network$modifiedNetwork(), file, network$modifiedNetwork()$name, network$modifiedNetwork()$comment)}
  )

  # deprecated. use plotly to png instead
  # output$pdf = downloadHandler(
  #   filename = function() {paste0(network()$name, ".pdf")},
  #   content = function(file) {ggplot2::ggsave(file, plot = autoplot(network()), device = "pdf", width = 29.7, height = 21, units = c("cm"), dpi = "retina")}
  # )
}
