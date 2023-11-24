library(shiny)
library(shinydashboard)
library(tidyverse)

# UI ----
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      width = 2,
      dateRangeInput(inputId   = "date_range",
                     label     = h4("Date Range"),
                     start     = as.Date("2018-01-01"),
                     end       = as.Date("2020-12-31"),
                     min       = as.Date("2018-01-01"),
                     max       = as.Date("2020-12-31"),
                     startview = "year"
      ),
      selectizeInput(inputId = "entrada 1",
                     label = h4("Entrada 1"),
                     choices = colnames(mtcars)),
      # create extra vertical space in sidebar (for illustration only)
      HTML(rep('<br>', 30))
    ),
    
    mainPanel(
      # 1st fluid row for value boxes
      fluidRow(
        # Value Box 1
        valueBoxOutput(outputId = "box_1", width = 3),
        
        # Value Box 2
        valueBoxOutput(outputId = "box_2", width = 3),
        
        # Value Box 3
        valueBoxOutput(outputId = "box_3", width = 3),
        
        # Value Box 4
        valueBoxOutput(outputId = "box_4", width = 3),
        
        # Value Box 5
        valueBoxOutput(outputId = "box_5", width = 3)
      ),
      br(),
      hr(),
      
      # 2nd fluid row for map and plots
      fluidRow(
        
        # 1st column for map
        column(6,
               # map plot
               plotOutput('sales_map')
        ),
        
        # 2nd column for plots
        column(6, 
               # fluidRow for sales trend
               fluidRow(
                 # trend plot
                 plotOutput('trend_plot', height = '175px')
               ),
               # fluidRow for bar plot
               fluidRow(
                 # bar plot
                 plotOutput('bar_plot', height = '175px')
               )
        )
      )
    )
  )
)


# Server ----
server <- function(input, output) {
  
  # Box 1
  output$box_1 <- shinydashboard::renderValueBox({
    valueBox(5, subtitle = "Faturamento Anual", color = "green"
    )
  })
  
  # Box 2
  output$box_2 <- renderValueBox({
    valueBox(10, subtitle = "Faturamento Mensal", color = "blue"
    )
  })
  
  # Box 3
  output$box_3 <- renderValueBox({
    valueBox(15, subtitle = "Ganho por Alavancagem", color = "purple"
    )
  })
  
  # Box 4
  output$box_4 <- renderValueBox({
    valueBox(20, subtitle = "Faturamento por Campanha", color = "orange"
    )
  })
  
  # Box 5
  output$box_5 <- renderValueBox({
    valueBox(25, subtitle = "Faturamento Listado", color = "red"
    )
  })
  
  
  # sales map
  output$sales_map = renderPlot({
    ggplot(mtcars, aes(x = disp, y = mpg)) + geom_point()
  })
  
  
  
  # sales trend plot
  output$trend_plot = renderPlot({
    ggplot(mtcars, aes(x = disp, y = mpg, group = 'cyl')) + geom_line()
  })
  
  
  
  # bar plot
  output$bar_plot = renderPlot({
    ggplot(count(mtcars, cyl), aes(x = cyl, y = n)) + geom_bar(stat = 'identity')
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
