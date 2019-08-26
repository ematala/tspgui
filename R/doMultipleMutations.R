#' Perform Multiple Iterations of Mutations
#'
#' Performs Multiple Mutations on a given network.
#'
#' @param network An object of class "Network".
#' @param collection An object of class "tspgen_collection".
#' @param iters Number of iterations.
#' @param return.all Should all interim instances be returned?
#' @param upper Upper boundary for network points.
#' @param bound.handling Occasionally during instance generation points are moved outside the boundaries of the point space. The parameter bound.handling determines how to deal with these points.
#' @return A netgen network.

doMultipleMutations = function (network, collection, iters = 10L, return.all = FALSE, upper = 1, bound.handling = "uniform")
{
  tspgenfunctions = loadNamespace("tspgen")
  checkmate::assertClass(network, "Network")
  checkmate::assertClass(collection, "tspgen_collection")
  checkmate::asCount(iters)
  checkmate::assertFlag(return.all)
  checkmate::assertNumber(upper, lower = 1, finite = TRUE)
  checkmate::assertChoice(bound.handling, choices = c("uniform", "boundary"))
  mutators = collection$mutators
  n.mutators = length(mutators)
  names = names(mutators)
  probs = if (is.null(collection$probs))
    rep(1/n.mutators, n.mutators)
  else collection$probs
  # new
  coords = network$coordinates
  if (return.all) {
    coords.list = vector(mode = "list", length = iters + 1)
    coords.list[[1L]] = coords * upper
  }
  for (i in seq_len(iters)) {
    idx = sample(seq_len(n.mutators), size = 1L, prob = probs)
    mutator.fun = names[idx]
    mutator.pars = mutators[[mutator.fun]]
    mutator.pars = BBmisc::insert(mutator.pars, list(coords = coords))
    coords = do.call(mutator.fun, mutator.pars)
    attr(coords, "df") = NULL
    # functions from namespace
    coords = tspgenfunctions$forceToBounds(coords, bound.handling = bound.handling)
    coords = tspgenfunctions$relocateDuplicates(coords)
    if (return.all) {
      coords.list[[i + 1L]] = coords * upper
    }
  }
  if (return.all)
    return(lapply(coords.list, netgen::makeNetwork, lower = 0, upper = upper))
  return(netgen::makeNetwork(coordinates = coords * upper, name = network$name, comment = network$comment,
                             membership = network$membership, edge.weight.type = network$edge.weight.type,
                             lower = network$lower, upper = network$upper))
}
