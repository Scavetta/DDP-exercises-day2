library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      ##### UI components here
      fileInput("file", "Upload data:")

    ),
    mainPanel(
      #####
      ##### Output components here
      plotOutput("plot")

    )
  )
)


  server <- function(input, output) {
    #####
    ##### Reactive components here
    myData <- reactive({

      inFile <- input$file

      if (is.null(inFile))
        return(NULL)

      read.delim(inFile$datapath)
      })

    output$plot <- renderPlot({
      #####
      ##### Plotting functions here
      output$plot <- renderPlot({plot(myData())})
      #####
    })
  }

  shinyApp(ui, server)
