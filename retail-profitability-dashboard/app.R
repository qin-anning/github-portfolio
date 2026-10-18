# ETW2001 Assignment 2 - R Shiny Dashboard Draft
# Problem: Identify high-potential countries and product categories by combining
# internal Superstore performance with external indicators of market size,
# economic capacity, and digital readiness.

library(shiny)
library(tidyverse)
library(readxl)
library(plotly)
library(scales)

# ---------- 1. Read data ----------
superstore <- read_excel("superstore.xlsx")

# World Bank Excel files downloaded from the official World Bank indicator pages.
# The files usually contain columns such as:
# Country Name, Country Code, Indicator Name, Indicator Code, 1960, ..., 2024
read_wdi_excel <- function(file, value_name) {
  raw <- read_excel(file, sheet = 1, skip = 3)
  names(raw) <- gsub("\\s*\\[YR\\d{4}\\]", "", names(raw))
  names(raw) <- trimws(names(raw))
  
  # Standardise common World Bank column names
  raw <- raw %>%
    rename(
      Country = any_of(c("Country Name", "Country")),
      Country_Code = any_of(c("Country Code")),
      Indicator_Name = any_of(c("Indicator Name")),
      Indicator_Code = any_of(c("Indicator Code"))
    )
  
  year_cols <- intersect(as.character(2011:2014), names(raw))
  
  raw %>%
    select(Country, Country_Code, all_of(year_cols)) %>%
    pivot_longer(
      cols = all_of(year_cols),
      names_to = "Year",
      values_to = value_name
    ) %>%
    mutate(
      Year = as.integer(Year),
      !!value_name := as.numeric(.data[[value_name]])
    ) %>%
    filter(!is.na(Country), !is.na(Year))
}

gdp <- read_wdi_excel("external_gdp_per_capita_worldbank.xls", "GDP_per_capita")
population <- read_wdi_excel("external_population_worldbank.xls", "Population")
internet <- read_wdi_excel("external_internet_usage_worldbank.xls", "Internet_Usage")

external_wdi <- gdp %>%
  select(Country, Year, GDP_per_capita) %>%
  left_join(population %>% select(Country, Year, Population), by = c("Country", "Year")) %>%
  left_join(internet %>% select(Country, Year, Internet_Usage), by = c("Country", "Year"))

# ---------- 2. Clean Superstore ----------
# Convert names to R-friendly format, e.g. Order Date -> Order.Date
names(superstore) <- make.names(names(superstore))

standardise_superstore_country <- function(x) {
  recode(x,
         "Russia" = "Russian Federation",
         "South Korea" = "Korea, Rep.",
         "Iran" = "Iran, Islamic Rep.",
         "Vietnam" = "Viet Nam",
         "Egypt" = "Egypt, Arab Rep.",
         "Hong Kong" = "Hong Kong SAR, China",
         "Taiwan" = "Taiwan, China",
         "Venezuela" = "Venezuela, RB",
         "Bolivia" = "Bolivia",
         "Czech Republic" = "Czechia",
         .default = x)
}

superstore_clean <- superstore %>%
  mutate(
    Order.Date = as.Date(Order.Date),
    Ship.Date = as.Date(Ship.Date),
    Year = as.integer(Year),
    Country_Original = Country,
    Country = standardise_superstore_country(Country),
    Shipping_Days = as.numeric(Ship.Date - Order.Date),
    Profit_Margin = ifelse(Sales > 0, Profit / Sales, NA_real_),
    Loss_Flag = Profit < 0
  )

# Data for country-year level external analysis
country_year_data <- superstore_clean %>%
  group_by(Country, Year, Market) %>%
  summarise(
    Total_Sales = sum(Sales, na.rm = TRUE),
    Total_Profit = sum(Profit, na.rm = TRUE),
    Total_Quantity = sum(Quantity, na.rm = TRUE),
    Orders = n_distinct(Order.ID),
    Avg_Discount = mean(Discount, na.rm = TRUE),
    Avg_Shipping_Cost = mean(Shipping.Cost, na.rm = TRUE),
    Avg_Shipping_Days = mean(Shipping_Days, na.rm = TRUE),
    Profit_Margin = ifelse(Total_Sales > 0, Total_Profit / Total_Sales, NA_real_),
    Loss_Order_Rate = mean(tapply(Loss_Flag, Order.ID, function(flags) sum(flags) > 0)),
    .groups = "drop"
  ) %>%
  left_join(external_wdi, by = c("Country", "Year")) %>%
  mutate(
    Sales_per_Million_Pop = ifelse(Population > 0, Total_Sales / Population * 1000000, NA_real_),
    Internet_Group = case_when(
      is.na(Internet_Usage) ~ "Missing",
      Internet_Usage < 40 ~ "Low internet usage",
      Internet_Usage < 70 ~ "Medium internet usage",
      TRUE ~ "High internet usage"
    )
  )

