runTspGui = function()
{
  # devtools
  if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools", quiet = TRUE)

  # tsp related
  if (!requireNamespace("netgen", quietly = TRUE)) install.packages("netgen", quiet = TRUE)
  if (!requireNamespace("tspgen", quietly = TRUE)) devtools::install_github("jakobbossek/tspgen", dependencies = TRUE)
  if (!requireNamespace("salesperson", quietly = TRUE)) devtools::install_github("jakobbossek/salesperson", dependencies = TRUE)

  # shiny related
  if (!requireNamespace("shiny", quietly = TRUE)) install.packages("shiny", quiet = TRUE)
  if (!requireNamespace("shinyjs", quietly = TRUE)) install.packages("shinyjs", quiet = TRUE)
  if (!requireNamespace("V8", quietly = TRUE)) install.packages("V8", quiet = TRUE)
  if (!requireNamespace("shinyBS", quietly = TRUE)) install.packages("shinyBS", quiet = TRUE)
  if (!requireNamespace("shinythemes", quietly = TRUE)) install.packages("shinythemes", quiet = TRUE)
  if (!requireNamespace("shinyWidgets", quietly = TRUE)) install.packages("shinyWidgets", quiet = TRUE)

  # other
  if (!requireNamespace("plotly", quietly = TRUE)) install.packages("plotly", quiet = TRUE)
  if (!requireNamespace("checkmate", quietly = TRUE)) install.packages("checkmate", quiet = TRUE)

  # check appdir
  appDir = system.file("tspgui", package = "tspgui")
  if (appDir == "") stop("Could not find example directory. Try re-installing `mypackage`.", call. = FALSE)

  # start
  shiny::runApp(appDir, display.mode = "normal")
}
