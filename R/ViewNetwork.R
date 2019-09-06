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
#' @export

ViewNetwork = function(input, output, session, parentSession, network, settings)
{
  ns = session$ns

  # just change the view
  shiny::observeEvent({input$to_generate},{shiny::updateNavbarPage(parentSession, "mainpage", "generate")})
  shiny::observeEvent({input$to_modify},{shiny::updateNavbarPage(parentSession, "mainpage", "modify")})

  # plotly output of current network
  output$plot_main = plotly::renderPlotly({
    network = network$modifiedNetwork
    coordinates = if("ClusteredNetwork" %in% class(network()))
      data.frame(X = network()$coordinates[,1], Y = network()$coordinates[,2], C = network()$membership)
    else
      data.frame(X = network()$coordinates[,1], Y = network()$coordinates[,2], C = rep(1, length(network()$coordinates[,1])))

    plotly::hide_colorbar(plotly::plot_ly(data = coordinates, x=~X, y=~Y, color=~C, colors = settings()$plot.colors, type = "scatter", mode = "markers", size = I(8))) %>%
      plotly::layout(plot_bgcolor=settings()$plot.bg.color, paper_bgcolor=settings()$plot.bg.color)})

  # collection print below plot
  output$currentCollection = shiny::renderPrint({network$currentCollection()})

  # sidebar outputs
  output$name = shiny::renderText({paste0("Network name: ", network$modifiedNetwork()$name)})
  output$points = shiny::renderText({paste0("#Nodes: ", length(network$modifiedNetwork()$coordinates[,1]))})
  output$cluster = shiny::renderText({if(!identical(network$modifiedNetwork()$membership, NULL)) paste0("#Cluster: ", max(network$modifiedNetwork()$membership))})


  # download handler
  output$export = shiny::downloadHandler(
    filename = function() {network$modifiedNetwork()$name},
    content = function(file) {netgen::exportToTSPlibFormat(network$modifiedNetwork(), file, network$modifiedNetwork()$name, network$modifiedNetwork()$comment)}
  )

}
