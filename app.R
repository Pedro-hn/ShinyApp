## app.R ##
library(shinydashboard)
library(shiny)
library(ggplot2)
library(tidyverse)

cols <- c("gear", "carb", "am", "vs", "cyl")
data <- data %>% 
  mutate_each_(funs(factor(.)),cols)
str(data)

###################################################################
ui <- dashboardPage(
  dashboardHeader(title = "Analítico 2023"),
  dashboardSidebar(
    title = "Filtros",
    ###############################################################
    sliderInput(
      inputId = "slider", label = "Number of observations:", min =  1, max = 100, value = 50
    ),
    ###############################################################
    selectInput(
      inputId = "x", label = "Eixo X", selected = "cyl",
      choices = colnames(data %>% select_if(~class(.) == 'numeric')
      )
    ),
    ###############################################################
    selectInput(
      inputId = "y", label = "Eixo Y", selected = "cyl",
      choices = colnames(data %>% select_if(~class(.) == 'numeric')
      )
    ),
    ###############################################################
    selectInput(
      inputId = "histograma", label = "Histograma", selected = "gear",
      choices = colnames(data %>% select_if(~class(.) == 'numeric')
      )
    ),
    ###############################################################
    selectInput(
      inputId = "barra", label = "Barra", selected = "gear",
      choices = colnames(data %>% select_if(~class(.) == 'factor')
      )
    )
  ),
  dashboardBody(
    ###############################################################
    # First FluidRow
    fluidRow(
      # Value Box 1
      valueBoxOutput(outputId = "box_1", width = 3),
      
      # Value Box 2
      valueBoxOutput(outputId = "box_2", width = 3),
      
      # Value Box 3
      valueBoxOutput(outputId = "box_3", width = 3),
      
      # Value Box 4
      valueBoxOutput(outputId = "box_4", width = 3),
      
      #############################################################
      # Second FluidRow
      fluidRow(
        # Graph one
        box(plotOutput(outputId = "plot1", height = 250)),
        
        # Graph two
        box(plotOutput(outputId = "plot2", height = 250)),
        
        ###########################################################
        # Third FluidRow
        fluidRow(
          # Graph three
          box(plotOutput(outputId = "plot3", height = 250)),
          
          # Graph four
          box(plotOutput(outputId = "plot4", height = 250))
        )
        
        
      )
    )
  )
)

###################################################################
server <- function(input, output) {
  
  #################################################################
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
    valueBox(20, subtitle = "Faturamento por Campa", color = "orange"
    )
  })
  
  ###############################################################
  # Graph one 
  # The data we wish to plot
  
  
  output$plot1 <- renderPlot({
    
    XX <- input$x
    YY <- input$y
    
    ggplot(data, aes_string(x = XX, y = YY)) + 
      geom_point()
    
  })
  
  
  # Graph two
  output$plot2 <- renderPlot({
    
    XX_barra <- input$barra
    
    ggplot(data, aes_string(x = XX_barra)) + 
      geom_bar()
    
  })
  
  # Graph three 
  output$plot3 <- renderPlot({
    
    XX <- input$x
    YY <- input$y
    
    ggplot(data, aes_string(x = XX, y = YY)) + 
      geom_boxplot()
    
  })
  
  # graph four
  output$plot4 <- renderPlot({
    
    XX_histograma <- input$histograma
    
    
    ggplot(data, aes_string(x = XX_histograma)) + 
      geom_histogram()
    
  })
}

shinyApp(ui, server)