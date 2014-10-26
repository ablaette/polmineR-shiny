library(shiny)
library(polmineR)

availableCorpora <- cqi_list_corpora()

shinyUI(pageWithSidebar(
  headerPanel("Partition"),
  sidebarPanel(
    actionButton("goButton", "Go!"),
    br(), br(),
    textInput(inputId="label", label="label / partition name:", value="FOO"),
    selectInput("corpus", "Corpus:", choices=availableCorpora, selected="PLPRTXT",),
    textInput(inputId="def", label="sAttributes:", value='text_year="2012"'),
    radioButtons(inputId="tfLemma", label="tf setup:", choices=list(none="", word="word", lemma="lemma", "word/lemma"="wordLemma"), inline=TRUE), 
    selectInput("method", "Method", choices=list("in", "grep")),
    selectInput("xml", "xml type:", choices=list("flat", "nested")),
     br(),
     actionButton("saveButton", "Save!")
    ),
  
  mainPanel(
    h3(textOutput("query")),
    p(textOutput("saveStatus"))
    # p(textOutput("frequency")),
#    dataTableOutput('table')
    )
))
