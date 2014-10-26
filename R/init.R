#' @import Rserve
#' @import RSclient
setClass(
  "shinySession",
  slots=c(
    sockets="list"
    )
  )

shinySession <- function(){
  Rserve(args="--no-save")
  object <- new(
    "shinySession",
    sockets=list(
      partition=RS.connect(),
      kwic=RS.connect(),
      context=RS.connect(),
      dispersion=RS.connect(),
      keyness=RS.connect()
    )
  )
  cat("To start server for KWIC: sudo /var/FastRWeb/code/start")
  return(object)
}

shutdown <- function(shinySession){
  lapply(shinySession@sockets, RS.close)
  foo <- RS.connect()
  RS.server.shutdown(foo)
  NULL
}