# Data for category-level dashboard charts
category_country_year_data <- superstore_clean %>%
  group_by(Country, Year, Market, Category, Segment, Ship.Mode) %>%
  summarise(
    Sales = sum(Sales, na.rm = TRUE),
    Profit = sum(Profit, na.rm = TRUE),
    Quantity = sum(Quantity, na.rm = TRUE),
    Orders = n_distinct(Order.ID),
    Avg_Discount = mean(Discount, na.rm = TRUE),
    Avg_Shipping_Cost = mean(Shipping.Cost, na.rm = TRUE),
    Avg_Shipping_Days = mean(Shipping_Days, na.rm = TRUE),
    Profit_Margin = ifelse(Sales > 0, Profit / Sales, NA_real_),
    .groups = "drop"
  ) %>%
  left_join(external_wdi, by = c("Country", "Year")) %>%
  mutate(
    Internet_Group = case_when(
      is.na(Internet_Usage) ~ "Missing",
      Internet_Usage < 40 ~ "Low internet usage",
      Internet_Usage < 70 ~ "Medium internet usage",
      TRUE ~ "High internet usage"
    )
  )

# Save processed files required by the assignment brief
write_csv(superstore_clean, "processed_superstore_clean.csv")
write_csv(external_wdi, "processed_external_wdi_2011_2014.csv")
write_csv(country_year_data, "processed_country_year_dashboard_data.csv")
write_csv(category_country_year_data, "processed_category_dashboard_data.csv")

# ---------- 3. Shiny UI ----------
ui <- fluidPage(
  titlePanel("Superstore Market Potential and Profitability Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      width = 2,
      sliderInput("year_range", "Year range",
                  min = min(category_country_year_data$Year, na.rm = TRUE),
                  max = max(category_country_year_data$Year, na.rm = TRUE),
                  value = range(category_country_year_data$Year, na.rm = TRUE),
                  step = 1, sep = ""),
      selectInput("market", "Market",
                  choices = c("All", sort(unique(category_country_year_data$Market))),
                  selected = "All"),
      selectInput("category", "Category",
                  choices = c("All", sort(unique(category_country_year_data$Category))),
                  selected = "All"),
      selectInput("segment", "Segment",
                  choices = c("All", sort(unique(category_country_year_data$Segment))),
                  selected = "All"),
      selectInput("shipmode", "Ship Mode",
                  choices = c("All", sort(unique(category_country_year_data$Ship.Mode))),
                  selected = "All")
    ),
    
    mainPanel(
      width = 10,
      fluidRow(
        column(3, h4("Total Sales"), textOutput("kpi_sales")),
        column(3, h4("Total Profit"), textOutput("kpi_profit")),
        column(3, h4("Profit Margin"), textOutput("kpi_margin")),
        column(3, h4("Avg Shipping Days"), textOutput("kpi_shipdays"))
      ),
      hr(),
      fluidRow(
        column(6, h4("1. Sales and Profit Trend"), plotlyOutput("line_trend", height = "300px")),
        column(6, h4("2. Profit Margin by Category"), plotlyOutput("bar_category", height = "300px"))
      ),
      fluidRow(
        column(6, h4("3. GDP per Capita, Population Size and Profit Margin"), plotlyOutput("scatter_gdp", height = "300px")),
        column(6, h4("4. Profit Margin Distribution by Segment"), plotlyOutput("box_segment", height = "300px"))
      ),
      fluidRow(
        column(12, h4("5. Internet Usage Group × Category Profitability"), plotlyOutput("heatmap_internet", height = "330px"))
      )
    )
  )
)

