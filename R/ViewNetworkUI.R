#' UI Module for Network Plotting
#'
#' This Module provides a UI object for Network Plotting
#'
#' @param id A namespace for the UI.
#' @return A shiny page.
#' @export

ViewNetworkUI = function(id)
{
  ns = shiny::NS(id)
  shiny::sidebarLayout(
    shiny::sidebarPanel(width = 3,
                        shiny::h3("Network information"),
                        shiny::textOutput(ns("name")),
                        shiny::textOutput(ns("points")),
                        shiny::textOutput(ns("cluster")),
                        shiny::h3("Options"),
                        shinyBS::bsButton(ns("to_generate"), " Generate", shiny::icon("angle-double-right"), block = TRUE),
                        shinyBS::bsButton(ns("to_modify"), " Modify", shiny::icon("angle-double-right"), block = TRUE),
                        shiny::downloadButton(ns("export"), " Export as TSPlib file", icon = shiny::icon("file"), class = "btn btn-default btn-block shiny-bound-input")
    ),
    shiny::mainPanel(width = 9,
                     shiny::h1("Plot of current network"),
                     plotly::plotlyOutput(ns("plot_main")), shiny::hr(),
                     shiny::h3("Applied mutations"),
                     shiny::verbatimTextOutput(ns("currentCollection"))
    )
  )
}
