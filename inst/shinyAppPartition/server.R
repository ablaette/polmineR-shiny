library(shiny)
Sys.setenv(CORPUS_REGISTRY="/Users/blaette/Lab/cwb/registry")
library(polmineR)

saveStatus <- 0

shinyServer(function(input, output, session) {
  output$query <- renderText({
    if (input$goButton == 0) return()
    isolate({
      sAttrRaw <- input$def
      Encoding(sAttrRaw) <- "UTF-8"
      sAttr <- eval(parse(text=paste("list(", sAttrRaw, ")", sep="")))
      p <<- partition(
        corpus=input$corpus,
        def=sAttr,
#  def=list(text_year="2012"),
        label=input$label,
        tf="word",
        encoding="latin1",
        method=input$method,
        xml=input$xml,
        verbose=TRUE
      )
      if (input$label!="") assign(x=input$label, value=p, envir=.GlobalEnv)
      p
    })
    paste(
      'Partition size: ',
      input$label,
      as.numeric(p@size),
      sep='')
     })
 output$saveStatus <- renderText({
   retval <- "object not yet saved"
   if (input$saveButton == 0) return()
   retval <- isolate({filename <- paste(drillingControls$partitionDir, "/", input$label, ".RData", sep="")
     assign(p@label, p)
     save(list=c(p@label), file=filename)
     paste("object saved", p@label, p@size, filename)
     })
    retval
   })
})
