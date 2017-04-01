library(shiny)
library(leaflet)

shinyUI(fluidPage(
      
      titlePanel("Significant Volcanoes"),
      h3("Simply make your selection and press Submit. "),
      
      sidebarLayout(
            sidebarPanel(
                  #textInput("Country", "Country", value="United States"),
                  selectInput("Country", "Country:", choices = c("Antarctica","Cameroon","Canada","Cape Verde","Chile","China","Colombia","Comoros","Congo", "DRC","Costa Rica","Ecuador","El Salvador","Eritrea","Ethiopia","Greece","Guadeloupe","Guatemala","Iceland","Indonesia","Italy","Japan","Martinique","Mexico","Montserrat","New Zealand","Nicaragua","North Korea","Pacific Ocean","Papua New Guinea","Peru","Philippines","Portugal","Reunion","Russia","Samoa","Saudi Arabia","Solomon Is.","Spain,St","Kitts & Nevis","St. Vincent & the Grenadines","Taiwan","Tanzania","Tonga","Trinidad" ,"Turkey","United States","Vanuatu","Yemen")),
                  sliderInput("sliderAge",
                              "Year Range",
                              min = -5000,
                              max = 3000,
                              step = 500,
                              value = c(-5000,3000)),
                  
                  checkboxInput("All", "All",value=TRUE),
                  checkboxInput("eE", "Earthquake",value=FALSE),
                  checkboxInput("pP", "Pyroclastic Flow",value=FALSE),
                  checkboxInput("tT", "Tsunami",value=FALSE),
                  submitButton("Submit")
            ),
            
            
            mainPanel(
                  leafletOutput("plot1"),
                  textOutput("numPoints"),
                  p("Size represents the VEI")
                  )
      )
))
