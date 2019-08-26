#' Server Module for Feature Computation
#'
#' This Module provides functionality for Feature Computation
#'
#' @param input Shiny input object.
#' @param output Shiny output object.
#' @param session Shiny session object.
#' @param network A reactive object that holds a TSP instance of class "Network".
#' @param settings A reactive object that holds a list including several settings.
#' @export

ComputeFeatures = function(input, output, session, network, settings)
{
  #TODO: Make allfeatures object reactive
  allFeatures = list()
  feats_as_df = NULL

  shiny::observeEvent({
    network$modifiedNetwork()
    settings()$compute.features
    },{
      if(settings()$compute.features){
        network = network$modifiedNetwork
        shinyjs::enable("download")
        lapply(salesperson::getAvailableFeatureSets()[salesperson::getAvailableFeatureSets() != "VRP"], function(featureSet){
          allFeatures[featureSet] <<- list(eval(parse(text = paste0("salesperson::get", featureSet, "FeatureSet(network())"))))
        })
      }else{
        shinyjs::disable("download")
        allFeatures <<- list()
      }
    })

  output$featureTable = shiny::renderDataTable({
    if(!settings()$compute.features)
      shiny::validate(shiny::need(length(allFeatures) > 0, "No features to display"))
    featureSet = input$select_FeatureSet
    feats = allFeatures[[featureSet]]
    feats_as_df <<- as.data.frame(matrix(data = c(unlist(names(feats)), unlist(feats)), ncol = 2))
    names(feats_as_df) <<- c("Feature", "Value")
    return(feats_as_df)
  }, options = list(pageLength = 10))

  output$table_heading = shiny::renderUI({
    title = input$select_FeatureSet
    shiny::h2(paste0(title, " feature set"))
    if(!settings()$compute.features)
      shiny::h2("No features computed")
  })

  output$download = shiny::downloadHandler(
    filename = function() {paste0(input$select_FeatureSet, "_FeatureSet.csv")},
    content = function(file) {utils::write.csv2(feats_as_df, file = file)}
  )
}
