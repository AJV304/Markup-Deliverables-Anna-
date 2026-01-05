#pacakge
library(shiny)

# create user interface
ui <- fluidPage(
    #title
    titlePanel("Anna's Shiny App"),

    #how to display input and output
    sidebarLayout(
      sidebarPanel("[inputs]"),
      mainPanel("[outputs]")
    )
    
)

#what is happening in the background
server <- function(input, output) {}

#tell shiny to combine the 2 
shinyApp(ui = ui, server = server)
