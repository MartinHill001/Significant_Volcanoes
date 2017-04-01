library(shiny)
library(leaflet)

#download.file(destfile = "volerup.txt",
## url = "https://www.ngdc.noaa.gov/nndc/struts/results?type_0=Exact&query_0=$HAZ_EVENT_ID&t=102557&s=50&d=54&dfn=volerup.txt")

df<-read.delim2(file="volerup.txt", stringsAsFactors = FALSE)

#set col to VEI, where NA to be -1 and make as index
df$VEIsize<-df$VEI
df["VEIsize"][is.na(df["VEIsize"])] <- -1
df$VEIsize<-df$VEIsize+2
df$aA<-grepl("a|A",df$Agent)
df$eE<-grepl("e|E",df$Agent)
df$fF<-grepl("f|F",df$Agent)
df$gG<-grepl("g|G",df$Agent)
df$iI<-grepl("i|I",df$Agent)
df$lL<-grepl("l|L",df$Agent)
df$mM<-grepl("m|M",df$Agent)
df$pP<-grepl("p|P",df$Agent)
df$sS<-grepl("s|S",df$Agent)
df$tT<-grepl("t|T",df$Agent)
df$wW<-grepl("w|W",df$Agent)
class(df$Latitude)<-"numeric"
class(df$Longitude)<-"numeric"

## Significant Eruptions
YearCol <- function(Year) {
      if(Year < -4000) "grey"
      else if(Year < -3000) "violet"
      else if(Year < -2000) "indigo"
      else if(Year < -1000) "blue"
      else if(Year < 0) "green" #1st millenium BC
      else if(Year < 1000) "yellow" #1st millenium AD
      else if(Year < 2000) "orange"
      else if(Year < 3000) "red"
      else "black"
}

df$Yearcolour <- sapply(df$Year, function(x) YearCol(x))

Yearcolour <- sapply(c(-5000,-4000,-3000,-2000,-1000,0,1000,2000), function(x) YearCol(x))
YearLabel <-c("5000 BC- 4001 BC","4000 BC- 3001 BC","3000 BC- 2001 BC","2000 BC- 1001 BC","1000 BC- 1 BC", "1 AD- 1000 AD", "1001 AD- 2000 AD","2001 AD- 3000 AD")


shinyServer(function(input, output) {
   

      dfmap <- data.frame(lat = df$Latitude,
                       lng = df$Longitude,
                       col = df$Yearcolour,
                       size = df$VEIsize*2,
                       Name = df$Name,
                       Year = df$Year,
                       Country = df$Country,
                       Elevation = df$Elevation,
                       Agent = df$Agent,
                       eE = df$eE,
                       pP = df$pP,
                       tT = df$tT,
                       stringsAsFactors = TRUE)
                
      #transitional
      mapdata<-reactive({
                        subset(dfmap, dfmap$Year >= input$sliderAge[1] & dfmap$Year <= input$sliderAge[2]
                               & dfmap$Country == input$Country
                               & (input$All
                                 |(input$eE & dfmap$eE)
                                 |(input$pP & dfmap$pP)                
                                 |(input$tT & dfmap$tT))
                              )
                        })
      #restrict
      df<-df[df$Country=="United",]
      
      content <-  reactive({
            paste(sep = "<br/>",
                        mapdata()$Name,
                       paste(sep = "", "Year : ", as.character(mapdata()$Year)),
                       paste(sep = "", "Elevation : ", as.character(mapdata()$Elevation)),
                       paste(sep = "", "Agent : ", mapdata()$Agent)
                       )
                        })
      
      output$plot1 <- renderLeaflet({
            mapdata()%>%leaflet()%>%
                  addTiles()%>%
                  addCircleMarkers(color = mapdata()$col, radius = mapdata()$size, popup = content())%>%
                  addLegend(labels = YearLabel, colors = Yearcolour)
      })
      
      
      output$numPoints <- renderText({
            paste( sep = ":", "Number of volcanoes shown", nrow(mapdata()))
            })
      
})
