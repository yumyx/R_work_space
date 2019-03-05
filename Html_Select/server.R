library(shiny)
library(jsonlite)
library(datasets)
library(shinydashboard)
library("googlesheets")
library("DT")



shiny_token <- gs_auth() 
saveRDS(shiny_token, "shiny_app_token.rds")

dataname <- "SelectList-ui"
glist <- gs_ls(dataname)
if(is.null( glist)){
  #set up data sheet in google drive
  Data <- gs_upload(paste(dataname,".csv", sep = "", collapse = ""))
 
}else{
  Data <- gs_title(dataname)
}



result_x <- Data %>%
  gs_read(ws = dataname)
print (result_x)


wl <- gs_ws_ls(Data)
wslen <- length(wl)



set.seed(3000)
xseq<-seq(1,7,.01)
densities <-dnorm(xseq, 4,1)

shinyServer(function(input, output,session) {
  
  randerOutPut <- function(js)
  {
    
   # print(js$extra1)
    #print(js$extra2)
    
    input.extra1         <- js$extra1
    output$pe <- renderPlot({
      plot(xseq, densities, type = "l", lwd = 2, main = "Extraversion: \n How does your score compare to others?",  xlab = "Scores", yaxt='n', ylab = "")
      abline(v=((input.extra1 + (8 - as.numeric( js$extra2)))/2), col="blue")
      text(((as.integer(js$extra1) + (8 - as.numeric( js$extra2)))/2), 0.1, "Your Score", col = "red") 
    })
    
    
  }
  
  
  observeEvent(input$submit, {
    #print( Results())
    
    print(input$submit)
    
    
    js <- fromJSON(input$submit)
    print (js)
    print (wslen)
    if(wslen<=1)
    {
      Data <<- gs_ws_new(Data,ws_title = "Data",input =js , trim =TRUE)
  
      wslen <<- wslen+1
      #print (wslen)
    }else
    {
      print("gs_add_row")
      gs_add_row(Data,ws = "Data", input = js)
      
    }
    
    randerOutPut(js)
  }
  )

 jstr <-toJSON(result_x,pretty=TRUE)
  session$sendCustomMessage("json",jstr )
})



