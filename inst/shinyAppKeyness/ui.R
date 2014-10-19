library(shiny)
library(polmineR)

drillingControls <- getFromNamespace('drillingControls', 'polmineR')
partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyUI(pageWithSidebar(
  headerPanel("Comparing corpora: Keyness"),
  sidebarPanel(
    selectInput("coi", "Corpus of interest:", choices=names(partitionObjects), selected=names(partitionObjects)[1]),
    selectInput("ref", "Partition:", choices=names(partitionObjects), selected=names(partitionObjects)[2]),
    selectInput("pAttribute", "P-Attribute:", choices=c("word", "pos", "lemma"), selected=drillingControls$pAttribute),
    selectInput("included", "Is COI part of RC:", choices=c("TRUE", "FALSE"), selected=FALSE),
    selectInput("minSignificance", "Minimum Significance", choices=c(0, 3.84, 7.33, 10.84), selected=3.84),
    numericInput("minFrequency", "Minimum frequency:", value=drillingControls$minFrequency),
    checkboxInput("applyPosFilter", "Use POS-based filter", value=FALSE),
    textInput("posFilter", "POS-based filter:", value="NN"),
    selectInput("filterType", "Include/exclude:", choices=c("include", "exclude"), selected="include"),
    br(),
    actionButton("goButton", "Go!")
    ),
  
  mainPanel(
    dataTableOutput('table')
    )
))
