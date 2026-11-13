# 数据字典与指标口径

`market_category_metrics.csv.gz` 的粒度为年、市场、品类、子品类、客群、运输方式和互联网使用分组。它只含聚合记录，未发布客户姓名、客户 ID、订单 ID 或城市级信息。R 的 `readr::read_csv()` 可直接读取该压缩文件。

| 字段 | 定义 |
| --- | --- |
| `Transaction_Lines` | 分组包含的原始交易行数。 |
| `Total_Sales` / `Total_Profit` | 销售额与利润之和，美元。 |
| `Total_Shipping_Days` | 订单到发货天数之和。 |
| `Average_Discount` | 分组原始交易行的平均折扣率。 |
| `Loss_Lines` | 利润小于零的交易行数。 |

`market_context.csv` 的粒度为国家、年和市场，包含原作业使用的 World Bank 人均 GDP、人口、互联网使用率及其分组。

- 利润率 = `SUM(Total_Profit) / SUM(Total_Sales)`。
- 平均运输天数 = `SUM(Total_Shipping_Days) / SUM(Transaction_Lines)`。
- 亏损交易占比 = `SUM(Loss_Lines) / SUM(Transaction_Lines)`。

利润率和平均运输天数均按上述加权公式计算，不是按已聚合行做简单平均。
