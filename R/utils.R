#' @param ns character string, namespace to be searched
#' @param class character, class to be looked for
#' @return a list with the partitions found in the namespace
#' @noRd
.getClassObjects <- function(ns, class) {
  rawList <- sapply(ls(ns), function(x) class(get(x, ns))[1])
  list <- rawList[rawList %in% class]
  sapply(names(list), function(x) get(x, ns), USE.NAMES=TRUE)
}

