library(plotly)
library(dplyr)

oecd_data <- read.csv("US immigration by nationality.csv")

oecd <- read.csv("oecd.csv")

######################### Analysis for Bar Chart ##############################

# Get migration inflow values
france_migration <- oecd_data %>% 
  filter(Country == "France",
         Variable == "Inflows of foreign population by nationality", 
         Year == "2016", Value >= 2500) %>% 
  rename("origin" = Country.of.birth.nationality, "inflow" = Value) %>% 
  filter(origin != "Total")  
 # arrange(-inflow) %>% 
 # slice(1:24)


# Get aqcuisition numbers

france_naturalization <- oecd %>% 
  filter(Variable ==
           "Acquisition of nationality by country of former nationality", 
         Country == "France", Year == "2016") %>% 
  rename("origin" = Country.of.birth.nationality, "acquisition" = Value)

# Join data sets of migration and acquisition

joined_french_data <- left_join(france_migration, france_naturalization, 
                                by = "origin")

joined_french_data <- joined_french_data %>% 
  mutate(origin_char = as.character(origin))

# Build example plot 

example_chart <- plot_ly(
  data = joined_french_data, 
  x = ~inflow, 
  y = ~origin_char,
  name = "Inflow of migrants",
  type = "bar",
  colors = "Set1"
) %>% 
  layout(title = "French Migration and Acquisition of Citizenship in 2016 by Country of Origin",
         xaxis = list(title = "Number of migrants"),
         yaxis = list(title = "")) %>% 
  add_trace(x = ~acquisition, name = "Acquisition of Citizenship")


example_chart

# Get countries for selection

country_choices <- oecd %>%
  select(Country)

country_selections <- unique(country_choices)

# Get years for selections
year_choices <- oecd %>% 
  select(Year)

year_selections <- unique(year_choices)


############################ Bar Chart Function ###############################

build_barchart <- function(data1, data2, country, year) {
  migration <- data1 %>% 
    filter(Country == country,
           Variable == "Inflows of foreign population by nationality", 
           Year == year) %>% 
    arrange(-Value) %>% 
    slice(1:24) %>% 
    rename("origin" = Country.of.birth.nationality, "inflow" = Value) %>% 
    filter(origin != "Total")
  
  naturalization <- data2 %>% 
    filter(Variable ==
             "Acquisition of nationality by country of former nationality", 
           Country == country, Year == year) %>% 
    rename("origin" = Country.of.birth.nationality, "acquisition" = Value)
  
  joined_data <- left_join(migration, naturalization, 
                                  by = "origin")
  
  joined_data <- joined_data %>% 
    mutate(origin_char = as.character(origin))
  
  chart <- plot_ly(
    joined_data, 
    x = ~inflow, 
    y = ~origin_char,
    name = "Inflow of migrants",
    type = "bar",
    colors = "Set1"
  ) %>% 
    layout(title = "",
           xaxis = list(title = "Number of migrants"),
           yaxis = list(title = "")) %>% 
    add_trace(x = ~acquisition, name = "Acquisition of Citizenship")
}

US_2016 <- build_barchart(oecd_data, oecd, "United States", "2016")

US_2016

########################## Analysis for Year Plot #############################

# Get total number of incoming migrants

france_total_inflow <- oecd_data %>%  
  filter(Country == "France",
         Variable == "Inflows of foreign population by nationality", 
         Country.of.birth.nationality == "Total") %>% 
  rename("total" = Country.of.birth.nationality, "inflow" = Value)

# Get total number of migrants acquiring citizenship

france_total_acquisition <- oecd %>% 
  filter(Country == "France", 
         Variable == "Acquisition of nationality by country of former nationality",
         Country.of.birth.nationality == "Total") %>% 
  rename("total" = Country.of.birth.nationality, "acquisition" = Value)

# Join data sets

joined_french_totals <- left_join(france_total_inflow, france_total_acquisition,
                                  by = "Year")

joined_french_totals <- joined_french_totals %>% 
  mutate(year_string = as.character(Year))

# Build example plot 

example_plot <- plot_ly(
  joined_french_totals, 
  x = ~year_string, 
  y = ~inflow,
  name = "Inflow of migrants",
  type = "scatter",
  mode = "lines+markers",
  colors = "Set1"
) %>% 
  layout(title = "French Migration and Acquisition of Citizenship over Time",
         xaxis = list(title = "Year"),
         yaxis = list(title = "Total Number of Migrants")) %>% 
  add_trace(y = ~acquisition, name = "Acquisition of Citizenship")

example_plot

############################# Year Plot Function #############################

build_plot <- function(data1, data2, country) {
  total_inflow <- data1 %>%  
    filter(Country == country,
           Variable == "Inflows of foreign population by nationality", 
           Country.of.birth.nationality == "Total") %>% 
    rename("total" = Country.of.birth.nationality, "inflow" = Value)
  
  total_acquisition <- data2 %>% 
    filter(Country == country, 
           Variable == "Acquisition of nationality by country of former nationality",
           Country.of.birth.nationality == "Total") %>% 
    rename("total" = Country.of.birth.nationality, "acquisition" = Value)
  
  joined_totals <- left_join(total_inflow, total_acquisition,
                                    by = "Year")
  
  joined_totals <- joined_totals %>% 
    mutate(year_string = as.character(Year))
  
  plot <- plot_ly(
    joined_totals, 
    x = ~year_string, 
    y = ~inflow,
    name = "Inflow of migrants",
    type = "scatter",
    mode = "lines+markers",
    colors = "Set1"
  ) %>% 
    layout(title = "",
           xaxis = list(title = "Year"),
           yaxis = list(title = "Total Number of Migrants")) %>% 
    add_trace(y = ~acquisition, name = "Acquisition of Citizenship")
}

US_totals <- build_plot(oecd_data, oecd, "Australia")

US_totals






