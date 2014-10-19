library(shiny)
library(polmineR)

drillingControls <- getFromNamespace('drillingControls', 'polmineR')
partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyUI(pageWithSidebar(
  
  headerPanel("PolMine-Concordancer"),
  
  sidebarPanel(
    selectInput("partitionObject", "Partition:", choices=names(partitionObjects)),
    textInput("node", "Node:", value="Suche"),
    selectInput("pAttribute", "Select p-attribute:", choices=c("word", "pos", "lemma"), selected=drillingControls$pAttribute),
    numericInput("leftContext", "Left context:", value=drillingControls$leftContext),
    numericInput("rightContext", "Right context:", value=drillingControls$rightContext),
    textInput("collocate", "collocate:", value=""),
    textInput("meta", "Metainformation:", value="text_party"),
    br(),
    actionButton("goButton", "Go!")
    ),
  
  mainPanel(
    h3(textOutput("query")),
    # p(textOutput("frequency")),
    dataTableOutput('table')
    )
))
