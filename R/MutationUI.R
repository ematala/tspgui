MutationUI = function(id, mutation, mutation.name, mutation.call, mutation.text, mutation.params)
{
  ns = shiny::NS(id)
  shiny::tagList(
    shiny::hr(),
    shiny::h3(mutation.name, id = ns("container")),
    shiny::fluidRow(shiny::column(12, mutation.call)),
    lapply(as.character(mutation.params$param.name), function(par){shiny::fluidRow(shiny::column(12, paste0(par, " : ", mutation.params$param.label[mutation.params$param.name == par], ". [min = ", mutation.params$param.lower[mutation.params$param.name == par], ", max = ", mutation.params$param.upper[mutation.params$param.name == par], "]"), id = "code"))}), shiny::br(),
    shiny::fluidRow(shiny::column(12, mutation.text)), shiny::br(),
    shiny::fluidRow(lapply(as.character(mutation.params$param.name), function(par){shiny::column(2, shiny::numericInput(ns(par), par, min = mutation.params$param.lower[mutation.params$param.name == par], value = mutation.params$param.preset[mutation.params$param.name == par], max = mutation.params$param.upper[mutation.params$param.name == par]))}),
    shiny::conditionalPanel(condition = "input['modify_network-set_probs']", shiny::column(2, shiny::numericInput(ns("prob"), "prob", 0, 0, 1)))),
    shiny::fluidRow(shiny::column(12, shinyBS::bsButton(ns("toggle_mutation"), "Include", type = "toggle", block = T)))
  )
}