#' UI Module for Network Modification
#'
#' This Module provides a UI object for Network Modification
#'
#' @param id A namespace for the UI.
#' @param mutations.all Helper object that holds mutation names and description texts.
#' @param mutations.params Helper object that holds mutation names and param values, i.e. presets, lower and upper constraints.
#' @return A shiny page.
#' @export

ModifyNetworkUI = function(id, mutations.all, mutations.params)
{
  ns = shiny::NS(id)
  text_general = shiny::div("The ", shiny::a("tspgen", href = "https://github.com/jakobbossek/tspgen", id = "code"),  " package introduces a set of sophisticated, problem tailored mutation operators which allow for the generation of more diverse sets of instances. The proposed mutation operators have a much higher impact on the points than the 'simple' ones, namely normal and uniform mutation. E.g., explosion mutation generates an explosion within the points cloud leaving a hole where not points are placed at all. In contrast cluster mutation selects a random subset of points and generates a circular cluster somewhere in the plane.")

  shiny::sidebarLayout(
    shiny::sidebarPanel(width = 3, shiny::h3("Mutations"), lapply(mutations.all$mutation, function(mut){shinyBS::bsButton(ns(mut), mutations.all$name[mutations.all$mutation == mut], block = TRUE)})),
    shiny::mainPanel(width = 9,
                     shiny::h1("Modify current network instance"), text_general, shiny::hr(),
                     shiny::h3("Collection"),
                     shiny::verbatimTextOutput(ns("currentCollection"), TRUE),
                     #TODO implement?
                     # shinyBS::bsButton(ns("example"), "See example", shiny::icon("play"), block = TRUE), shiny::br(),
                     shiny::fluidRow(
                       shiny::column(2, shiny::numericInput(ns("iterations"), "Iterations", 1, 0, 10000)),
                       shiny::column(10, shiny::div(shiny::tags$label("for" = ns("set_probs"), "Set probabilities"), shinyBS::bsButton(ns("set_probs"), "Uniform probabilities", type = "toggle", block = TRUE)))),
                     shinyBS::bsButton(ns("mutate"), " View network", shiny::icon("play", lib = "glyphicon"), block = TRUE),
                     shinyBS::bsTooltip(ns("set_probs"), "Should mutation probabilities be chosen uniform at random each iteration?", placement = "top"),
                     lapply(as.character(mutations.all$mutation), function(mut){
                       call = ""
                       call = utils::tail(paste0("(network, ", lapply(as.character(mutations.params$param.name[mutations.params$mutation == mut]), function(par){call <<- ifelse(identical(par, utils::tail(as.character(mutations.params$param.name[mutations.params$mutation == mut]), 1)), paste0(call, par, ")"), paste0(call, par, ", "))})),1)
                       tspgui::MutationUI(ns(mut), mutation = mut, mutation.name = mutations.all$name[mutations.all$mutation == mut], mutation.call = shiny::p(paste0("network = tspgen::", mutations.all$call[mutations.all$mutation == mut], call), id = "code"), mutation.text = mutations.all$text[mutations.all$mutation == mut], mutation.params = mutations.params[mutations.params$mutation == mut,])})
    )
  )
}
