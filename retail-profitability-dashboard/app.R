suppressPackageStartupMessages({
  library(shiny)
  library(dplyr)
  library(readr)
  library(plotly)
  library(scales)
})

metrics <- read_csv(file.path("data", "market_category_metrics.csv.gz"), show_col_types = FALSE) %>% mutate(Year = as.integer(Year))
context <- read_csv(file.path("data", "market_context.csv"), show_col_types = FALSE) %>% mutate(Year = as.integer(Year))

ui <- fluidPage(
  titlePanel("Superstore Market Profitability Dashboard"),
  sidebarLayout(
    sidebarPanel(
      width = 2,
      sliderInput("year_range", "Year range", min(metrics$Year), max(metrics$Year), range(metrics$Year), step = 1, sep = ""),
      selectInput("market", "Market", c("All", sort(unique(metrics$Market)))),
      selectInput("category", "Category", c("All", sort(unique(metrics$Category)))),
      selectInput("segment", "Customer segment", c("All", sort(unique(metrics$Segment)))),
      selectInput("ship_mode", "Ship mode", c("All", sort(unique(metrics$Ship_Mode)))),
      tags$small("Course data. Results are descriptive and not real company performance.")
    ),
    mainPanel(
      width = 10,
      fluidRow(
        column(3, h4("Total sales"), textOutput("kpi_sales")),
        column(3, h4("Total profit"), textOutput("kpi_profit")),
        column(3, h4("Profit margin"), textOutput("kpi_margin")),
        column(3, h4("Average shipping days"), textOutput("kpi_shipping"))
      ),
      fluidRow(
        column(6, h4("Sales and profit trend"), plotlyOutput("trend", height = "300px")),
        column(6, h4("Profit margin by category"), plotlyOutput("category_margin", height = "300px"))
      ),
      fluidRow(
        column(6, h4("Lowest-profit sub-categories"), plotlyOutput("subcategory_loss", height = "300px")),
        column(6, h4("Market context: GDP, population and margin"), plotlyOutput("market_context", height = "300px"))
      ),
      fluidRow(column(12, h4("Digital readiness and category profitability"), plotlyOutput("internet_heatmap", height = "330px")))
    )
  )
)

server <- function(input, output) {
  filtered_metrics <- reactive({
    data <- metrics %>% filter(Year >= input$year_range[1], Year <= input$year_range[2])
    if (input$market != "All") data <- data %>% filter(Market == input$market)
    if (input$category != "All") data <- data %>% filter(Category == input$category)
    if (input$segment != "All") data <- data %>% filter(Segment == input$segment)
    if (input$ship_mode != "All") data <- data %>% filter(Ship_Mode == input$ship_mode)
    data
  })

  kpi <- reactive({
    filtered_metrics() %>% summarise(sales = sum(Total_Sales), profit = sum(Total_Profit), shipping_days = sum(Total_Shipping_Days) / sum(Transaction_Lines), .groups = "drop")
  })

  output$kpi_sales <- renderText(dollar(kpi()$sales, accuracy = 1))
  output$kpi_profit <- renderText(dollar(kpi()$profit, accuracy = 1))
  output$kpi_margin <- renderText(percent(kpi()$profit / kpi()$sales, accuracy = 0.01))
  output$kpi_shipping <- renderText(paste0(round(kpi()$shipping_days, 2), " days"))

  output$trend <- renderPlotly({
    data <- filtered_metrics() %>% group_by(Year) %>% summarise(Sales = sum(Total_Sales), Profit = sum(Total_Profit), .groups = "drop")
    plot_ly(data, x = ~Year) %>% add_lines(y = ~Sales, name = "Sales") %>% add_lines(y = ~Profit, name = "Profit") %>% layout(yaxis = list(title = "USD"), xaxis = list(tickmode = "array", tickvals = data$Year))
  })

  output$category_margin <- renderPlotly({
    data <- filtered_metrics() %>% group_by(Category) %>% summarise(Sales = sum(Total_Sales), Profit = sum(Total_Profit), .groups = "drop") %>% mutate(Margin = Profit / Sales)
    plot_ly(data, x = ~Category, y = ~Margin, type = "bar", hovertemplate = "%{x}<br>Profit margin: %{y:.2%}<extra></extra>") %>% layout(yaxis = list(title = "Profit margin", tickformat = ".1%"))
  })

  output$subcategory_loss <- renderPlotly({
    data <- filtered_metrics() %>% group_by(Sub_Category) %>% summarise(Profit = sum(Total_Profit), .groups = "drop") %>% arrange(Profit) %>% slice_head(n = 8)
    plot_ly(data, x = ~Profit, y = ~reorder(Sub_Category, Profit), type = "bar", orientation = "h", hovertemplate = "%{y}<br>Profit: $%{x:,.0f}<extra></extra>") %>% layout(xaxis = list(title = "Profit (USD)"), yaxis = list(title = ""))
  })

  output$market_context <- renderPlotly({
    data <- context %>% filter(Year >= input$year_range[1], Year <= input$year_range[2])
    if (input$market != "All") data <- data %>% filter(Market == input$market)
    data <- data %>% filter(!is.na(GDP_per_capita), !is.na(Population), !is.na(Profit_Margin)) %>% mutate(Population_Millions = Population / 1e6)
    plot_ly(data, x = ~GDP_per_capita, y = ~Profit_Margin, color = ~Market, size = ~Population_Millions, sizes = c(8, 45), type = "scatter", mode = "markers", text = ~Country, hovertemplate = "%{text}<br>GDP per capita: $%{x:,.0f}<br>Profit margin: %{y:.2%}<extra></extra>") %>% layout(xaxis = list(title = "GDP per capita, constant 2015 USD"), yaxis = list(title = "Profit margin", tickformat = ".1%"))
  })

  output$internet_heatmap <- renderPlotly({
    data <- filtered_metrics() %>% filter(!is.na(Internet_Group)) %>% group_by(Internet_Group, Category) %>% summarise(Sales = sum(Total_Sales), Profit = sum(Total_Profit), .groups = "drop") %>% mutate(Margin = Profit / Sales)
    plot_ly(data, x = ~Category, y = ~Internet_Group, z = ~Margin, type = "heatmap", colorbar = list(title = "Margin", tickformat = ".0%"), hovertemplate = "Category: %{x}<br>Internet group: %{y}<br>Profit margin: %{z:.2%}<extra></extra>")
  })
}

shinyApp(ui, server)
