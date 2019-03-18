# ui.R
library(shiny)
library(plotly)
library(shinycssloaders)
library(shinydashboard)
library(shinythemes)

source('./analysis.R')


shinyUI(navbarPage(theme = shinytheme("sandstone"),
  "OECD Migration Dataset",
  # Create a tabPanel to show your scatter plot
  tabPanel(
    "Migration vs. Acquisition of Citizenship",
    # Add a titlePanel to your tab
    titlePanel("Migration vs. Acquisition of Citizenship"),
    
    # Create a sidebar layout for this tab (page)
    sidebarLayout(
      
      # Create a main panel, display your plotly Scatter plot
      mainPanel(
        plotlyOutput("migration_chart") %>% withSpinner(color = "#fcf7e5")
      ),
      
      # Create a sidebarPanel for your controls
      sidebarPanel(
        
        # Make a textInput widget for searching for a state in your scatter plot
        selectInput("country_var", "Select a Country", 
                    choices = c(country_selections)),
        selectInput("year_var", "Select a Year", 
                    choices = c(year_selections)),
        strong("Information"),
        p("This comparative bar chart juxtaposes the number migrants immigrating 
          to the destination country with the number of migrants who acquired 
          citizenship. Choose a country and year to view the information by
          country of origin.")
        
      )
    )
  ),
  
  tabPanel(
    "Totals Over Time",
    titlePanel("Migration Totals by Destination Country"),
    
    sidebarLayout(
      mainPanel(
        plotlyOutput("totals_plot") %>% withSpinner(color = "#fcf7e5")
      ),
      
      sidebarPanel(
        selectInput("country_select", "Select a Country", 
                    choices = c(country_selections)),
        strong("Information"), 
        p("Choose a country to view the total amount of migrants 
          flowing into the country compared to the number of migrants who
          obtained citizenship between 2000 and 2016")
      )
    )
  ),
  tabPanel(
    "Source",
    sidebarLayout(
      sidebarPanel(
      h2("Data Source"), 
      h3("OECD International Migration Database"),
      p("OECD. (2002).", em("International Migration Database"), "[database]."),
      p("Retrieved from https://stats.oecd.org/Index.aspx?DataSetCode=MIG.")
    ),
    sidebarPanel(
      h3("Visualizations"),
      p("Created by Alyssa Hall"),
      p("amh76@uw.edu")
    )
  ))
)
)


