ModifyNetwork = function(input, output, session, parentSession, network, mutations.all, mutations.params)
{
  # max value for n.iters
  iters_MAX = 10000
  
  # just change the view
  observeEvent({input$mutate}, {shiny::updateNavbarPage(parentSession, "mainpage", "view")}, ignoreInit = T)
  
  # just change the button
  shiny::observeEvent({input$set_probs}, {shinyBS::updateButton(session, session$ns("set_probs"), label = ifelse(input$set_probs, "Individual probabilities", "Uniform probabilities"), style = ifelse(input$set_probs, "info", "default"))}, ignoreInit = T)
  
  # js: jump to mutation container
  lapply(mutations.all$mutation, function(mut){eval(parse(text = paste0("observeEvent({input$", mut, "},{js$jumpToElement(session$ns(paste0('", mut, "', '-container')))})")))})
  
  # collection object
  currentCollection = shiny::reactive({
    collection = tspgen::init()
    lapply(as.character(mutations.all$mutation), function(mut){
      mutationObj = shiny::callModule(Mutation, mut, parentSession = session, mutation = mut, mutation.name = mutations.all$name[mutations.all$mutation == mut], mutation.params = mutations.params[mutations.params$mutation == mut,])
      pars = c(mutationObj$values(), list(collection = collection, fun = as.character(mutations.all$call[mutations.all$mutation == mut])))
      if(mutationObj$is.active)
        collection <<- do.call(addMutator, pars)
    })
    
    if(input$set_probs){
      probs = as.vector(sapply(as.character(mutations.all$mutation[which(mutations.all$call %in% names(collection$mutators))]), function(mut){shiny::callModule(Mutation, mut, parentSession = session, mutation = mut, mutation.name = mutations.all$name[mutations.all$mutation == mut], mutation.params = mutations.params[mutations.params$mutation == mut,])$prob}))
      shiny::validate(shiny::need(try({abs(sum(probs) - 1) < 1e-05}, silent = T), "[setProbabilities] Probabilities must add up to 1."))}
    else{probs = rep(1 / length(collection$mutators), length(collection$mutators))}
    # collection = tspgen::setProbabilities(collection, probs)
    collection$probs = probs
    
    return(collection)
  })
  
  # network object
  modifiedNetwork = shiny::reactive({
    shiny::validate(shiny::need(checkmate::testNumber(input$iterations, lower = 0, upper = iters_MAX), paste0("Number of iterations must be between 0 and ", iters_MAX)))
    if(length(currentCollection()$mutators) == 0) network()
    else suppressWarnings(doMultipleMutations(network = network(), collection = currentCollection(), iters = input$iterations + 1L, upper = network()$upper))
  })
  
  # render current collection
  output$currentCollection = shiny::renderPrint({currentCollection()})
  
  return(list(currentCollection = currentCollection, modifiedNetwork = modifiedNetwork))
}
