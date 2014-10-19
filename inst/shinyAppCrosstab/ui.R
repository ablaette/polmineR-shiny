library(shiny)
library(polmineR)

drillingControls <- getFromNamespace('drillingControls', 'polmineR')
partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyUI(pageWithSidebar(
  
  headerPanel("dispersion analysis"),
  
  sidebarPanel(
    selectInput("partitionObject", "Partition:", choices=names(partitionObjects)),
    textInput("query", "Query:", value="Suche"),
    selectInput("pAttribute", "Select p-attribute:", choices=c("word", "pos", "lemma"), selected=drillingControls$pAttribute),
    selectInput("rows", "Rows:", choices=c("text_year")),
    selectInput("cols", "Colums:", choices=c("text_party")),
    selectInput("what", "Table to show:", choices=c("rel", "abs", "partitions"), selecte="rel"),
    sliderInput("rex", "Bubble expansion:", min=0, max=2, value=1, round=FALSE, step=0.1),
    br(),
    submitButton("Update")
    ),
  
  mainPanel(
    h3(textOutput("what")),
    dataTableOutput("tab"),
    plotOutput('plot')
    )
))
