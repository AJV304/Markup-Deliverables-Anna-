#pacakge
library(shiny)

# create user interface
ui <- fluidPage(
    #title
    titlePanel("Anna's Shiny App"),

    #how to display input and output
    sidebarLayout(
      #input
      sidebarPanel(sliderInput("age", "Age",
                               min = 0, max = 90, value = c(20, 50), post = " years"),
                   selectInput("class", "Travel class", choices = c("1", "2", "3"), multiple = TRUE, selected = c("1", "2", "3")),
                   checkboxInput("survival", "Show survival?", value = FALSE)),
      #output
      mainPanel("[plot placeholder]", plotOutput("scatterplot"),
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
    
    # Build the aesthetic mapping dynamically
    mapping <- aes(x = Age, y = Fare)
    
    # Only add color mapping if the checkbox is ticked
    ifelse(input$survival == TRUE, mapping <- aes(x = Age, y = Fare, color = Survived), mapping <- mapping) 
    
  ggplot(filtered, mapping) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE) +
    theme_minimal() +
    labs(title = paste("Fare per Age from ages", input$age[1], "to", input$age[2], "in travel class", paste(input$class, collapse = ", ")))} 
  
  )}

#tell shiny to combine the 2 
shinyApp(ui = ui, server = server)


