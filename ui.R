library(shiny)
library(rCharts)
library(googleVis)

shinyUI(
  navbarPage("Profit and Sales",
             tabPanel("Plot",
                      sidebarPanel(
                        sliderInput("range", "Range:", min = 2011, max = 2014,
                                    value = c(2011,2014), format = "####"),
                        uiOutput("categoriesControls"),
                        actionButton(inputId = "clear_all", label = "Clear all",
                                     icon = icon("check-square")),
                        actionButton(inputId = "select_all", label = "Select all",
                                     icon = icon("check-square-o"))
                      ),
                      
                      mainPanel(
                        tabsetPanel(
                          tabPanel(p(icon("map"), "Map"),
                                   h4('Profit on each country', align = "center"),
                                   htmlOutput("mapplot")),
                          tabPanel(p(icon("line-chart"), "Growth"),
                                   h4('Profit growth', align = "center"),
                                   showOutput("growthplot1", lib = "nvd3"),
                                   h4('Sales growth', align = "center"),
                                   showOutput("growthplot2", lib = "nvd3")),
                          tabPanel(p(icon("bar-chart"), "barchart"),
                                   h4('Profit by market', align = "center"),
                                   showOutput("barplot1", lib = "nvd3"),
                                   h4('Sales by market', aligh = "center"),
                                   showOutput("barplot2", lib = "nvd3")),
                          tabPanel(p(icon("table"), "Data"),
                                   dataTableOutput(outputId = "table"),
                                   downloadButton('downloadData', 'Download'))
                        )
                      )
                    ),
             tabPanel("About", 
                      mainPanel(
                        includeMarkdown("Readme.md")
                      )
                  )
             )
        )