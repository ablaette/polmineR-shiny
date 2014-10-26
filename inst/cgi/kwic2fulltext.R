run <- function(...){
  passedArgs <- request[["query.string"]]
  sAttrRaw <- lapply(unlist(strsplit(passedArgs[1], "__")), function(x){unlist(strsplit(x, "="))})
  names(sAttrRaw) <- lapply(sAttrRaw, function(x)x[1])
  sAttr <- lapply(sAttrRaw, function(x) gsub("\\+", " ", x[2]))
  step1 <- partition(corpus="PLPRTXT", def=sAttr, tf=NULL, verbose=FALSE)
  step2 <- html(step1, browser=FALSE)
#  out("Content-type: text/html\n\n")
  out(step2)
}
