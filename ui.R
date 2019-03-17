# ui.R
library(shiny)
library(plotly)
library(shinycssloaders)
source('./analysis.R')

shinyUI(navbarPage(
  "OECD Migration Dataset",
  # Create a tabPanel to show your scatter plot
  tabPanel(
    "Migration vs. Acquisition of Citizenship",
    # Add a titlePanel to your tab
    titlePanel("Migration Totals by Country of Origin"),
    
    # Create a sidebar layout for this tab (page)
    sidebarLayout(
      
      # Create a sidebarPanel for your controls
      sidebarPanel(
        
        # Make a textInput widget for searching for a state in your scatter plot
        selectInput("country_var", "Select a Country", 
                    choices = c(country_selections)),
        selectInput("year_var", "Select a Year", 
                    choices = c(year_selections))
        
      ),
      
      # Create a main panel, display your plotly Scatter plot
      mainPanel(
        plotlyOutput("migration_chart") %>% withSpinner()
      )
    )
  ),
  
  tabPanel(
    "Totals Over Time",
    titlePanel("Migration Totals Over Time by Destination Country"),
    
    sidebarLayout(
      
      sidebarPanel(
        selectInput("country_select", "Select a Country", 
                    choices = c(country_selections))
      ),
      
      mainPanel(
        plotlyOutput("totals_plot") %>% withSpinner()
      )
    )
  ),
  tabPanel(
    "Source",
    h2("OECD International Migration Database"),
    p("OECD. (2002).", em("International Migration Database"), "[database]."),
    p("Retrieved from https://stats.oecd.org/Index.aspx?DataSetCode=MIG.")
  )
  )
)

