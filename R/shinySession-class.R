#' @include polmineR-shiny-package.R
NULL

#' class to manage a shiny session
#' 
#' @slot sockets the sockets are stored here
#' @slot partitionDir taken from drillingControls
#' @import Rserve
#' @import RSclient
#' @rdname shinySession
setClass(
  "shinySession",
  slots=c(
    sockets="list",
    partitionDir="character"
    )
  )

#' Generate shinySession
#' 
#' @param object the shinySession-object
#' @param x alternative way for the shinySession-object
#' @param ... further parameters to be passed
#' @aliases begin shutdown begin,shinySession-method shinySession-class partition,shinySession-method kwic,shinySession-method context,shinySession-method
#' shutdown,shinySession-method keyness,shinySession-method
#' @rdname shinySession
#' @export shinySession
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
    ),
    partitionDir=drillingControls$partitionDir
  )
  cat("\nTo start server for KWIC:\nsudo /var/FastRWeb/code/start\n")
  return(object)
}

