#' UI Module for Feature Computation
#'
#' This Module provides a UI object for Feature Computation
#'
#' @param id A namespace for the UI.
#' @return A shiny page.
#' @export

ComputeFeaturesUI = function(id)
{
  ns = shiny::NS(id)
  text_general = shiny::div("The ", shiny::a("salesperson", href = "https://github.com/jakobbossek/salesperson", id = "code"),  " package implements methods to compute characteristic properties, the socalled (instance) features, of TSP instances, e.g., the average edge costs, the angle between a node and both of his nearest neighbor nodes etc. This features can be used to fit performance models and apply machine learning algorithms in the AC context.")

  shiny::sidebarLayout(
    shiny::sidebarPanel(width = 3, shiny::h3("Feature set"),
                        shinyWidgets::pickerInput(ns("select_FeatureSet"), "Select feature set", choices = salesperson::getAvailableFeatureSets()[salesperson::getAvailableFeatureSets() != "VRP"], options = list(`live-search` = TRUE)),
                        shiny::downloadButton(ns("download"), label = "Download as CSV", style = "width:100%;")),
    shiny::mainPanel(width = 9,
                     shiny::h1("Compute feature sets"), text_general, shiny::hr(),
                     shiny::uiOutput(ns("table_heading")),
                     shiny::dataTableOutput(ns("featureTable")))
  )
}
