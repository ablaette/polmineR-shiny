library(shiny)
library(polmineR)

drillingControls <- getFromNamespace('drillingControls', 'polmineR')
partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyUI(pageWithSidebar(
  
  headerPanel("dispersion"),
  
  sidebarPanel(
    selectInput("partitionObject", "Partition:", choices=names(partitionObjects)),
    textInput("query", "Query:", value="Suche"),
    selectInput("pAttribute", "Select p-attribute:", choices=c("word", "pos", "lemma"), selected=drillingControls$pAttribute),
    selectInput("dim", "S-Attribute:", choices=c("")),
    actionButton("goButton", "Go!")
    ),
  
  mainPanel(
    dataTableOutput("tab"),
    plotOutput('plot')
    )
))
