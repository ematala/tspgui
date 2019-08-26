#' UI Module for Network Generation
#'
#' This Module provides a UI object for Network Generation
#'
#' @param id A namespace for the UI.
#' @return A shiny page.

GenerateNetworkUI = function(id)
{
  ns = shiny::NS(id)
  text_general = shiny::div("The ", shiny::a("netgen", href = "https://github.com/jakobbossek/netgen", id = "code"),  " package offers several methods to generate random graphs respectively networks for benchmarking purposes. You may want to generate some random graphs or clustered graphs to perform benchmark studies on some fine algorithms for the travelling salesperson problem as an example. Descriptions of used functions and required arguments will interactively be displayed below. You could start by generating either a network of aforementioned types or importing a TSPlib network via file upload. Furthermore, you are free to choose adding another network and morph, i.e. merge the two instances together.")
  text_random = shiny::p(shiny::p("network = netgen::generateRandomNetwork(n.points, lower, upper)", id = "code"), "Generates a random graph in a hypercube.")
  text_cluster = shiny::p(shiny::p("network = netgen::generateClusteredNetwork(n.cluster, n.points, lower, upper)", id = "code"), "This function generates clustered networks. It first generates n cluster centeres via a latin hypercube design to ensure space-filling property, i. e., to ensure, that the clusters are placed far from each other. It then distributes points to the clusters according to gaussian distributions using the cluster centers as the mean vector and the distance to the nearest neighbour cluster center as the variance. This procedure works well if the box constraints of the hypercube are not too low (see the lower bound for the upper parameter).")
  text_grid = shiny::p(shiny::p("network = netgen::generateGridNetwork(n.points.per.dim, lower, upper)", id = "code"), "Generates a grid network.")
  text_file = shiny::p(shiny::p("network = netgen::importFromTSPlibFormat(file)", id = "code"), "Import network from (extended) TSPlib format.")
  text_multiple = shiny::p(shiny::p("network = netgen::morphInstances(network_a, network_b, alpha)", id = "code"), "This function takes two (clustered) networks with equal number of nodes and generates another instance by applying a convex combination to the coordinates of node pairs. The node pairs are determined by a point matching algorithm, which solves this assignement problem via a integer programming procedure.")

  shiny::sidebarLayout(
    shiny::sidebarPanel(width = 3, shiny::h3("Welcome!"), shiny::br(), "This ", shiny::a("shiny", href = "https://shiny.rstudio.com/", id = "code"), " application makes use of several ", shiny::a("R", href = "https://www.r-project.org/", id = "code") , " packages for experimenting with network graphs for instances of the", shiny::a("Traveling Salesperson Problem", href = "https://en.wikipedia.org/wiki/Travelling_salesman_problem", id = "code"), ".", shiny::br(), shiny::br(), "You can explore the functionality of those packages via this interactive web application!", shiny::br(), shiny::br(), "Start off by generating a network on this page. Afterwards, you may view it, modify it and generate feature sets."),
    shiny::mainPanel(width = 9,
                     shiny::h1("Generate TSP instance"), text_general, shiny::hr(),
                     shiny::conditionalPanel(condition = paste0("input['", ns("network_select"),"'] == 1 && !input['", ns("add_network"),"'] && input['", ns("network_type"),"'] == 1"), shiny::h3("Random network"), text_random, shiny::hr()),
                     shiny::conditionalPanel(condition = paste0("input['", ns("network_select"),"'] == 1 && !input['", ns("add_network"),"'] && input['", ns("network_type"),"'] == 2"), shiny::h3("Clustered network"), text_cluster, shiny::hr()),
                     shiny::conditionalPanel(condition = paste0("input['", ns("network_select"),"'] == 1 && !input['", ns("add_network"),"'] && input['", ns("network_type"),"'] == 3"), shiny::h3("Grid network"), text_grid, shiny::hr()),
                     shiny::conditionalPanel(condition = paste0("input['", ns("network_select"),"'] == 2 && !input['", ns("add_network"),"']"), shiny::h3("File import"), text_file, shiny::hr()),
                     shiny::conditionalPanel(condition = paste0("input['", ns("add_network"),"']"), shiny::h3("Multiple networks"), text_multiple, shiny::hr()),
                     shiny::conditionalPanel(condition = paste0("!input['", ns("add_network"),"']"),
                                             shiny::h3("Options for network"),
                                             shinyWidgets::radioGroupButtons(ns("network_select"), choices = c("Generate" = 1, "Load from TSPlib file" = 2), justified = TRUE),
                                             shiny::conditionalPanel(condition = paste0("input['", ns("network_select"),"'] == 1"),
                                                                     shiny::fluidRow(
                                                                       shiny::column(4, shinyWidgets::pickerInput(ns("network_type"), "Network type", choices = c("Random" = 1, "Clustered" = 2, "Grid" = 3), width = "100%")),
                                                                       shiny::column(2, shiny::numericInput(ns("network_n"), "Points", 50, 1, 5000)),
                                                                       shiny::column(2, shiny::numericInput(ns("network_lower"), "Lower", 0, 0, 5000)),
                                                                       shiny::column(2, shiny::numericInput(ns("network_upper"), "Upper", 100, 0, 10000)),
                                                                       shiny::column(2, shiny::conditionalPanel(condition = paste0("input['", ns("network_type"),"'] == 2"), shiny::numericInput(ns("network_cluster"), "Cluster", 3, 2, 500)))
                                                                     )
                                             ),
                                             shiny::conditionalPanel(condition = paste0("input['", ns("network_select"),"'] == 2"),
                                                                     shiny::fileInput(ns("network_file"), "Select file to load", accept = c("text/plain; charset=us-ascii"), width = "100%")
                                             ), shiny::hr()
                     ),
                     shiny::conditionalPanel(condition = paste0("input['", ns("add_network"),"']"),
                                             shiny::h3("Options for network A"),
                                             shinyWidgets::radioGroupButtons(ns("network_a_select"), choices = c("Generate" = 1, "Load from TSPlib file" = 2), justified = TRUE),
                                             shiny::conditionalPanel(condition = paste0("input['", ns("network_a_select"),"'] == 1"),
                                                                     shiny::fluidRow(
                                                                       shiny::column(4, shinyWidgets::pickerInput(ns("network_a_type"), "Network type", choices = c("Random" = 1, "Clustered" = 2, "Grid" = 3), width = "100%")),
                                                                       shiny::column(2, shiny::numericInput(ns("network_a_n"), "Points", 50, 1, 5000)),
                                                                       shiny::column(2, shiny::numericInput(ns("network_a_lower"), "Lower", 0, 0, 5000)),
                                                                       shiny::column(2, shiny::numericInput(ns("network_a_upper"), "Upper", 100, 0, 10000)),
                                                                       shiny::column(2, shiny::conditionalPanel(condition = paste0("input['", ns("network_a_type"),"'] == 2"), shiny::numericInput(ns("network_a_cluster"), "Cluster", 3, 2, 500)))
                                                                     )
                                             ),
                                             shiny::conditionalPanel(condition = paste0("input['", ns("network_a_select"),"'] == 2"),
                                                                     shiny::fileInput(ns("network_a_file"), "Select file to load", accept = c("text/plain; charset=us-ascii"), width = "100%")
                                             ), shiny::hr(),
                                             shiny::h3("Options for network B"),
                                             shinyWidgets::radioGroupButtons(ns("network_b_select"), choices = c("Generate" = 1, "Load from TSPlib file" = 2), justified = TRUE),
                                             shiny::conditionalPanel(condition = paste0("input['", ns("network_b_select"),"'] == 1"),
                                                                     shiny::fluidRow(
                                                                       shiny::column(4, shinyWidgets::pickerInput(ns("network_b_type"), "Network type", choices = c("Random" = 1, "Clustered" = 2, "Grid" = 3), width = "100%")),
                                                                       shiny::column(2, shiny::numericInput(ns("network_b_n"), "Points", 50, 1, 5000)),
                                                                       shiny::column(2, shiny::numericInput(ns("network_b_lower"), "Lower", 0, 0, 5000)),
                                                                       shiny::column(2, shiny::numericInput(ns("network_b_upper"), "Upper", 100, 0, 10000)),
                                                                       shiny::column(2, shiny::conditionalPanel(condition = paste0("input['", ns("network_b_type"),"'] == 2"), shiny::numericInput(ns("network_b_cluster"), "Cluster", 3, 2, 500)))
                                                                     )
                                             ),
                                             shiny::conditionalPanel(condition = paste0("input['", ns("network_b_select"),"'] == 2"),
                                                                     shiny::fileInput(ns("network_b_file"), "Select file to load", accept = c("text/plain; charset=us-ascii"), width = "100%")
                                             ),
                                             shiny::sliderInput(ns("alpha"), "Alpha", 0, 1, 0.5, width = "100%"),
                                             shinyBS::bsTooltip(ns("alpha"), "The nearer to 1, the more the morphed network will look like network A and vice versa.", "left"), shiny::hr()
                     ),
                     shinyBS::bsButton(ns("view_network"), " View network", shiny::icon("play"), block = TRUE),
                     shinyBS::bsButton(ns("add_network"), " Add network", shiny::icon("plus-circle"), block = TRUE, type = "toggle"), shiny::br()
    )
  )
}
