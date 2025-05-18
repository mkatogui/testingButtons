library(shiny)
library(shinyjs)
library(shinyBS)

ui <- fluidPage(
  useShinyjs(),  # Initialize shinyjs
  titlePanel("Model Publishing App"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("user_approved", "User Approved", value = FALSE),
      actionButton("publish_btn", "Publish Model"),
      bsTooltip(
        id = "publish_btn",
        title = "You need an approved user to publish this model.",
        placement = "right",
        trigger = "hover"
      )
    ),
    mainPanel(
      verbatimTextOutput("publish_status")
    )
  )
)

server <- function(input, output, session) {
  # Enable or disable the button based on checkbox state
  observe({
    if (isTRUE(input$user_approved)) {
      enable("publish_btn")
      removeTooltip(session, id = "publish_btn")  # Remove tooltip when enabled
    } else {
      disable("publish_btn")
      addTooltip(
        session = session,
        id = "publish_btn",
        title = "You need an approved user to publish this model.",
        placement = "right",
        trigger = "hover"
      )  # Add tooltip when disabled
    }
  })
  
  # Show a message when the button is clicked
  output$publish_status <- renderText({
    req(input$publish_btn)
    if (isTRUE(input$user_approved)) {
      "Model published!"
    }
  })
}

shinyApp(ui, server)