library(shiny)
library(polmineR)

partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyServer(function(input, output, session) {
  output$query <- renderText({
    paste(
      'Query: "',
      input$node, '"',
      ' (tf=',
      as.character(tf(partitionObjects[[input$partitionObject]], input$node)[1, paste(input$pAttribute, "Abs", sep="")]),
      ')',
      sep='')
     })
  output$table <- renderDataTable({
    input$goButton
    isolate(
      kwicObject <- kwic(
        object=partitionObjects[[input$partitionObject]],
        query=input$node,
        pAttribute=input$pAttribute,
        leftContext=input$leftContext,
        rightContext=input$rightContext,
        collocate=input$collocate,
        meta=unlist(strsplit(input$meta," "))
        )
      )
    kwicObject@table
    })
})
