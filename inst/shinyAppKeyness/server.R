library(shiny)
foo <- capture.output(library(polmineR))

drillingControls <- getFromNamespace('drillingControls', 'polmineR')
# partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyServer(function(input, output, session) {
  observe({
    foo <- input$partitionButton
    availablePartitions <- gsub("^(.*)\\.RData$", "\\1", list.files(drillingControls$partitionDir))
    updateSelectInput(session, "coi", choices=availablePartitions)
    updateSelectInput(session, "ref", choices=availablePartitions)
  })
  output$c1 <- renderText({input@coi})
  output$c2 <- renderText({input@ref})
  output$table <- renderDataTable({
    input$goButton
    isolate({
      result <- keyness(
        x=get(load(paste(drillingControls$partitionDir, "/", input$coi, ".RData", sep=""))),
        y=get(load(paste(drillingControls$partitionDir, "/", input$ref, ".RData", sep=""))),
        pAttribute=input$pAttribute,
        minFrequency=input$minFrequency,
        included=as.logical(input$included),
        verbose=FALSE,
        digits=2
        )
      if (input$applyPosFilter == FALSE){
        result <- trim(
          result,
          minSignificance=input$minSignificance,
          minFrequency=input$minFrequency,
          filterType=input$filterType,
          verbose=FALSE
        )
      } else {
        result <- trim(
          result,
          minSignificance=input$minSignificance,
          minFrequency=input$minFrequency,
          verbose=FALSE
        )      
        result <- enrich(result, addPos=TRUE)
        result <- trim(
          result,
          posFilter=unlist(strsplit(input$posFilter, "\\s")),
          filterType=input$filterType
        )      
      }
      result
    })
    cbind(token=rownames(result@stat), result@stat)
    })
})
