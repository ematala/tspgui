#' Server Module for Network Generation
#'
#' This Module provides server logic for Network Generation
#'
#' @param input Shiny input object.
#' @param output Shiny output object.
#' @param session Shiny session object.
#' @param parentSession Shiny session object of parent session.
#' @return A reactive object of class "Network".

GenerateNetwork = function(input, output, session, parentSession)
{
  # max values for input validation
  random_n_MAX = 5000
  cluster_n_MAX = 5000
  cluster_c_MAX = 500
  grid_n_MAX = 50

  # just change the view
  shiny::observeEvent({input$view_network},{shiny::updateNavbarPage(parentSession, "mainpage", "view")})

  # update button label and icon
  observeEvent({input$add_network},{
    icon = if(input$add_network) shiny::icon("minus-circle")
    else shiny::icon("plus-circle")
    updateButton(session, session$ns("add_network"), label = ifelse(input$add_network, " Remove network", " Add network"), icon = icon)
  }, ignoreInit = TRUE)

  # network object
  network = shiny::reactive({
    if(!input$add_network){
      switch(as.numeric(input$network_select),
             {
               shiny::validate(
                 shiny::need(checkmate::testNumber(input$network_lower, lower = 0, finite = TRUE), "Lower bound must be greater 0."),
                 shiny::need(checkmate::testNumber(input$network_upper, lower = 0, finite = TRUE), "Upper bound must be greater 0."),
                 shiny::need(input$network_lower < input$network_upper, "Lower bound must be smaller than upper bound."))
               switch (as.numeric(input$network_type),
                       {
                         shiny::validate(shiny::need(checkmate::testNumber(input$network_n, lower = 1, upper = random_n_MAX), paste0("Number of points must be between 1 and ", random_n_MAX, " for random networks.")))
                         netgen::generateRandomNetwork(input$network_n, lower = input$network_lower, upper = input$network_upper)
                       },
                       {
                         shiny::validate(
                           shiny::need(checkmate::testNumber(input$network_cluster, lower = 2, upper = cluster_c_MAX), paste0("Number of cluster must be between 2 and ", cluster_c_MAX, " for clustered networks.")),
                           shiny::need(checkmate::testNumber(input$network_n, lower = 2, upper = cluster_n_MAX), paste0("Number of points must be between 2 and ", cluster_n_MAX, " for clustered networks.")),
                           shiny::need(input$network_cluster <= input$network_n, "Number of clusters must be <= number of points for clustered networks."))
                         netgen::generateClusteredNetwork(input$network_cluster, input$network_n, lower = input$network_lower, upper = input$network_upper)
                       },
                       {
                         shiny::validate(shiny::need(checkmate::testNumber(input$network_n, lower = 1, upper = grid_n_MAX), paste0("Number of points must be between 1 and ", grid_n_MAX, " for grid networks.")))
                         netgen::generateGridNetwork(input$network_n, lower = input$network_lower, upper = input$network_upper)
                       }
               )
             },
             {
               shiny::validate(shiny::need(try({netgen::importFromTSPlibFormat(input$network_file$datapath)}, silent = TRUE), "Please select a valid file to import. The file must include a network in (extended) TSPlib format."))
               netgen::importFromTSPlibFormat(input$network_file$datapath)
             }
      )

    }
    else{
      network1 = switch(as.numeric(input$network_a_select),
                        {
                          shiny::validate(
                            shiny::need(checkmate::testNumber(input$network_a_lower, lower = 0, finite = TRUE), "[Network A] Lower bound must be greater 0 for network A."),
                            shiny::need(checkmate::testNumber(input$network_a_upper, lower = 0, finite = TRUE), "[Network A] Upper bound must be greater 0 for network A."),
                            shiny::need(input$network_a_lower < input$network_a_upper, "[Network A] Lower bound must be smaller than upper bound for network A."))
                          switch (as.numeric(input$network_a_type),
                                  {
                                    shiny::validate(shiny::need(checkmate::testNumber(input$network_a_n, lower = 1, upper = random_n_MAX), paste0("[Network A] Number of points must be between 1 and ", random_n_MAX, " for random network A.")))
                                    netgen::generateRandomNetwork(input$network_a_n, lower = input$network_a_lower, upper = input$network_a_upper)
                                  },
                                  {
                                    shiny::validate(
                                      shiny::need(checkmate::testNumber(input$network_a_cluster, lower = 2, upper = cluster_c_MAX), paste0("[Network A] Number of cluster must be between 2 and ", cluster_c_MAX, " for clustered network A.")),
                                      shiny::need(checkmate::testNumber(input$network_a_n, lower = 2, upper = cluster_n_MAX), paste0("[Network A] Number of points must be between 2 and ", cluster_n_MAX, " for clustered network A.")),
                                      shiny::need(input$network_a_cluster <= input$network_a_n, "[Network A] Number of clusters must be <= number of points for clustered network A."))
                                    netgen::generateClusteredNetwork(input$network_a_cluster, input$network_a_n, lower = input$network_a_lower, upper = input$network_a_upper)
                                  },
                                  {
                                    shiny::validate(shiny::need(checkmate::testNumber(input$network_a_n, lower = 1, upper = grid_n_MAX), paste0("[Network A] Number of points must be between 1 and ", grid_n_MAX, " for grid network A.")))
                                    netgen::generateGridNetwork(input$network_a_n, lower = input$network_a_lower, upper = input$network_a_upper)
                                  }
                          )
                        },
                        {
                          shiny::validate(shiny::need(try({netgen::importFromTSPlibFormat(input$network_a_file$datapath)}, silent = TRUE), "[Network A] Please select a valid file to import. The file must include a network in (extended) TSPlib format."))
                          netgen::importFromTSPlibFormat(input$network_a_file$datapath)
                        }
      )
      network2 = switch(as.numeric(input$network_b_select),
                        {
                          shiny::validate(
                            shiny::need(checkmate::testNumber(input$network_b_lower, lower = 0, finite = TRUE), "[Network B] Lower bound must be greater 0 for network B."),
                            shiny::need(checkmate::testNumber(input$network_b_upper, lower = 0, finite = TRUE), "[Network B] Upper bound must be greater 0 for network B."),
                            shiny::need(input$network_b_lower < input$network_b_upper, "[Network B] Lower bound must be smaller than upper bound for network B."))
                          switch (as.numeric(input$network_b_type),
                                  {
                                    shiny::validate(shiny::need(checkmate::testNumber(input$network_b_n, lower = 1, upper = random_n_MAX), paste0("[Network B] Number of points must be between 1 and ", random_n_MAX, " for random network B.")))
                                    netgen::generateRandomNetwork(input$network_b_n, lower = input$network_b_lower, upper = input$network_b_upper)
                                  },
                                  {
                                    shiny::validate(
                                      shiny::need(checkmate::testNumber(input$network_b_cluster, lower = 2, upper = cluster_c_MAX), paste0("[Network B] Number of cluster must be between 2 and ", cluster_c_MAX, " for clustered network B.")),
                                      shiny::need(checkmate::testNumber(input$network_b_n, lower = 2, upper = cluster_n_MAX), paste0("[Network B] Number of points must be between 2 and ", cluster_n_MAX, " for clustered network B.")),
                                      shiny::need(input$network_b_cluster <= input$network_b_n, "[Network B] Number of clusters must be <= number of points for clustered network B."))
                                    netgen::generateClusteredNetwork(input$network_b_cluster, input$network_b_n, lower = input$network_b_lower, upper = input$network_b_upper)
                                  },
                                  {
                                    shiny::validate(shiny::need(checkmate::testNumber(input$network_b_n, lower = 1, upper = grid_n_MAX), paste0("[Network B] Number of points must be between 1 and ", grid_n_MAX, " for grid network B.")))
                                    netgen::generateGridNetwork(input$network_b_n, lower = input$network_b_lower, upper = input$network_b_upper)
                                  }
                          )
                        },
                        {
                          shiny::validate(shiny::need(try({netgen::importFromTSPlibFormat(input$network_b_file$datapath)}, silent = TRUE), "[Network B] Please select a valid file to import. The file must include a network in (extended) TSPlib format."))
                          netgen::importFromTSPlibFormat(input$network_b_file$datapath)
                        }
      )
      shiny::validate(shiny::need(length(network1$coordinates) == length(network2$coordinates), "Networks A & B must have equal number of points."))
      netgen::morphInstances(network1, network2, input$alpha)
    }
  })
  return(network)
}
