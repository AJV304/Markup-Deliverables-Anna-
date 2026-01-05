#pacakge
library(shiny)

# create user interface
ui <- fluidPage(
    #title
    titlePanel("Anna's Shiny App about The Titanic!"),

    #how to display input and output
    sidebarLayout(
      #input
      sidebarPanel(sliderInput("age", "Age",
                               min = 0, max = 90, value = c(20, 50), post = " years"),
                   selectInput("class", "Travel class", choices = c("1", "2", "3"), multiple = TRUE, selected = c("1", "2", "3")),
                   checkboxInput("survival", "Group based on survival?", value = FALSE)),
      #output
      mainPanel("On this website you can explore data from the famously crashed Titanic. The graph below allows you to explore the relationship between the age of the passengers and how much they paid for a ticket while playing with additional variables.", 
                br(), br(), 
                plotOutput("scatterplot"),
                br(),
                br(),
                "[table placeholder]", tableOutput("descriptives"))
    )
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
      summarise("mean survival rate" = mean(Survived, na.rm = TRUE),
                "mean fare" = mean(Fare, na.rm = TRUE),
                "mean age" = mean(Age, na.rm = TRUE))
  })
  
  }

#tell shiny to combine the 2 
shinyApp(ui = ui, server = server)


