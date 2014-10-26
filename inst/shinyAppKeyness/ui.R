library(shiny)
foo <- capture.output(library(polmineR))

drillingControls <- getFromNamespace('drillingControls', 'polmineR')
# partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyUI(pageWithSidebar(
  headerPanel("Keyness"),
  sidebarPanel(
    actionButton("partitionButton", "refresh partitions"),
    actionButton("goButton", "Go!"),
    br(),br(),
    selectInput(
      "coi", "Corpus of interest:",
      choices=gsub("^(.*)\\.RData$", "\\1", list.files(drillingControls$partitionDir)),
      selected=gsub("^(.*)\\.RData$", "\\1", list.files(drillingControls$partitionDir))[1]
      ),
    selectInput(
      "ref", "Partition:",
      choices=gsub("^(.*)\\.RData$", "\\1", list.files(drillingControls$partitionDir)),
      selected=gsub("^(.*)\\.RData$", "\\1", list.files(drillingControls$partitionDir))[2]
      ),
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
