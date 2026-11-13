# Build privacy-preserving, aggregated portfolio data from the original ETW2001 work.
# Input remains read-only. The output excludes Customer.ID, Customer.Name and Order.ID.

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1) stop("Usage: Rscript scripts/prepare_portfolio_data.R /path/to/processed_superstore_clean.csv")

source_path <- normalizePath(args[[1]], mustWork = TRUE)
source_dir <- dirname(source_path)
output_dir <- file.path(getwd(), "data")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

context_path <- file.path(source_dir, "processed_country_year_dashboard_data.csv")
if (!file.exists(context_path)) stop("Expected processed_country_year_dashboard_data.csv next to the source file.")
market_context <- read_csv(context_path, show_col_types = FALSE) %>%
  transmute(
    Country, Year = as.integer(Year), Market, Total_Sales = as.numeric(Total_Sales),
    Total_Profit = as.numeric(Total_Profit), Profit_Margin = as.numeric(Profit_Margin),
    GDP_per_capita = as.numeric(GDP_per_capita), Population = as.numeric(Population),
    Internet_Usage = as.numeric(Internet_Usage), Internet_Group
  )

transactions <- read_csv(source_path, show_col_types = FALSE) %>%
  transmute(
    Year = as.integer(Year), Market, Country, Category,
    Sub_Category = `Sub.Category`, Segment, Ship_Mode = `Ship.Mode`,
    Sales = as.numeric(Sales), Profit = as.numeric(Profit), Quantity = as.numeric(Quantity),
    Discount = as.numeric(Discount), Shipping_Cost = as.numeric(`Shipping.Cost`),
    Shipping_Days = as.numeric(Shipping_Days)
  ) %>%
  left_join(market_context %>% select(Country, Year, Market, Internet_Group), by = c("Country", "Year", "Market"))

market_category_metrics <- transactions %>%
  group_by(Year, Market, Category, Sub_Category, Segment, Ship_Mode, Internet_Group) %>%
  summarise(
    Transaction_Lines = n(), Total_Sales = sum(Sales, na.rm = TRUE),
    Total_Profit = sum(Profit, na.rm = TRUE), Total_Quantity = sum(Quantity, na.rm = TRUE),
    Total_Shipping_Cost = sum(Shipping_Cost, na.rm = TRUE),
    Total_Shipping_Days = sum(Shipping_Days, na.rm = TRUE),
    Average_Discount = mean(Discount, na.rm = TRUE), Loss_Lines = sum(Profit < 0, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(market_category_metrics, file.path(output_dir, "market_category_metrics.csv.gz"))
write_csv(market_context, file.path(output_dir, "market_context.csv"))
tables_profit <- market_category_metrics %>% filter(Sub_Category == "Tables") %>% summarise(profit = sum(Total_Profit), .groups = "drop") %>% pull(profit)
message("Wrote aggregated portfolio tables. Source transaction lines: ", nrow(transactions))
message("Tables total profit: $", format(round(tables_profit, 2), big.mark = ","))
