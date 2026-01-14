#packages
library(shiny)
library(dplyr)
library(ggplot2)

#load in the data
data3 <- read.csv("titanic.csv")

# create user interface
ui <- fluidPage(
  
    #title
    titlePanel(
      h1("Anna's Shiny App about The Titanic!", align = "center")),
    
    br(),
    br(),
    
    #top part with image and text
    fluidRow(
      column(7,
            img(src = "titanic.jpg", style = "width:100%; height:auto;")),
      column(5,
             style = "font-size:15px;",
             "On this website you can explore data from the famous ship Titanic. The Titanic sank in 1912, after crashing into an iceberg. It is estimated that over 2/3 of the passengers aboard the ship died. This tragedy drew lots of attention and remains a common pop-culture reference to this day.",
             tags$sup(tags$a("1", href = "https://en.wikipedia.org/wiki/RMS_Titanic", target = "_blank")),
             br(),
             br(),
             "This site allows you to explore data from the passengers of the Titanic such as their age, travel class, fare, and whether they survived.
             The graph below invites you to look at the relationship between the age of the passengers and how much they paid for a ticket while playing with additional variables.",
             br(),
             br(),
             "Data for this project was found on a",
             tags$a("GitHub", href = "https://github.com/datasciencedojo/datasets/blob/master/titanic.csv", target = "_blank"),
             "page promoting open data exploration. So feel free to play around and see what you can discover within this data!"
             ) 
    ),
    
    br(),
    br(),
    br(),
    br(),

    #how to display input and output
    sidebarLayout(
      #input
      sidebarPanel(tags$style(".well {background-color:#daf4f0;}"),
                   div(style = "font-size:18px;" , "Select your desired parameter values:"),
                   br(),
                   br(),
                   sliderInput("age", "Age", min = 0, max = 90, value = c(20, 50), post = " years"),
                   br(),
                   selectInput("class", "Travel class", choices = c("1", "2", "3"), multiple = TRUE, selected = c("1", "2", "3")),
                   br(),
                   checkboxInput("survival", "Group based on survival?", value = FALSE)),
      #output
      mainPanel(plotOutput("scatterplot"),
                br(),
                br(),
                div(
                style = "margin-left: auto; margin-right: auto; width: fit-content;",
                tableOutput("descriptives")))
    ),
    
    br(),
    br()
)
    
    

#what is happening in the background
server <- function(input, output){

  
  output$scatterplot <- renderPlot({
    filtered <- data3 %>% 
      filter( Pclass %in% input$class,
              Age >= input$age[1],
              Age <= input$age[2])
    filtered$Survived <- factor(filtered$Survived,
                                levels = c(0, 1),
                                labels = c("Did Not Survive", "Survived"))
    
    
    # Build the aesthetic mapping dynamically
    mapping <- aes(x = Age, y = Fare)
    
    # Only add color mapping if the checkbox is ticked
    ifelse(input$survival == TRUE, mapping <- aes(x = Age, y = Fare, color = Survived), mapping <- mapping) 
    
  ggplot(filtered, mapping) +
    geom_point(shape = 20, size = 2) +
    scale_color_manual(values = c("Did Not Survive" = "black", "Survived" = "#1b98E099")) +
    labs(color = "Survival Status") +
    geom_smooth(method = "lm", se = FALSE) +
    theme_light() +
    labs(title = paste("Fare per age from ages", input$age[1], "to", input$age[2], "in travel class", paste(input$class, collapse = ", "))) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 16)
    )} )
  
  output$descriptives <- renderTable({
    filtered <- data3 %>% 
      filter( Pclass %in% input$class,
              Age >= input$age[1],
              Age <= input$age[2])
    
    filtered %>% group_by(Sex) %>% 
      summarise("Mean survival rate" = mean(Survived, na.rm = TRUE),
                "Mean fare" = mean(Fare, na.rm = TRUE),
                "Mean age" = mean(Age, na.rm = TRUE))
  })
  
  }

#tell shiny to combine the 2 
shinyApp(ui = ui, server = server)


