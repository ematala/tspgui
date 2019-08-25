ViewNetworkUI = function(id)
{
  ns = shiny::NS(id)
  shiny::sidebarLayout(
    shiny::sidebarPanel(width = 3,
                        shiny::h3("Network information"),
                        shiny::textOutput(ns("name")),
                        shiny::textOutput(ns("points")),
                        shiny::textOutput(ns("cluster")),
                        #TODO add or remove
                        shiny::textOutput(ns("alpha")), shiny::hr(),
                        shiny::h3("Options"),
                        shinyBS::bsButton(ns("to_generate"), " Generate", shiny::icon("angle-double-right"), block = T),
                        shinyBS::bsButton(ns("to_modify"), " Modify", shiny::icon("angle-double-right"), block = T),
                        #TODO implement?
                        # shinyBS::bsButton(ns("example"), "See Example", block = T),
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