setGeneric("partitionUpdate", function(object, ...){standardGeneric("partitionUpdate")})

setMethod("partitionUpdate", "shinySession", function(object, ...){
  availablePartitions <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')
  foo <- lapply(
    names(availablePartitions),
    function(x) RS.assign(object@sockets[["partition"]], x, availablePartitions[[x]])
    )
  return(names(availablePartitions))
})

setGeneric("newPartition", function(object, ...){standardGeneric("newPartition")})
setMethod("newPartition", "shinySession", function(x, ...){
  RS.eval(
    x@sockets[["partition"]],
    shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppPartition', launch.browser=TRUE),
    wait=FALSE
  )
})



setMethod("kwic", "shinySession", function(object, ...){
  capture.output(RS.eval(
    object@sockets[["kwic"]],
    shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppKwic', launch.browser=TRUE),
    wait=FALSE
  ))
})

setMethod("context", "shinySession", function(object, ...){
  RS.eval(
    object@sockets[["context"]],
    shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppContext', launch.browser=TRUE),
    wait=FALSE
  )
})

setMethod("keyness", "shinySession", function(x, ...){
  RS.eval(
    x@sockets[["keyness"]],
    shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppKeyness', launch.browser=TRUE),
    wait=FALSE
  )
})

# setMethod("dispersion"), "shinySession", function(object, type, ...){
#   # assignInNamespace('drillingControls', get('drillingControls', '.GlobalEnv'), 'polmineR.shiny')
#   if (type=="simple") {
#     shiny::runApp(system.file("shinyAppDistribution", package="polmineR.shiny"), launch.browser=TRUE)
#     # shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppDistribution')
#   } else if (type == "crosstab") {
#     shiny::runApp(system.file("shinyAppCrosstab", package="polmineR.shiny"), launch.browser=TRUE)
#     # shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppCrosstab', launch.browser=TRUE)
#   } else if (type == "multi"){
#     shiny::runApp(system.file("shinyAppMulti", package="polmineR.shiny"), launch.browser=TRUE)
#     # shiny::runApp('/Users/blaette/Lab/github/polmineR-shiny/inst/shinyAppMulti')    
#   }
# }
# 
