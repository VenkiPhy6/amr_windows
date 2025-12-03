# This starter code was created by ChatGPT
# The prompts I used to get this can be seen here: https://chatgpt.com/share/692fb3cb-1b30-800b-9cd7-fe0a2f375538

rm(list = ls())

pacman::p_load(shiny, ggplot2, plotly)

ui <- fluidPage(
  h2("Clickable Matrix → Dashboard"),
  plotlyOutput("matrix"),
  hr(),
  uiOutput("dashboard")
)

server <- function(input, output, session) {
  
  # ---- Matrix plot ----
  output$matrix <- renderPlotly({
    df <- expand.grid(x = 1:5, y = 1:5)
    df$z <- rnorm(nrow(df))
    
    p <- ggplot(df, aes(x, y, fill = z)) +
      geom_tile() +
      scale_y_reverse() +                # Makes it look like a matrix
      coord_fixed()
    
    ggplotly(p, source = "mat")          # `source` allows click detection
  })
  
  # ---- On click, generate dashboard ----
  observeEvent(event_data("plotly_click", source = "mat"), {
    
    click <- event_data("plotly_click", source = "mat")
    cx <- click$x
    cy <- click$y
    
    output$dashboard <- renderUI({
      tagList(
        h3(sprintf("Dashboard for cell (%d, %d)", cx, cy)),
        fluidRow(
          column(4, plotOutput("p1")),
          column(4, plotOutput("p2")),
          column(4, plotOutput("p3"))
        )
      )
    })
    
    output$p1 <- renderPlot({
      plot(rnorm(100), main = sprintf("Plot 1 for (%d,%d)", cx, cy))
    })
    output$p2 <- renderPlot({
      hist(rnorm(1000), main = sprintf("Plot 2 for (%d,%d)", cx, cy))
    })
    output$p3 <- renderPlot({
      boxplot(rnorm(200), main = sprintf("Plot 3 for (%d,%d)", cx, cy))
    })
  })
}

shinyApp(ui, server)
