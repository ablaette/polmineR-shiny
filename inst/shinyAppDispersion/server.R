library(shiny)
library(polmineR)

partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyServer(function(input, output, session) {
  observe({
    foo <- input$partitionButton
    availablePartitions <- gsub("^(.*)\\.RData$", "\\1", list.files(drillingControls$partitionDir))
    updateSelectInput(session, "partitionObject", choices=availablePartitions)
  })
  dim2 <- reactive({
    if (input$dim2 == "") {
      dim2 <- NULL
    } else {
      dim2 <- input$dim2
    }
    dim2
  })
  queries <- reactive({
    queries <- unlist(strsplit(input$query, ',\\s*'))
    queries <- vapply(queries, function(x) gsub('^\\s+', '', x), FUN.VALUE="character", USE.NAMES=FALSE)
    vapply(queries, function(x) gsub('\\s+$', '', x), FUN.VALUE="character", USE.NAMES=FALSE)
  })
  data <- reactive({
    aha <- dispersion(
      object=get(load(paste(drillingControls$partitionDir, "/", input$partitionObject, ".RData", sep=""))),
      query=queries(),
      dim=c(input$dim1, dim2()),
      pAttribute=input$pAttribute
      )
    aha
  })
  output$tab <- renderDataTable({
    if (length(queries())==1 && length(c(input$dim1, dim2()))==1) {
      tab <- data()
      tab[,"rel"] <- round(tab[,"rel"]*100000, 2)
    } else if (length(queries())>1 && length(c(input$dim1, dim2()))==1) {
      tab <- data()[[input$absRel]]
      if (input$absRel == "rel") tab <- round(tab*100000, 2)  
    } else if (length(queries())==1 && length(c(input$dim1, dim2()))==2) {
      tab <- slot(data(), input$absRel)
      if (input$absRel == "rel") tab <- round(tab*100000, 2)  
    }
    tab <- cbind(tmp=rownames(tab), tab)
    colnames(tab)[1] <- input$dim1    
    tab
    })
   output$plot <- renderPlot({
    if (length(queries())==1 && length(c(input$dim1, dim2()))==1) {
      par(mfrow=c(1,2), las=2, mar=c(10,2.5,3,0.5))
      barplot((data()$rel*100000), main="relative frequencies", names.arg=rownames(data()))
      barplot(data()$abs, main="absolute frequencies", names.arg=rownames(data()))
    } else if (length(queries())>1 && length(c(input$dim1, dim2()))==1) {
      if (input$absRel=="rel") {
        barplot(data()$rel, main="relative frequencies")
      } else if (input$absRel=="abs") {
        barplot(data()$abs, main="absolute frequencies")
      }
    } else if (length(queries())==1 && length(c(input$dim1, dim2()))==2) {
      bubblegraph(slot(data(), input$absRel), rex=input$rex)
    }

    })  
})
#