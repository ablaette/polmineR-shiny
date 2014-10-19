library(shiny)
library(polmineR)

partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyServer(function(input, output) {
  output$c1 <- renderText({input@coi})
  output$c2 <- renderText({input@ref})
  output$table <- renderDataTable({
    input$goButton
    isolate({
      result <- keyness(
        x=partitionObjects[[input$coi]],
        y=partitionObjects[[input$ref]],
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
          filterType=input$filterType
        )
      } else {
        result <- trim(
          result,
          minSignificance=input$minSignificance,
          minFrequency=input$minFrequency
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
