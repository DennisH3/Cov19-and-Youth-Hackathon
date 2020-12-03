# Task: Create a prototype data visualization for hackathon
# Author: Dennis Huynh

# Use synthetic data
# Add a chloropleth (will use voter turn out data, get GeoJSON file)

# Install packages
#install.packages("tidyverse")
#install.packages("plotly")
#install.packages("manipulateWidget")

# Load packages
library(shiny)
library(manipulateWidget)
library(tidyverse)
library(data.table)
library(plotly)

# Load data by reading files

# Read file for scatter plot


# Define UI ----
ui <- fluidPage(
  titlePanel("School Closures Policy Decision Making Tool"),
  tabsetPanel(
    tabPanel("Overview", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 
                 selectizeInput("year", 
                                label = "Year",
                                choices = list("2020", 
                                               "2019",
                                               "2018", 
                                               "2017",
                                               "2016"),
                                selected = "2020"),
                 
                 selectizeInput("month",
                                label = "Month",
                                choices = list("January",
                                               "February",
                                               "March",
                                               "April",
                                               "May",
                                               "June",
                                               "July",
                                               "August",
                                               "September",
                                               "October",
                                               "November",
                                               "December"),
                                selected = "December"),
                 
                 selectizeInput("geo", 
                                label = "Geography",
                                choices = list("Canada",
                                               "Newfoundland and Labrador",
                                               "Nova Scotia",
                                               "New Brunswick",
                                               "Prince Edward Island",
                                               "Québec",
                                               "Ontario",
                                               "Manitoba",
                                               "Saskatchewan",
                                               "Alberta",
                                               "British Columbia",
                                               "Nunavut",
                                               "Northwest Territories",
                                               "Yukon",
                                               "Ottawa",
                                               "St. John’s",
                                               "Halifax",
                                               "Fredericton",
                                               "Charlottetown",
                                               "Québec City",
                                               "Toronto",
                                               "Winnipeg",
                                               "Regina",
                                               "Edmunton",
                                               "Victoria",
                                               "Iqaluit",
                                               "Yellowknife",
                                               "Whitehorse"),
                                selected = "Canada"
                                
                 ),
                 
                 h4("Indicators"),
                 
                 # Use manipulate widgets to create groups of widgets, to add sub-indicators
                 
                 # Make note of what inactive rate means (ask Klarka for formal definition)
                 checkboxGroupInput("EconI",
                                    label = "Economic Indicator",
                                    choices = list("Unemployment Rate",
                                                   "Inactive Rate"),
                                    selected = "Unemployment Rate"
                 ),
                 
                 checkboxGroupInput("PhysI", 
                                    label = "Physical Indicator",
                                    choices = list("Physical Activity",
                                                   "Housing",
                                                   "Perceived Health (Good to Excellent)",
                                                   "Perceived Health (Fair to Poor)"),
                                    selected = "Physical Activity"
                 ),
                 
                 checkboxGroupInput("MenI",
                                    label = "Mental Indicator",
                                    choices = list("Perceived Mental Health (Good to Excellent)",
                                                   "Perceived Mental Health (Fair to Poor)",
                                                   "Life satisfaction, satisfied or very satisfied (12 to 17 years old)",
                                                   "Anxiety disorder (5 to 17 years old)",
                                                   "Mood disorder (5 to 17 years old)",
                                                   "Eating disorder (5 to 17 years old)",
                                                   "Difficulties in getting to sleep (5 to 17 years old)"),
                                    selected = "Perceived Mental Health (Fair to Poor)"
                 ),
                 
                 h4("Sub-populations"),
                 
                 selectizeInput("age", 
                                label = "Age Group",
                                choices = list("Total - Age (1-17)",
                                               "Total - Age (5-17)",
                                               "1-4",
                                               "5-11",
                                               "12-17"),
                                selected = "Total - Age (1-17)"
                 ),
                 
                 selectizeInput("sex", 
                                label = "Sex",
                                choices = list("Total - Sex",
                                               "Male",
                                               "Female"),
                                selected = "Total - Sex"
                 )
               ),
               
               mainPanel(
                 h1("Maps"),
                 h4("To filter the data, please select Geography, Age, and Sex first."),
                 htmlOutput("covEdMap"),
                 htmlOutput("covCasesMap"),
                 htmlOutput("covOBMap")
                 )
             )
    ),
    
    # Second Tab
    tabPanel("School Closure Considerations", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 
                 
                 
               ),
               
               mainPanel(
                 h1("Considerations by Stakeholder")
                 )
             )
    ),
    
    # Third Tab to provide resources
    tabPanel(
      "Resources", fluid = TRUE

    )
  )
)

# Define server logic ----
server <- function(input, output) {
  
  # Reactive values ----------------------------------------------------------
  
  
  # Output ---------------------------------------------------
  output$covEdMap <- renderUI ({
    edMap <- tags$iframe(src="https://www.google.com/maps/d/embed?mid=1ViVQD7zRyXUoAxE9wM0qAXmvCpJEiM6H", width="800", height="600")
    edMap
  })
  
  output$covCasesMap <- renderUI({
    casesMap <- tags$iframe(src="https://arcg.is/0KPGau", width="800", height="600")
    casesMap
  })
  
  output$covOBMap <- renderUI({
    obMap <-tags$iframe(src="https://arcg.is/0CCOW0", width="800", height="600")
    obMap
  }) 
  
}

# Run the app ----
shinyApp(ui = ui, server = server)