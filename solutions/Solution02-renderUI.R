library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      ##### UI components here
      fileInput("file", "Upload data:"),
      uiOutput("nRowUI")


    ),
    mainPanel(
      #####
      ##### Output components here
      plotOutput("plot"),
      tableOutput("table")

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

    output$table <- renderTable({

      input$button

      head(myData(), isolate({input$nrow}))
    })


    output$nRowUI <- renderUI({
      req(myData())

      list(sliderInput("nrow", "Show these rows:",
                  min = 0, max = nrow(myData()), value = nrow(myData()), step = 1),
      actionButton("button", "Go"))
    })

  }

  shinyApp(ui, server)
