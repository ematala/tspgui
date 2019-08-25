Mutation = function(input, output, session, parentSession, mutation, mutation.name, mutation.params)
{
  # observe input changes and disable include button for bad values
  shiny::observeEvent({lapply(as.character(mutation.params$param.name), function(par){eval(parse(text = paste0("input$", par)))})},{
    tmp = T
    lapply(as.character(mutation.params$param.name), function(par){tmp <<- tmp & checkmate::testNumber(eval(parse(text = paste0("input$", par))), lower = mutation.params$param.lower[mutation.params$param.name == par], upper = mutation.params$param.upper[mutation.params$param.name == par])})
    shinyBS::updateButton(session, session$ns("toggle_mutation"), disabled = !tmp)}, ignoreInit = T)
  
  # observe mutation included
  shiny::observeEvent({input$toggle_mutation}, {
    if(input$toggle_mutation) lapply(as.character(mutation.params$param.name), shinyjs::disable)
    else lapply(as.character(mutation.params$param.name), shinyjs::enable)
    
    shinyBS::updateButton(session, session$ns("toggle_mutation"), label = ifelse(input$toggle_mutation, "Included", "Include"), style = ifelse(input$toggle_mutation, "success", "default"))
    shinyBS::updateButton(parentSession, parentSession$ns(mutation), style = ifelse(input$toggle_mutation, "success", "default"))
    shinyjs::js$jumpToTop()
    }, ignoreInit = T)
  
  # check input values and return them
  values = shiny::reactive({
    as.list(sapply(as.character(mutation.params$param.name), function(par){
      low = mutation.params$param.lower[mutation.params$param.name == par]
      high = mutation.params$param.upper[mutation.params$param.name == par]
      shiny::validate(shiny::need(checkmate::testNumber(eval(parse(text = paste0("input$", par))), lower = low, upper = high), paste0("[", mutation.name, "] ", par, " argument must be between ", low, " and ", high, " for ", mutation.name, " mutation.")))
      eval(parse(text = paste0("input$", par)))}))
  })
  
  mut = list(values = values, is.active = input$toggle_mutation, prob = input$prob)
  return(mut)
}