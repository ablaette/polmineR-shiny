library(shiny)
library(polmineR)

partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyServer(function(input, output, session) {
  observe({
    foo <- input$partitionButton
    availablePartitions <- gsub("^(.*)\\.RData$", "\\1", list.files(drillingControls$partitionDir))
    updateSelectInput(session, "partitionObject", choices=availablePartitions)
  })
  output$query <- renderText({
    paste(
      'Query: "',
      input$node, '"',
      sep='')
     })
  output$table <- renderDataTable({
    input$goButton
    isolate(
      ctext <- context(
        object=get(load(paste(drillingControls$partitionDir, "/", input$partitionObject, ".RData", sep=""))),
        query=input$node,
        pAttribute=input$pAttribute,
        leftContext=input$leftContext,
        rightContext=input$rightContext,
        minSignificance=input$minSignificance,
        posFilter=unlist(strsplit(input$posFilter, ' ')),
        verbose=FALSE
        )
      )
    ctext@stat[,"expCoi"] <- round(ctext@stat[,"expCoi"], 2)
    ctext@stat[,"expCorpus"] <- round(ctext@stat[,"expCoi"], 2)
    ctext@stat[,"ll"] <- round(ctext@stat[,"ll"], 2)    
    cbind(token=rownames(ctext@stat), ctext@stat)
    })
})
