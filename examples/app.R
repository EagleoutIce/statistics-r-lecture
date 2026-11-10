library(shiny)
library(ggplot2)

ui <- fluidPage(
  selectInput("species", "Species", levels(penguins$species)),
  sliderInput("alpha", "Alpha", min = 0.1, max = 1, value = 0.7),
  textOutput("n"),
  plotOutput("scatter")
)

server <- function(input, output) {
  chosen <- reactive(subset(penguins, species == input$species))
  output$n <- renderText(nrow(chosen()))
  output$scatter <- renderPlot(
    ggplot(chosen(), aes(flipper_len, body_mass)) +
      geom_point(alpha = input$alpha)
  )
}

shinyApp(ui, server)
