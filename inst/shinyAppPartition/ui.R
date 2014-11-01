library(shiny)
library(polmineR)

availableCorpora <- cqi_list_corpora()

shinyUI(pageWithSidebar(
  headerPanel("partition"),
  sidebarPanel(
    actionButton("goButton", "Go!"), actionButton("saveButton", "Save!"),
    br(), br(),
    textInput(inputId="label", label="label / partition name:", value="FOO"),
    selectInput("corpus", "Corpus:", choices=availableCorpora, selected="PLPRTXT",),
    textInput(inputId="def", label="sAttributes:", value='text_year="2012"'),
#    radioButtons(inputId="tfLemma", label="tf setup:", choices=list(none="", word="word", lemma="lemma", "word/lemma"="wordLemma"), inline=TRUE), 
    selectInput(inputId="tf", label="tf setup:", multiple=TRUE, choices=list(none="", word="word", lemma="lemma")), 
    radioButtons("method", "Method", choices=list("in", "grep"), inline=TRUE),
    radioButtons("xml", "xml type:", choices=list("flat", "nested"), inline=TRUE),
    radioButtons("mc", "use multicore:", choices=list("TRUE"=TRUE, "FALSE"=FALSE), inline=TRUE)
    ),
  
  mainPanel(
    h3(textOutput("what")),
    verbatimTextOutput("call"),
    p(textOutput("saveStatus")),
    verbatimTextOutput("summary")
    )
))
