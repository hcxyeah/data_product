library(shiny)
library(ggplot2)
library(rCharts)
library(lubridate)
library(data.table)
library(dplyr)
library(markdown)
library(reshape2)
library(maps)
library(mapproj)
library(ggvis)
library(googleVis)
#suppressPackageStartupMessages(library(googleVis))

source("data_processing.R", local = TRUE)

data <- read.csv("data.csv")
data$Order.Date <- as.Date(data$Order.Date, "%m/%d/%y")
data$year <- year(data$Order.Date)
data$month <- month(data$Order.Date)
#data$month2 <- ifelse(data$month < 10, paste("0",data$month, sep = ""), as.character(data$month))
data$date <- as.numeric(paste(as.character(data$year), data$month, sep = "."))
categories <- as.character(sort(unique(data$Category)))

shinyServer(function(input, output, session) {
  
  values <- reactiveValues() 
  values$categories <- categories
  
  output$categoriesControls <- renderUI({
    checkboxGroupInput('categories', 'Category', categories, selected = values$categories)
  })
  
  observe({
    if(input$clear_all == 0) return()
    values$categories <- c()
  })

  observe({
    if(input$select_all == 0) return()
    values$categories <- categories
  })
  
  ## prepare dataset
  dt_growth <- reactive({
    for_growth_plot(data, input$range[1], input$range[2], input$categories)
  })
  
  dt_bar <- reactive({
    for_bar_plot(data, input$range[1], input$range[2], input$categories)
  })
  
  # dt_map <- reactive({
  #   for_map(data, input$range[1], input$range[2], input$categories)
  # })
  
  dt_map <- reactive({
    for_map(data)
  })
  
  ## prepare dataset for downloads
  dataTable <- reactive({
    dt_growth()
  })
  
  
  ##Render Plots
  
  output$growthplot1 <- renderChart2({
    print(plot_profit_growth(dt_growth()))
  })
  
  output$growthplot2 <- renderChart2({
    print(plot_sales_growth(dt_growth()))
  })
  
  output$barplot1 <- renderChart2({
    print(plot_bar_plot1(dt_bar()))
  })
  
  output$barplot2 <- renderChart2({
    print(plot_bar_plot2(dt_bar()))
  })
  
  output$mapplot <- renderGvis({
    plot_map(dt_map())
  })
  
  ## Render data table 
  output$table <- renderDataTable(
    {dataTable()}, options = list(bFilter = FALSE, iDisplayLength = 50))
  
  ## Create download handler
  output$downloadData <- downloadHandler(
    filename = 'data.csv',
    content = function(file) {
      write.csv(dataTable(), file, row.names = FALSE)
    }
  )
  
  prepare_downloads <- function(dt) {
    dt %>% mutate(Year = strsplit(as.character(dt$date), "[.]")[1],
                  Month = strsplit(as.character(dt$date), "[.]"[2])
                  ) %>% select(Market, Year, Month, profit, sales) 
  }
})
  