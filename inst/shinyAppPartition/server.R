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
        tf=NULL,
#        meta=unlist(lapply(lapply(strsplit(input$def, ",\\s"), function(x)strsplit(x,"="))[[1]], function(y)y[1])),
        meta=unlist(strsplit(input$meta,",\\s*")),
        encoding="latin1",
        method=input$method,
        xml=input$xml,
        verbose=TRUE
      )
      if (input$label!="") assign(x=input$label, value=partitionObject, envir=.GlobalEnv)
      setupStatus <<- 1
    })
  })
  partitionSummary <- reactive({
    input$goButton
#     isolate({data.frame(
#       tfTotal=partitionObject@size,
#       noChunks=nrow(partitionObject@cpos),
#       noSAttributes=length(partitionObject@sAttributes)
#       )
#     })
    isolate({
      bag <- capture.output(show(partitionObject))
      paste(bag[2:length(bag)], collapse="\n", sep="\n\n")
      })
  })
  partitionMetadata <- reactive({
    input$goButton
    isolate({
      partitionObject@metadata$table
      })
  })
  
  
#   partitionSummary <- function(partitionObject){
#     data.frame(
#       tfTotal=partitionObject@size,
#       noChunks=nrow(partitionObject@cpos),
#       noSAttributes=length(partitionObject@sAttributes)
#     )
#   }
#   
  
#   checkStatus <- reactive({
#     if (setupStatus == 1) partitionSummar <<- partitionSummary()
#   })
  
  output$what <- renderText({
    paste(
      'Set up of partition: ',
      input$label,
      sep='')
  })
  output$summary <- renderText({
    partitionSummary()
  })
  output$metadata <- renderDataTable({
    partitionMetadata()
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
#     retval <- reactive({
#       eventFilter(
#         input$saveButton, 
#         {
#           filename <- paste(drillingControls$partitionDir, "/", input$label, ".RData", sep="")
#           assign(p@label, p)
#           save(list=c(p@label), file=filename)
#           paste("object saved", p@label, p@size, filename)
#         }
#     )
    retval
    })
#  })
})
