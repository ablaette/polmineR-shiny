library(shiny)
library(polmineR)

partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyServer(function(input, output, session) {
  observe({
    p <- partitionObjects[[input$partitionObject]]
    updateSelectInput(session, "rows", choices=cqi_attributes(p@corpus, 's'))
    updateSelectInput(session, "cols", choices=cqi_attributes(p@corpus, 's'))
  })
  
  output$what <- renderText({paste(input$query)})
  data <- reactive({
    aha <- dispersion(
      object=partitionObjects[[input$partitionObject]],
      query=input$query,
      dim=c(input$rows, input$cols),
      pAttribute=input$pAttribute
      )
    aha
  })
  output$tab <- renderDataTable({
    tab <- slot(data(), input$what)
    if (input$what == "rel") {
      tab <- round(tab*100000,2)
    }
    tab <- cbind(rownames(tab), tab)
    tab
    })
   output$plot <- renderPlot({
     bubblegraph(slot(data(), input$what), rex=input$rex)
   })  
})
