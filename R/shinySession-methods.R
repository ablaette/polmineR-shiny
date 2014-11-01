#' @importMethodsFrom polmineR partition kwic context keyness
#' @include shinySession-class.R utils.R
NULL

#' @exportMethod begin
setGeneric("begin", function(object, ...){standardGeneric("begin")})
setMethod("begin", "shinySession", function(object, gui=c("partition", "kwic", "context", "keyness", "dispersion")){
  if ("partition" %in% gui) partition(object)
  Sys.sleep(0.3)
  if ("kwic" %in% gui) kwic(object)
  Sys.sleep(0.3)
  if ("context" %in% gui) context(object)
  Sys.sleep(0.3)
  if ("keyness" %in% gui) keyness(object)
  Sys.sleep(0.3)
  if ("dispersion" %in% gui) dispersion(object)
})

setGeneric("shutdown", function(object){standardGeneric("shutdown")})

#' @exportMethod shutdown
#' @rdname shinySession
setMethod("shutdown", "shinySession", function(object){
  lapply(object@sockets, RS.close)
  foo <- RS.connect()
  RS.server.shutdown(foo)
  NULL
})

#' @rdname shinySession
setMethod("partition", "shinySession", function(object, ...){
  RS.eval(
    object@sockets[["partition"]],
    # shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppPartition', launch.browser=TRUE),
    shiny::runApp(system.file("shinyAppPartition", package="polmineR.shiny"), launch.browser=TRUE),
    wait=FALSE
  )
})


#' @rdname shinySession
setMethod("kwic", "shinySession", function(object, ...){
  capture.output(RS.eval(
    object@sockets[["kwic"]],
    shiny::runApp(system.file("shinyAppKwic", package="polmineR.shiny"), launch.browser=TRUE),
#    shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppKwic', launch.browser=TRUE),
    wait=FALSE
  ))
})

#' @rdname shinySession
setMethod("context", "shinySession", function(object, ...){
  RS.eval(
    object@sockets[["context"]],
    shiny::runApp(system.file("shinyAppContext", package="polmineR.shiny"), launch.browser=TRUE),
#    shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppContext', launch.browser=TRUE),
    wait=FALSE
  )
})

#' @rdname shinySession
setMethod("keyness", "shinySession", function(x, ...){
  RS.eval(
    x@sockets[["keyness"]],
    shiny::runApp(system.file("shinyAppKeyness", package="polmineR.shiny"), launch.browser=TRUE),
#    shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppKeyness', launch.browser=TRUE),
    wait=FALSE
  )
})

#' @rdname shinySession
setMethod("dispersion", "shinySession", function(object, ...){
  RS.eval(
    object@sockets[["dispersion"]],
    shiny::runApp(system.file("shinyAppDispersion", package="polmineR.shiny"), launch.browser=TRUE),
    #    shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppDispersion', launch.browser=TRUE),
    wait=FALSE
  ) 
})
 


# #' Shiny app for volatility analysis
# #' 
# #' Fires up a shiny app. The default values of \code{drillingControls} are used.
# #'  
# #' Shiny will open a window in your browser. To other partitions, the function
# #' has to be called again.
# #' 
# #' @author Andreas Blaette
# #' @export shinyVolatility
# shinyVolatility <- function() {
#   # assignInNamespace('drillingControls', get('drillingControls', '.GlobalEnv'), 'polmineR.shiny')
#   shiny::runApp(system.file("shinyAppVolatility", package="polmineR.shiny"), launch.browser=TRUE)
#   # shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppVolatility')
# }
# 
