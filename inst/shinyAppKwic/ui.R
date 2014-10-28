library(shiny)
library(polmineR)

drillingControls <- getFromNamespace('drillingControls', 'polmineR')
# partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

shinyUI(fluidPage(
  
  tags$head(tags$style(
    c(".table .alignRight {color: black; text-align:right;}
      .table .alignCenter {color: SteelBlue; text-align:center; font-weight:bold;}
      .table .metadata {font-style:italic; text-align:left; background-color: whitesmoke; border-right: 1px solid DarkGray;}
      .table .sorting {color: black; border-bottom: 1px solid DarkGray; border-top: 1px solid DarkGray;}
  
      ")
    )),
  
  headerPanel("kwic"),
  
  sidebarPanel(
    actionButton("partitionButton", "refresh partitions"),
    actionButton("goButton", "Go!"),
    br(),br(),
    selectInput(
      "partitionObject", "Partition:",
      choices=gsub("^(.*)\\.RData$", "\\1", list.files(drillingControls$partitionDir))
#      choices=names(partitionObjects)
      ),
    textInput("node", "Node:", value="Suche"),
    selectInput("pAttribute", "Select p-attribute:", choices=c("word", "pos", "lemma"), selected=drillingControls$pAttribute),
    numericInput("leftContext", "Left context:", value=drillingControls$leftContext),
    numericInput("rightContext", "Right context:", value=drillingControls$rightContext),
    textInput("collocate", "collocate:", value=""),
    textInput("meta", "Metainformation:", value="text_party,text_date"),
    br(),
    actionButton("goButton", "Go!")
    ),
  
  mainPanel(
    h3(textOutput("query")),
    # p(textOutput("frequency")),
    dataTableOutput('table')
    )
))
