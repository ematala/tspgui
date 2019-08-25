# shiny dependencies
library(shiny)
library(shinyjs)
library(shinyBS)
library(shinythemes)
library(shinyWidgets)

# other packages
library(plotly)
library(checkmate)

# tsp related
library(netgen)
library(tspgen)
library(salesperson)

# UI elements
ui = shiny::fluidPage(title = "Visualization of TSP Instance Generators", theme = shinythemes::shinytheme("simplex"), shinyjs::useShinyjs(), shinyjs::extendShinyjs(script = "www/script.js"), tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
                      shiny::navbarPage(title = "Visualization of TSP Instance Generators", id = "mainpage", position = "fixed-top", selected = "generate", collapsible = TRUE,
                                        shiny::tabPanel(title = "GENERATE", value = "generate", GenerateNetworkUI("generate_network"), icon = shiny::icon("connectdevelop")),
                                        shiny::tabPanel(title = "MODIFY", value = "modify", ModifyNetworkUI("modify_network", mutations.all = mutations.all, mutations.params = mutations.params), icon = shiny::icon("sliders")),
                                        shiny::tabPanel(title = "VIEW", value = "view", ViewNetworkUI("view_network"), icon = shiny::icon("eye")),
                                        shiny::tabPanel(title = "FEATURES", value = "features", ComputeFeaturesUI("compute_features"), icon = shiny::icon("bar-chart")),
                                        shiny::tabPanel(title = "SETTINGS", value = "settings", SettingsUI("settings"), icon = shiny::icon("cog"))
                      )
)

# Server function
server = function(input, output, session){
  # start server
  shiny::showNotification("Welcome!", type = "message")

  # call modules that return objects first
  settings = shiny::callModule(Settings, "settings")
  currentNetwork = shiny::callModule(GenerateNetwork, "generate_network", parentSession = session)
  modifiedNetwork = shiny::callModule(ModifyNetwork, "modify_network", parentSession = session, network = currentNetwork, mutations.all = mutations.all, mutations.params = mutations.params)

  # call modules that display objects
  shiny::callModule(ViewNetwork, "view_network", parentSession = session, network = modifiedNetwork, settings = settings)
  shiny::callModule(ComputeFeatures, "compute_features", network = modifiedNetwork, settings = settings)

  # stop app
  session$onSessionEnded(stopApp)
}

shiny::shinyApp(ui, server)
