# Retail evidence | 零售数据复核

Generated from the local coursework processed transaction file by `analyze_retail.py`. This recomputes aggregates; it does not run the Shiny application. Customer names, IDs and transaction records are excluded from the outputs. Currency follows the source coursework convention (USD); no currency conversion is performed.

本页为作品集新增分析，基于本地课程处理数据重新计算；不是实际经营收益或 Shiny 运行截图。输出仅包含汇总结果。

## Overall / 总览

- Transaction rows: **51,290**; country/order composite keys: **25,093**.
- Sales: **12,642,905.00**; net profit: **1,467,457.29**; aggregate margin: **11.61%**.
- Gross loss on negative-profit rows: **920,646.16**. This is not net loss or a recoverable-profit forecast.
- Orders containing any negative-profit row: **7,567 (30.16%)**.
- Orders with negative summed profit: **6,158 (24.54%)**.

“含亏损行的订单”和“整单净亏损”是两种口径。订单按 Country + Order.ID 识别；此分析在完整文件上计算，不能与局部筛选后的订单直接比较。

## Year

| Group | Rows | Sales | Net profit | Margin | Gross loss |
|---|---:|---:|---:|---:|---:|
| 2011 | 8,998 | 2,259,511.00 | 248,940.81 | 11.02% | 169,308.16 |
| 2012 | 10,962 | 2,677,493.00 | 307,415.28 | 11.48% | 195,342.34 |
| 2013 | 13,799 | 3,405,860.00 | 406,935.23 | 11.95% | 245,907.19 |
| 2014 | 17,531 | 4,300,041.00 | 504,165.97 | 11.72% | 310,088.47 |

## Sub.Category

| Group | Rows | Sales | Net profit | Margin | Gross loss |
|---|---:|---:|---:|---:|---:|
| Tables | 861 | 757,034.00 | -64,083.39 | -8.47% | 144,123.15 |
| Fasteners | 2,420 | 83,254.00 | 11,525.42 | 13.84% | 6,273.30 |
| Labels | 2,606 | 73,433.00 | 15,010.51 | 20.44% | 3,760.77 |
| Supplies | 2,425 | 243,090.00 | 22,583.26 | 9.29% | 18,184.43 |
| Envelopes | 2,435 | 170,926.00 | 29,601.12 | 17.32% | 10,863.57 |
| Furnishings | 3,170 | 385,609.00 | 46,967.43 | 12.18% | 28,514.50 |
| Art | 4,883 | 372,163.00 | 57,953.91 | 15.57% | 21,660.63 |
| Machines | 1,486 | 779,071.00 | 58,867.87 | 7.56% | 78,672.74 |
| Paper | 3,538 | 244,307.00 | 59,207.68 | 24.23% | 10,299.49 |
| Binders | 6,152 | 461,952.00 | 72,449.85 | 15.68% | 52,884.06 |
| Storage | 5,059 | 1,127,124.00 | 108,461.49 | 9.62% | 76,063.98 |
| Accessories | 3,075 | 749,307.00 | 129,626.31 | 17.30% | 39,857.50 |
| Chairs | 3,434 | 1,501,682.00 | 140,396.27 | 9.35% | 96,084.90 |
| Appliances | 1,755 | 1,011,081.00 | 141,680.59 | 14.01% | 63,991.69 |
| Bookcases | 2,411 | 1,466,559.00 | 161,924.42 | 11.04% | 101,446.30 |
| Phones | 3,357 | 1,706,874.00 | 216,717.01 | 12.70% | 96,417.66 |
| Copiers | 2,223 | 1,509,439.00 | 258,567.55 | 17.13% | 71,547.50 |

## Market

| Group | Rows | Sales | Net profit | Margin | Gross loss |
|---|---:|---:|---:|---:|---:|
| Canada | 384 | 66,932.00 | 17,817.39 | 26.62% | 0.00 |
| EMEA | 5,029 | 806,184.00 | 43,897.97 | 5.45% | 123,065.91 |
| Africa | 4,587 | 783,776.00 | 88,871.63 | 11.34% | 88,875.03 |
| LATAM | 10,294 | 2,164,687.00 | 221,643.49 | 10.24% | 165,817.16 |
| US | 9,994 | 2,297,354.00 | 286,397.02 | 12.47% | 156,131.29 |
| EU | 10,000 | 2,938,139.00 | 372,829.74 | 12.69% | 186,189.00 |
| APAC | 11,002 | 3,585,833.00 | 436,000.05 | 12.16% | 200,567.76 |

## Discount band

| Group | Rows | Sales | Net profit | Margin | Gross loss |
|---|---:|---:|---:|---:|---:|
| >40% | 6,961 | 846,335.00 | -627,411.02 | -74.13% | 627,831.48 |
| (20,40%] | 4,367 | 1,083,907.00 | -187,271.06 | -17.28% | 221,054.03 |
| (0,20%] | 10,953 | 3,719,929.00 | 511,444.10 | 13.75% | 71,760.65 |
| 0% | 29,009 | 6,992,734.00 | 1,770,695.27 | 25.32% | 0.00 |

## Interpretation / 如何用于决策

1. Use subcategory and market net profit to identify investigation candidates; use gross loss to locate negative lines hidden by profitable lines. Gross loss is the absolute sum of negative row profits, not the sum of negative group totals.
2. Discount bands describe observed transactions. Product mix, market and customer differences may explain associations. Removing a discount does not mechanically recover historical loss.
3. Check within comparable market/subcategory groups and inspect sample sizes before selecting a discount hypothesis. The next validation should measure profit per eligible customer/order as well as sales, conversion and returns; these latter outcomes are absent here.
4. Do not subtract Shipping.Cost again without verifying whether Profit already includes it. No additional shipping-cost deduction is used here.

按子品类和市场定位需要调查的范围，再检查同类商品内部的折扣差异；不把观察到的关联写成调整折扣后的收益承诺。汇总表未核验数据源许可，原始明细未随仓库发布。

## Reproduce / 复核

```sh
python analyze_retail.py /path/to/processed_superstore_clean.csv
```

Python 3.9+; no third-party packages. Required columns, finite numeric values, discount bounds and Row.ID uniqueness are checked. Sales and profit totals are reconciled for every grouping. No train/test modeling or causal experiment is performed.
