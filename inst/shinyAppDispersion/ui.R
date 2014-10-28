library(shiny)
library(polmineR)

# drillingControls <- getFromNamespace('drillingControls', 'polmineR')
# partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyUI(pageWithSidebar(
  
  headerPanel("dispersion"),
  
  sidebarPanel(
    selectInput(
      "partitionObject", "Partition:",
      choices=gsub("^(.*)\\.RData$", "\\1", list.files(drillingControls$partitionDir))
    ),
    textInput("query", "Query:", value="Integration"),
    radioButtons("absRel", "abs/rel frequencies", choices=c(abs="abs", rel="rel"), inline=TRUE),
    selectInput("pAttribute", "Select p-attribute:", choices=c("word", "pos", "lemma"), selected=drillingControls$pAttribute),
    textInput("dim1", "S-Attribute1:", value=c("text_year")),
    textInput("dim2", "S-Attribute2:", value=c("")),
    sliderInput("rex", "Bubble expansion:", min=0, max=2, value=1, round=FALSE, step=0.1),
    actionButton("goButton", "Go!")
    ),
  
  mainPanel(
    dataTableOutput("tab"),
    plotOutput('plot')
    )
  )
)
