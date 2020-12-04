# Task: Create a prototype data visualization for hackathon
# Author: Dennis Huynh

# Use synthetic data
# Add a chloropleth (will use voter turn out data, get GeoJSON file)

# Install packages
#install.packages("tidyverse")
#install.packages("plotly")

# Load packages
library(shiny)
library(tidyverse)
library(data.table)
library(plotly)

# Load data by reading files
lf <- select(read.csv("LabourForce.csv", check.names = FALSE), c(1, 4:10)) # Labour Force data for 15+, all estimates in percentages for year 2019
#house <- select(read.csv("Housing.csv", check.names = FALSE), c(1, 3:9)) # All semi-detached houses
#health <- read.csv("HealthIndicators.csv", check.names = FALSE)

# Rename the columns
#setnames(house, colnames(house), c("Sex", "Total - Age", "0-14 years", "15-19 years", "20-24 years",
#                                   "% 0-14 years", "% 15-19 years", "% 20-24 years"))

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
                                               "St. John's",
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
                 
                 checkboxGroupInput("VM", 
                                    label = "Visible Minority",
                                    choices = list("Total Visible Minority",
                                                   "Total visible minority population",
                                                   "South Asian",
                                                   "Chinese",
                                                   "Black",
                                                   "Filipino",
                                                   "Latin American",
                                                   "Arab",
                                                   "Southeast Asian",
                                                   "West Asian",
                                                   "Korean",
                                                   "Japanese",
                                                   "Visible minority, n.i.e.",
                                                   "Multiple visible minorities",
                                                   "Not a visible minority"),
                                    selected = "Total Visible Minority"
                 ),
                 
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
                 ),
                 width = 2
               ),
               
               mainPanel(
                 h1("Maps"),
                 h4("To filter the data, please select Geography, Age, and Sex first."),
                 fluidRow(
                   column(width = 8,
                          htmlOutput("covEdMap")
                   ),
                   column(width = 4,
                          htmlOutput("covCasesMap")
                   )
                 ),
                 htmlOutput("covOBMap"),
                 hr()
               )
             )
    ),
    
    # Second Tab
    tabPanel("School Closure Considerations", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(width = 2,
                 
                 h4("Table of Contents"),
                 br(),
                 a(href = "#schoolPolicies", "School Policies"),
                 br(),
                 a(href = "#Parents", "Parents"),
                 br(),
                 a(href = "#Students", "Students")
               ),
               
               mainPanel(
                 h1("Considerations by Stakeholder"),
                 br(),
                 h2(id ="schoolPolicies", "School Policies"),
                 tableOutput("sp"),
                 h2(id = "Parents", "Parents"),
                 h2(id = "Students", "Students")
                 
                 )
             )
    ),
    
    # Third Tab to provide resources
    tabPanel(
      "Resources", fluid = TRUE,
      sidebarLayout(
        sidebarPanel(width = 2,
                     
                     h4("Table of Contents"),
                     br(),
                     a(href = "#policies", "Existing Policies")
                     
        ),
        
        mainPanel(
          h1("Considerations by Stakeholder"),
          br(),
          h2(id ="policies", "Existing Policies"),
          
        ),
      )

    )
  )
)

# Define server logic ----
server <- function(input, output) {
  
  # Reactive values ----------------------------------------------------------
  
  
  # Output ---------------------------------------------------
  output$covEdMap <- renderUI ({
    edMap <- tags$iframe(src="https://www.google.com/maps/d/embed?mid=1ViVQD7zRyXUoAxE9wM0qAXmvCpJEiM6H", width="600", height="400")
    edMap
  })
  
  output$covCasesMap <- renderUI({
    casesMap <- tags$iframe(src="https://arcg.is/0KPGau", width="600", height="400")
    casesMap
  })
  
  output$covOBMap <- renderUI({
    obMap <-tags$iframe(src="https://arcg.is/0CCOW0", width="600", height="400")
    obMap
  })
  
  output$sp <- renderTable({
    schoolPol <- read.csv("health graphs.xlsx - Sheet2.csv", check.names = FALSE, encoding = "UTF-8")
    schoolPol
  }, bordered = TRUE, striped = TRUE, align = '?', width = '100%')
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
