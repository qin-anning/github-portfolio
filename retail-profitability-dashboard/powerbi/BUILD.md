# Power BI 看板搭建

在 Power BI Desktop 创建一个名为 `SourceFolder` 的文本参数，值为本仓库 `data` 文件夹的绝对路径。然后依次打开“转换数据 → 高级编辑器”，粘贴 `queries/MarketCategoryMetrics.pq` 和 `queries/MarketContext.pq`。前者会直接读取压缩的聚合 CSV，后者读取市场背景 CSV；无需手工解压数据。

将两个查询分别命名为 `MarketCategoryMetrics` 与 `MarketContext`。`Year` 应为整数；销售额、利润和运输成本应为货币或小数；人口和交易行数应为整数。

将 [measures.dax](measures.dax) 中的度量创建在 `MarketCategoryMetrics` 表。不要把利润率或平均运输天数改为简单平均。

## 页面 1：经营总览

- KPI：Total Sales、Total Profit、Profit Margin、Average Shipping Days、Loss Transaction Rate。
- 折线图：Year × Total Sales / Total Profit。
- 柱状图：Category × Profit Margin。
- 切片器：Year、Market、Category、Segment、Ship_Mode。

## 页面 2：品类与亏损诊断

- 条形图：Sub_Category × Total Profit，按利润升序。
- 矩阵：Market × Category，显示销售额、利润、利润率与亏损交易占比。
- 散点图：Average Discount × Profit Margin，大小为 Total Sales，颜色为 Category。
- Tables Profit 卡片用于提出进一步调查，不应被解释为因果结论。

## 页面 3：市场背景

- `MarketContext`：GDP_per_capita 为横轴、Profit_Margin 为纵轴、Population 为大小、Market 为图例、Country 为详情。
- `Internet_Group × Category` 热图可直接使用 `MarketCategoryMetrics` 表中的 `Internet_Group` 字段。

本仓库没有提交未经 Power BI Desktop 实际打开验证的 `.pbix` 二进制文件。请在 Windows Power BI Desktop 按上述步骤完成并保存为 `Superstore_Market_Profitability_Dashboard.pbix`。
