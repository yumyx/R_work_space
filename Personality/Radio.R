#load libraries
library(shiny)
library(shinydashboard)
library("googlesheets")
library("DT")
#get your token to access google drive
shiny_token <- gs_auth() 
saveRDS(shiny_token, "shiny_app_token.rds")

#set up data sheet in google drive
#Data <- gs_new("Data") %>% 
#  gs_ws_rename(from = "Sheet1", to = "Data")      
#Data <- Data %>% 
#  gs_edit_cells(ws = "Data", input = cbind("open1", "open2", "consc1", "consc2", "extra1",  "extra2", "agree1", "agree2", "neur1", "neur2", "timestamp"), trim = TRUE)
#Note: for some reason it wont work if first row is blank so I went into the google sheet and put in some values in the first few rows
#sheetkey <- "XXXX" # you can get your key from Data$sheet_key, don't share your sheet key!
#Data <- gs_key(sheetkey)
Data <- gs_title("Data")


#make a normal distribution to graph
set.seed(3000)
xseq<-seq(1,7,.01)
densities <-dnorm(xseq, 4,1)

freqRadio <-  c("Never" = 1,
                "Sometimes" = 2,
                "50%" = 4,
                "Often" = 6,
                "Always" = 7)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Define UI for slider demo app ----
  ui <- fluidPage(
    table <- "responses", 
    # App title ----
    titlePanel("Personality Traits"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
      
      # Sidebar to demonstrate various slider options ----
      sidebarPanel(
        
        radioButtons("extra1", "I see myself as someone who is extraverted, enthusiastic.",
                     freqRadio ),
        
        # br() element to introduce extra vertical spacing ----
        br(),
        
        # Input: Extraversion 1 ----
        #sliderInput("extra1", "I see myself as someone who is extraverted, enthusiastic.",
         #           min = 1, max = 7,
          #          value = 1),
        
        # Input: Agreeableness ----
        sliderInput("agree1", "I see myself as someone who is critical, quarrelsome.",
                    min = 1, max = 7,
                    value = 1),
        
        # Input: Conscientiousness 1 ----
        sliderInput("consc1", "I see myself as someone who is dependable, self-disciplined.",
                    min = 1, max = 7,
                    value = 1),
        
        # Input: Neuroticism 1 ----
        sliderInput("neur1", "I see myself as someone who is anxious, easily upset.",
                    min = 1, max = 7,
                    value = 1),
        
        
        # Input: Openess 1 ----
        sliderInput("open1", "I see myself as someone who is open to new experiences, complex.",
                    min = 1, max = 7,
                    value = 1),
        
        # Input: Extraversion 2 ----
        sliderInput("extra2", "I see myself as someone who is reserved, quiet.",
                    min = 1, max = 7,
                    value = 1),
        
        # Input: Agreeable 2 ----
        sliderInput("agree2", "I see myself as someone who is sympathetic, warm.",
                    min = 1, max = 7,
                    value = 1),
        
        # Input: Conscientiousness 2 ----
        sliderInput("consc2", "I see myself as someone who is disorganized, careless",
                    min = 1, max = 7,
                    value = 1),
        
        # Input: Neuroticissm 2 ----
        sliderInput("neur2", "I see myself as someone who is calm, emotionally stable.",
                    min = 1, max = 7,
                    value = 1),
        
        # Input: Openess 2 ----
        sliderInput("open2", "I see myself as someone who is conventional, uncreative.",
                    min = 1, max = 7,
                    value = 1),
        
        actionButton("submit", "Submit")
        
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(
        
        # Output: Table summarizing the values entered ----
        tableOutput("values"),
        plotOutput("pe"),
        textOutput("he"),
        textOutput("le"),
        plotOutput("pc"),
        textOutput("hc"),
        textOutput("lc"),
        plotOutput("po"),
        textOutput("ho"),
        textOutput("lo"),
        plotOutput("pa"),
        textOutput("ha"),
        textOutput("la"),
        plotOutput("pn"),
        textOutput("hn"),
        textOutput("ln")
      ))
  )
  
  
)





