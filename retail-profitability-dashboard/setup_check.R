# Run this first in RStudio to check packages and files.
required_packages <- c("shiny", "tidyverse", "readxl", "plotly", "scales")
missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]
if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}

files_needed <- c(
  "superstore.xlsx",
  "external_gdp_per_capita_worldbank.xls",
  "external_population_worldbank.xls",
  "external_internet_usage_worldbank.xls",
  "app.R"
)

print(file.exists(files_needed))
print(list.files())
