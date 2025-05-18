library(shiny)
library(shinyjs)
library(shinyBS)

ui <- fluidPage(
  useShinyjs(),
  titlePanel("Model Publishing App"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("user_approved", "User Approved", value = FALSE),
      uiOutput("publish_btn_ui")
    ),
    mainPanel(
      verbatimTextOutput("publish_status")
    )
  )
)

server <- function(input, output, session) {
  # Dynamically render the button and tooltip based on checkbox state
  output$publish_btn_ui <- renderUI({
    if (isTRUE(input$user_approved)) {
      tagList(
        actionButton("publish_btn", "Publish Model"),
        bsTooltip(
          id = "publish_btn",
          title = "You are going to publish this model.",
          placement = "right",
          trigger = "hover"
        )
      )
    } else {
      tagList(
        actionButton("publish_btn", "Publish Model", disabled = TRUE),
        bsTooltip(
          id = "publish_btn",
          title = "You need an approved user to publish this model.",
          placement = "right",
          trigger = "hover"
        )
      )
    }
  })

  output$publish_status <- renderText({
    req(input$publish_btn)
    if (isTRUE(input$user_approved)) {
      "Model published!"
    }
  })
}

shinyApp(ui, server)
