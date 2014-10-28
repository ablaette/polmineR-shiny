library(shiny)
library(polmineR)

drillingControls <- getFromNamespace('drillingControls', 'polmineR')
# partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyUI(pageWithSidebar(
  
  headerPanel("context"),
  
  sidebarPanel(
    actionButton("partitionButton", "refresh partitions"),
    actionButton("goButton", "Go!"),
    br(), br(),
    selectInput(
      "partitionObject", "Partition:",
      gsub("^(.*)\\.RData$", "\\1", list.files(drillingControls$partitionDir))
      ),
    textInput("node", "Node:", value="Suche"),
    selectInput("pAttribute", "Select p-attribute:", choices=c("word", "pos", "lemma"), selected=drillingControls$pAttribute),
    numericInput("leftContext", "Left context:", value=drillingControls$leftContext),
    numericInput("rightContext", "Right context:", value=drillingControls$rightContext),
    numericInput("minSignificance", "Minimum significance:", value=drillingControls$minSignificance),
    textInput("posFilter", "POS-based filter:", value=paste(drillingControls$posFilter, collapse=' ')),
    br(),
    actionButton("goButton", "Go!")
    ),
  
  mainPanel(
    h3(textOutput("query")),
    # p(textOutput("frequency")),
    dataTableOutput('table')
    )
))
