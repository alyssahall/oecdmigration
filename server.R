library(dplyr)
library(ggplot2)

source('./analysis.R')

# Start shinyServer
shinyServer(function(input, output) { 
  output$migration_chart <- renderPlotly({
    return(build_barchart(oecd_data, oecd, input$country_var, input$year_var))
  })
  output$totals_plot <- renderPlotly({
    return(build_plot(oecd_data, oecd, input$country_select))
  })
})
