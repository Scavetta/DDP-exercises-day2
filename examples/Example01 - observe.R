library(shiny)

geodata <- read.csv("geodata.csv", na.string = "#N/A", row.names = NULL)

ui <- fluidPage(

    # Write a csv based on user input
    sidebarPanel(
      selectInput("filter1", "First selection:"
                  , choices = c(Choose='', "A", "B")
                  #, multiple=T
      ),

      selectInput("filter2", "Second selection:",
                  choices = c(Choose='', "C", "D")
      ),
      br(),
      # actionButton prevents writing before user finalises selection
      actionButton("generateButton","Write Data")
    ),
    mainPanel()
  )

server <- function(input, output) {
  geodatasetInput <- observe({

    # Execute selections on data upon button-press
    if(input$generateButton == 0) return()

    inp.BSL <- isolate(input$filter1)
    inp.loc <- isolate(input$filter2)
    if (inp.BSL=='' | inp.loc=='') return()

    # BSL switch
    selection <-switch(inp.BSL
                       , A = "A"
                       , B = "B"
    )
    # Location switch
    selection2 <-switch(inp.loc
                        , C = "C"
                        , D = "D"
    )

    # subset based on selection
    Subgeodata <- subset(geodata, BSL == selection & Position.Location == selection2)

    # browser()
    # aggregate by postcode
    Subgeodata <- Subgeodata[1:2] #no longer need other columns
    AggSubGdata <- aggregate(. ~ Postcode, data=Subgeodata, FUN=sum)
    write.csv(AggSubGdata
              , file = "solution.csv"
              , row.names=F
    )
  })
}

shinyApp(ui, server)