# ---------- 4. Shiny Server ----------
server <- function(input, output) {
  
  filtered_category_data <- reactive({
    data <- category_country_year_data %>%
      filter(Year >= input$year_range[1], Year <= input$year_range[2])
    
    if (input$market != "All") data <- data %>% filter(Market == input$market)
    if (input$category != "All") data <- data %>% filter(Category == input$category)
    if (input$segment != "All") data <- data %>% filter(Segment == input$segment)
    if (input$shipmode != "All") data <- data %>% filter(Ship.Mode == input$shipmode)
    
    data
  })
  
  filtered_country_data <- reactive({
    # Recalculate geography from the same filtered data as the KPI and category charts.
    # External indicators are attributes of each country-year, not sums.
    filtered_category_data() %>%
      group_by(Country, Year, Market) %>%
      summarise(
        Total_Sales = sum(Sales, na.rm = TRUE),
        Total_Profit = sum(Profit, na.rm = TRUE),
        GDP_per_capita = first(GDP_per_capita),
        Population = first(Population),
        Profit_Margin = ifelse(Total_Sales > 0, Total_Profit / Total_Sales, NA_real_),
        .groups = "drop"
      )
  })
  
  output$kpi_sales <- renderText({
    dollar(sum(filtered_category_data()$Sales, na.rm = TRUE))
  })
  
  output$kpi_profit <- renderText({
    dollar(sum(filtered_category_data()$Profit, na.rm = TRUE))
  })
  
  output$kpi_margin <- renderText({
    data <- filtered_category_data()
    sales <- sum(data$Sales, na.rm = TRUE)
    if (sales <= 0) return("N/A")
    paste0(round(sum(data$Profit, na.rm = TRUE) / sales * 100, 2), "%")
  })
  
  output$kpi_shipdays <- renderText({
    paste0(round(mean(filtered_category_data()$Avg_Shipping_Days, na.rm = TRUE), 2), " days")
  })
  
  output$line_trend <- renderPlotly({
    trend_data <- filtered_category_data() %>%
      group_by(Year) %>%
      summarise(
        Sales = sum(Sales, na.rm = TRUE),
        Profit = sum(Profit, na.rm = TRUE),
        .groups = "drop"
      )
    
    plot_ly() %>%
      add_trace(
        data = trend_data,
        x = ~Year,
        y = ~Sales,
        type = "scatter",
        mode = "lines+markers",
        name = "Sales",
        line = list(width = 2)
      ) %>%
      add_trace(
        data = trend_data,
        x = ~Year,
        y = ~Profit,
        type = "scatter",
        mode = "lines+markers",
        name = "Profit",
        line = list(width = 2)
      ) %>%
      layout(
        xaxis = list(
          title = "Year",
          tickmode = "array",
          tickvals = sort(unique(trend_data$Year))
        ),
        yaxis = list(title = "Amount")
      )
  })
  
  output$bar_category <- renderPlotly({
    bar_data <- filtered_category_data() %>%
      group_by(Category) %>%
      summarise(Sales = sum(Sales, na.rm = TRUE), Profit = sum(Profit, na.rm = TRUE), .groups = "drop") %>%
      mutate(Profit_Margin = Profit / Sales)
    
    plot_ly(bar_data, x = ~Category, y = ~Profit_Margin, type = "bar",
            hovertemplate = "Category: %{x}<br>Profit Margin: %{y:.2%}<extra></extra>") %>%
      layout(xaxis = list(title = "Category"), yaxis = list(title = "Profit Margin", tickformat = ".1%"))
  })
  
  output$scatter_gdp <- renderPlotly({
    gdp_data <- filtered_country_data() %>%
      filter(
        !is.na(GDP_per_capita),
        !is.na(Population),
        !is.na(Profit_Margin)
      ) %>%
      mutate(
        Population_Million = Population / 1000000,
        Sales_per_Million_Pop = Total_Sales / Population * 1000000,
        Hover_Text = paste0(
          "Country: ", Country,
          "<br>Year: ", Year,
          "<br>Market: ", Market,
          "<br>Population: ", comma(round(Population, 0)),
          "<br>Sales per million population: $", comma(round(Sales_per_Million_Pop, 0))
        )
      )
    
    plot_ly(
      gdp_data,
      x = ~GDP_per_capita,
      y = ~Profit_Margin,
      type = "scatter",
      mode = "markers",
      color = ~Market,
      size = ~Population_Million,
      sizes = c(8, 45),
      text = ~Hover_Text,
      hovertemplate = paste(
        "%{text}",
        "<br>GDP per capita: $%{x:,.0f}",
        "<br>Profit Margin: %{y:.2%}",
        "<extra></extra>"
      )
    ) %>%
      layout(
        xaxis = list(title = "GDP per Capita, constant 2015 US$"),
        yaxis = list(title = "Profit Margin", tickformat = ".1%"),
        legend = list(title = list(text = "Market"))
      )
  })
  
  output$box_segment <- renderPlotly({
    box_data <- filtered_category_data() %>% filter(!is.na(Profit_Margin))
    
    plot_ly(box_data, x = ~Segment, y = ~Profit_Margin, type = "box",
            hovertemplate = "Segment: %{x}<br>Profit Margin: %{y:.2%}<extra></extra>") %>%
      layout(xaxis = list(title = "Segment"), yaxis = list(title = "Profit Margin", tickformat = ".1%"))
  })
  
  output$heatmap_internet <- renderPlotly({
    heat_data <- filtered_category_data() %>%
      filter(Internet_Group != "Missing") %>%
      group_by(Internet_Group, Category) %>%
      summarise(
        Profit_Margin = sum(Profit, na.rm = TRUE) / sum(Sales, na.rm = TRUE),
        .groups = "drop"
      )
    
    plot_ly(
      heat_data,
      x = ~Category,
      y = ~Internet_Group,
      z = ~Profit_Margin,
      type = "heatmap",
      colorbar = list(title = "Profit Margin", tickformat = ".0%"),
      hovertemplate = "Category: %{x}<br>Internet Group: %{y}<br>Profit Margin: %{z:.2%}<extra></extra>"
    ) %>%
      layout(
        xaxis = list(title = "Category"),
        yaxis = list(
          title = "Internet Usage Group",
          categoryorder = "array",
          categoryarray = c("Low internet usage", "Medium internet usage", "High internet usage")
        )
      )
  })
}

shinyApp(ui = ui, server = server)
