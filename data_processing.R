library(lubridate)
library(dplyr)
library(googleVis)

for_growth_plot <- function(dt, start_date, end_date, categories) {
  dt %>% 
    filter(year >= start_date, year <= end_date,
           Category %in% categories) %>%
    group_by(Market, date) %>%
    summarise(profit = sum(Profit), sales = sum(Sales))
}

plot_profit_growth <- function(dt){
  plot <- nPlot(
    profit ~ date,
    data = dt,
    group = "Market",
    type = "lineChart"
  )
  plot$yAxis(axisLabel = "Profit")
  plot$xAxis(axisLabel = "Date")
  plot$chart(tooltipContent = "#! function(key, x, y){
        return '<h3>' + key + '</h3>' + 
        '<p>' + y + ' in ' + x + '</p>'
        } !#")
  plot
}
  
plot_sales_growth <- function(dt){
  
  plot <- nPlot(
    sales ~ date,
    data = dt,
    group = "Market",
    type = "lineChart"
  )
  plot$yAxis(axisLabel = "Sales")
  plot$xAxis(axisLabel = "Date")
  plot$chart(tooltipContent = "#! function(key, x, y){
             return '<h3>' + key + '</h3>' + 
             '<p>' + y + ' in ' + x + '</p>'
              } !#")
  plot
  }

for_bar_plot <- function(dt, start_date, end_date, categories){
  dt %>% 
    filter(year >= start_date, year <= end_date,
           Category %in% categories) %>%
    group_by(Market, year) %>%
    summarise(profit = sum(Profit), sales = sum(Sales))
}

plot_bar_plot1 <- function(dt){
  g <- nPlot(profit ~ year, group = "Market", data = dt, type = "multiBarChart")
  g
}

plot_bar_plot2 <- function(dt){
  g <- nPlot(sales ~ year, group = "Market", data = dt, type = "multiBarChart")
  g
}

for_map <- function(dt){
  dt %>% 
    # filter(year >= start_date, year <= end_date,
    #        Category %in% categories) %>%
    group_by(Country) %>%
    summarise(profit = sum(Profit), sales = sum(Sales)) %>%
    mutate(Percentage_of_profit = profit/sum(profit)) %>%
    arrange(desc(profit))
}

plot_map <- function(dt) {
  Sys.sleep(0.3)
  g <- gvisGeoChart(dt, locationvar = "Country", colorvar = "profit",
                    options = list(projection = "kavrayskiy-vii", width = 850, 
                                   height = 550))
  
  p <- gvisTable(dt,
                 formats = list(profit = "$#,###",
                                sales = "$#,###",
                                Percentage_of_profit = "#.#%"),
                 options = list(page = 'enable', width = 750))
  gvisMerge(g, p, horizontal = FALSE)
}


