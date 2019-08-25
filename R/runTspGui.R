runTspGui = function()
{
  # tsp related
  if (!requireNamespace("netgen", quietly = T)) stop("netgen needed for this function to work. Please install it.", call. = F)
  if (!requireNamespace("tspgen", quietly = T)) stop("tspgen needed for this function to work. Please install it.", call. = F)
  if (!requireNamespace("salesperson", quietly = T)) stop("salesperson needed for this function to work. Please install it.", call. = F)
  
  # shiny related
  if (!requireNamespace("shiny", quietly = T)) install.packages("shiny", quiet = T)
  if (!requireNamespace("shinyjs", quietly = T)) install.packages("shinyjs", quiet = T)
  if (!requireNamespace("shinyBS", quietly = T)) install.packages("shinyBS", quiet = T)
  if (!requireNamespace("shinythemes", quietly = T)) install.packages("shinythemes", quiet = T)
  if (!requireNamespace("shinyWidgets", quietly = T)) install.packages("shinyWidgets", quiet = T)
  
  # other
  if (!requireNamespace("plotly", quietly = T)) install.packages("plotly", quiet = T)
  if (!requireNamespace("checkmate", quietly = T)) install.packages("checkmate", quiet = T)
  
  # check appdir
  appDir = system.file("tspgui", package = "tspgui")
  if (appDir == "") stop("Could not find example directory. Try re-installing `mypackage`.", call. = F)
  
  # start
  shiny::runApp(appDir, display.mode = "normal")
}