#' Run TSP gui application
#'
#' Checks dependencies and launches a shiny web application.
#'
#' @examples
#' \donttest{
#' runTspGui()
#' }
#' @export

runTspGui = function()
{
  # tsp related
  if (!requireNamespace("netgen", quietly = TRUE)) utils::install.packages("netgen")
  if (!requireNamespace("tspgen", quietly = TRUE)) devtools::install_github("jakobbossek/tspgen", dependencies = TRUE)
  if (!requireNamespace("salesperson", quietly = TRUE)) devtools::install_github("jakobbossek/salesperson", dependencies = TRUE)

  # check appdir
  appDir = system.file("tspgui", package = "tspgui")
  if (appDir == "") stop("Could not find example directory. Try re-installing `tspgui`.", call. = FALSE)

  # start
  shiny::runApp(appDir, display.mode = "normal")
}
