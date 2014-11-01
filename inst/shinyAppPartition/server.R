library(shiny)
Sys.setenv(CORPUS_REGISTRY="/Users/blaette/Lab/cwb/registry")
library(polmineR)

saveStatus <- 0
setupStatus <- 0
statusMessage <- "waiting for instructions"
retval <- NULL

shinyServer(function(input, output, session) {
  observe({
    if (input$goButton == 0) return()
    isolate({
      setupStatus <<- 0
      sAttrRaw <- input$def
      Encoding(sAttrRaw) <- "UTF-8"
      sAttr <- eval(parse(text=paste("list(", sAttrRaw, ")", sep="")))
      partitionObject <<- partition(
        as.character(input$corpus),
        def=sAttr,
        #  def=list(text_year="2012"),
        label=input$label,
        tf=input$tf,
        meta=NULL,
        encoding="latin1",
        method=input$method,
        xml=input$xml,
        mc=input$mc,
        verbose=FALSE
      )
      if (input$label!="") assign(x=input$label, value=partitionObject, envir=.GlobalEnv)
      setupStatus <<- 1
    })
  })
  partitionCall <- reactive({
    paste(
      'partition(',
      '"', input$corpus, '", ',
      'label="', input$label, '", ',
      'def=list(', input$def, '), ',
      'tf=', ifelse(
          is.null(input$tf), 
          "NULL, ",
          paste('c(', paste(unlist(lapply(input$tf, function(x) paste('"',x,'"', sep=""))), collapse=", "),'), ', sep="")
        ),
      'method="', input$method,'", ',
      'xml="', input$xml, '"',
      ')',
      sep=""
      )
  })
  partitionSummary <- reactive({
    input$goButton
    isolate({
      if (exists("partitionObject") == FALSE){
        retval <- c("partition not yet set up")
      } else if (is.null(partitionObject)){
        retval <- c("setting up the partition failed")
      } else {
        bag <- capture.output(show(partitionObject))
        retval <- paste(bag[2:length(bag)], collapse="\n", sep="\n\n")
        retval <- paste(retval, "\n\n", partitionCall(), "\n\n")
      }
      retval
      })
  })  
  output$what <- renderText({
    paste(
      'Set up of partition: ',
      input$label,
      sep='')
  })
  output$call <- renderText({
    partitionCall()
  })
  output$summary <- renderText({
    partitionSummary()
  })
 output$saveStatus <- renderText({
   retval <- "object not yet saved"
   if (input$saveButton == 0) return()
   retval <- isolate({
     filename <- paste(drillingControls$partitionDir, "/", input$label, ".RData", sep="")
     assign(partitionObject@label, partitionObject)
     save(list=c(partitionObject@label), file=filename)
     paste("object saved:", filename)
     })
    retval
    })
})
