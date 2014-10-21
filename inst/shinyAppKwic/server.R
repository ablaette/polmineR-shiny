library(shiny)
library(polmineR)

partitionObjects <- polmineR.shiny:::.getClassObjects('.GlobalEnv', 'partition')

.generatePhpRscript <- function(i, sAttributes){
  functionName <- paste('runCmd', as.character(i), '()', sep='')
  partitionCmd <- paste(
      'partition(corpus="PLPRTXT", def=list(',
      paste(unlist(lapply(names(sAttributes), function(x) paste(x, '="', sAttributes[x],'"', sep=''))), collapse=", "),
      '), tf=NULL)',
      sep=''
    )
  rscript <- paste(
    "Rscript",
    " -e 'library(polmineR)'",
    " -e 'library(pipeR)'",
    " -e '", partitionCmd, "'",
    sep=''
    )
  wrappedCode <- paste(
    '<script>',
    paste('function ', functionName, ' {', sep=''),
    paste('exec("', rscript, '");', sep=''),
    '}',
    paste('if (isset($_GET["cmd', as.character(i),'"])) {', sep=''),
    paste(functionName,';', sep=''),
    '}',
    '</script>', sep=' '
    )
  return(wrappedCode)
}

shinyServer(function(input, output, session) {
  output$query <- renderText({
    paste(
      'Query: "',
      input$node, '"',
      ' (tf=',
      as.character(tf(partitionObjects[[input$partitionObject]], input$node)[1, paste(input$pAttribute, "Abs", sep="")]),
      ')',
      sep='')
  })
  output$table <- renderDataTable({
    input$goButton
    
    isolate(
      kwicObject <- kwic(
        object=partitionObjects[[input$partitionObject]],
        query=input$node,
        pAttribute=input$pAttribute,
        leftContext=input$leftContext,
        rightContext=input$rightContext,
        collocate=input$collocate,
        meta=unlist(strsplit(input$meta,","))
      )
    )
    tab <- kwicObject@table
    noMetadata <- length(unlist(strsplit(input$meta,",")))
    if (noMetadata > 0){
      metaRow <- unlist(lapply(
        c(1:nrow(tab)),
        function(i){
          sAttributes <- unlist(lapply(tab[i,1:noMetadata], as.character))
          shownText <- paste(sAttributes, collapse="<br/>")
          wrappedText <- paste(
            '<a href="http://localhost/cgi-bin/tmp.cgi" target="_blank">', shownText, .generatePhpRscript(i, sAttributes), '</a>',
            sep=''
          )
          return(wrappedText)
        }
      ))
      if (noMetadata > 1){
        retval <- data.frame(
          metadata=metaRow,
          tab[,(length(unlist(strsplit(input$meta,",")))+1):ncol(tab)]
        )
      } else if (noMetadata == 1){
        retval <- tab
      }
    } else if (noMetadata == 0){
      retval <- data.frame(
        no=c(1:nrow(tab)),
        tab
      )
    }
    retval
  }
  , options=list(
    aoColumnDefs = list(
      list(sClass="metadata", aTargets=c(list(0))),
      list(sClass="alignRight", aTargets=c(list(1))),
      list(sClass="alignCenter", aTargets=c(list(2))),
      list(sWidth="50px", aTargets=c(list(2)))
    )
  )
        )
})


# var shell = new ActiveXObject("WScript.Shell");
# shell.run("cmd /c dir & pause");
# jsFunctionDef <- paste("function showFullText", as.character(i),"(){", sep="")
# jsPart1 <- "
#   var exec = require('child_process').exec, child;
#   child = exec('"
# jsPart2 <- "',
#     function (error, stdout, stderr) {
#         console.log('stdout: ' + stdout);
#         console.log('stderr: ' + stderr);
#         if (error !== null) {
#              console.log('exec error: ' + error);
#         }
#     });
#   child();
#   }
#   "
# 