server <- function(input, output, session) {
  
  input.extra1         <- reactive({ as.numeric(input$extra1)})
  # Reactive expression to create data frame of all input values ----
  sliderValues <- reactive({
    data.frame(
      Name = c("Openness",
               "Conscientiousness",
               "Extraversion",
               "Agreeableness",
               "Neuroticism"),
      Value = as.character(c((as.numeric( input$open1) + (8-input$open2))/2,
                             
                             (input$consc1 + (8 - input$consc2))/2,
                             
                             (input.extra1() + (8 - input$extra2))/2,
                             
                             (input$agree2 + (8 - input$agree1))/2,
                             
                             (input$neur1 + (8 - input$neur2))/2)),
      
      stringsAsFactors = FALSE)
    
  })
  
  
  
  # Show the values in an HTML table, only after they press submit
  observeEvent(input$submit, {
    output$values <- renderTable({
      sliderValues()
    })
    input.extra1         <- reactive({ as.numeric(input$extra1)})
    output$pe <- renderPlot({
      plot(xseq, densities, type = "l", lwd = 2, main = "Extraversion: \n How does your score compare to others?",  xlab = "Scores", yaxt='n', ylab = "")
      abline(v=((input.extra1() + (8 - input$extra2))/2), col="blue")
      text(((as.integer(input$extra1) + (8 - input$extra2))/2), 0.1, "Your Score", col = "red") 
    })
    output$he <- renderText({
      'High: Extraverts get their energy from interacting with others, while introverts get their energy from within themselves. Extraversion includes the traits of energetic, talkative, and assertive. They enjoy being with people, participating in social gatherings, and are full of energy.'
    })
    
    output$le <- renderText({
      'Low: A person low in extraversion is less outgoing and is more comfortable working by himself.'
    })
    output$pc <- renderPlot({
      plot(xseq, densities, type = "l", lwd = 2, main = "Conscientiousness: \n How does your score compare to others?",  xlab = "Scores", yaxt='n', ylab = "")
      abline(v=((input$consc1 + (8 - input$consc1))/2), col="blue")
      text(((input$consc1 + (8 - input$consc1))/2), 0.1, "Your Score", col = "red") 
    })
    output$hc <- renderText({
      'High: People that have a high degree of conscientiousness are reliable and prompt. Traits include being organized, methodic, and thorough. A person scoring high in conscientiousness usually has a high level of self-discipline. These individuals prefer to follow a plan, rather than act spontaneously. Their methodic planning and perseverance usually makes them highly successful in their chosen occupation.'
    })
    output$lc <- renderText({
      'Low: People who score low on conscientiousness tend to be laid back, less goal-oriented, and less driven by success.'
    })
    output$po <- renderPlot({
      plot(xseq, densities, type = "l", lwd = 2, main = "Openness to Experience: \n How does your score compare to others?",  xlab = "Scores", yaxt='n', ylab = "")
      abline(v=((input$open1 + (8-input$open2))/2), col="blue")
      text(((input$open1 + (8-input$open2))/2), 0.1, "Your Score", col = "red") 
    })
    output$ho <- renderText({
      'High: People who like to learn new things and enjoy new experiences usually score high in openness. Openness includes traits like being insightful and imaginative and having a wide variety of interests.'
    })
    
    output$lo <- renderText({
      'Low: People who score low on openness tend to be conventional and traditional in their outlook and behavior. They prefer familiar routines to new experiences, and generally have a narrower range of interests.'
    })
    output$pa <- renderPlot({
      plot(xseq, densities, type = "l", lwd = 2, main = "Agreeableness: \n How does your score compare to others?",  xlab = "Scores", yaxt='n', ylab = "")
      abline(v=((input$agree2 + (8 - input$agree1))/2), col="blue")
      text(((input$agree2 + (8 - input$agree1))/2), 0.1, "Your Score", col = "red") 
    })
    output$ha <- renderText({
      'High: A person with a high level of agreeableness in a personality test is usually warm, friendly, and tactful. They generally have an optimistic view of human nature and get along well with others.'
    })
    
    output$la <- renderText({
      'Low: People with low agreeableness may be more distant and may put their own interests above those of others. They tend to be less cooperative. '
    })
    output$pn <- renderPlot({
      plot(xseq, densities, type = "l", lwd = 2, main = "Neuroticism: \n How does your score compare to others?",  xlab = "Scores", yaxt='n', ylab = "")
      abline(v=((input$neur1 + (8 - input$neur2))/2), col="blue")
      text(( (input$neur1 + (8 - input$neur2))/2), 0.1, "Your Score", col = "red") 
    })
    output$hn <- renderText({
      'High: This dimension relates to one’s emotional stability and degree of negative emotions. People that score high on neuroticism often experience emotional instability and negative emotions. Traits include being moody and tense. A person who is high in neuroticism has a tendency to easily experience negative emotions.'
    })
    output$ln <- renderText({
      "Low: On the other end of the section, people who score low in neuroticism experience more emotional stability. Emotional stability refers to a person's ability to remain stable and balanced. They tend to experience negative emotions less easily and handle stress well."
    })
  })
  
  
  
  
  
  #store the results
  Results <- reactive(c(
    input$open1, input$open2, input$consc1, input$consc2, input$extra1, input$extra2, input$agree1, input$agree2, input$neur1, input$neur2, Sys.time()
  ))
  
  
  #This will add the new row at the bottom of the dataset in Google Sheets.
  observeEvent(input$submit, {
   #print( Results())
  
    
    
    Data  <- Data  %>%                                                                      
      gs_add_row(ws = "Data", input = Results())                                                               
  }
  )
  
}
shinyApp(ui = ui, server = server)
  