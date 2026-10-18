# Retail Profitability Dashboard | 零售盈利与市场机会看板

**Decision question:** Where should a retailer investigate expansion or operational problems when revenue growth alone hides margin risk? This coursework dashboard joins Superstore transactions with World Bank GDP per capita, population and internet-use indicators for 2011–2014. It lets an analyst filter by year, market, category, customer segment and shipping mode.

**决策问题：** 当销售额增长掩盖利润率风险时，零售商应该优先调查哪些市场和品类？本课程项目将 2011–2014 年 Superstore 交易数据与世界银行人均 GDP、人口、互联网使用率指标结合，支持按年份、市场、品类、客户群体和配送方式筛选。

## What I built / 项目内容

- Interactive R Shiny dashboard with five visualizations: sales and profit trend, category margin, country profitability versus GDP and population, segment margin distribution, and digital-readiness by category. / 包含五组可交互图表的 R Shiny 看板。
- Country-name normalization, country-year joins, derived profitability and shipping metrics. / 国家名称统一、国家年份关联、利润和配送指标计算。
- A written analysis translating patterns into questions for pricing, discounts, shipping and market selection. / 将图表发现转化为定价、折扣、配送及市场选择的待验证决策。

**Authorship:** I completed this coursework independently. / **完成方式：** 本课程项目由我独立完成。

**Coursework result:** the report recorded sales growing from about $2.26m in 2011 to $4.30m in 2014 while overall profit margin moved from about 11.02% to 11.72%. Furniture had a lower aggregate margin than Technology and Office Supplies; Tables stood out as a loss-making subcategory. These are descriptive results from the assignment dataset, not causal or live-business impact claims.

**课程结果：** 报告记录的销售额从 2011 年约 226 万美元增长到 2014 年约 430 万美元，而整体利润率约从 11.02% 变为 11.72%。家具品类总体利润率低于科技产品和办公用品，Tables 子品类表现为亏损。以上是课程数据的描述性分析，并非因果结论或线上收益。

## Product interpretation / 产品解读

The primary user is a commercial analyst or category manager. The dashboard supports a review workflow: choose a period and market, compare aggregate margin with sales growth, drill into category and segment, then inspect country-level context. A decision to expand, cut discounts or change fulfillment would still require sample-size checks and controlled validation.

主要用户是商业分析师或品类经理。使用路径是选择时间与市场、比较增长和总体利润率、下钻品类与客群，再查看国家层面的外部环境。是否扩张、调整折扣或改变履约方式，仍需要样本量检查和进一步验证。

**Metric definition / 指标口径:** profit margin = sum(profit) / sum(sales), calculated over the active filters. `Loss_Order_Rate` is the share of orders containing at least one loss-making row in each country-year aggregate. The country chart now follows all active filters. These two items were corrected during portfolio preparation; the source coursework report has not been retroactively changed.

**Limitations / 局限：** Internet usage and GDP are country-level context, not proof that they cause retail profitability. The dashboard contains no experiment or user behavior data. Country matching and missing external indicators require review before business use. The boxplot reflects grouped data, so its distribution is over grouped cells rather than raw orders.

## Run locally / 本地运行

Requires R and packages `shiny`, `tidyverse`, `readxl`, `plotly`, `scales`. Place these source files next to `app.R`: `superstore.xlsx`, `external_gdp_per_capita_worldbank.xls`, `external_population_worldbank.xls`, and `external_internet_usage_worldbank.xls`. The original data is not bundled here pending redistribution review. Then run:

```r
install.packages(c("shiny", "tidyverse", "readxl", "plotly", "scales"))
shiny::runApp(".")
```

World Bank indicator codes: `NY.GDP.PCAP.KD`, `SP.POP.TOTL`, `IT.NET.USER.ZS`. The app expects the World Bank Excel export format with metadata in the first three rows and 2011–2014 columns. The Superstore file must have the columns referenced in `app.R`.

运行需 R 及上述五个包。将四个源文件放在 `app.R` 同目录，再执行命令。数据暂未打包；世界银行文件需保留前 3 行元信息及 2011–2014 年列。

**Publication note / 发布说明:** no live deployment or real-world outcome is asserted. / 本项目不宣称已上线或产生实际业务收益。

See [decision workflow](product-note.md) for the metric contract and proposed next steps. / 指标口径与后续设计见[决策流程](product-note.md)。
