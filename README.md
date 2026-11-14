# Product portfolio | 产品作品集

Two independently completed coursework case studies prepared for data and AI product internships. They show how I frame a business decision, define metrics, examine data, and state the limits of a result. Original assignment briefs.

两项均由我独立完成，基于课程成果整理，面向数据产品和 AI 产品实习。重点展示业务问题、指标口径、数据分析和结果边界。
| Project / 项目 | Product question / 产品问题 | Evidence / 已有成果 |
|---|---|---|
| [Retail profitability dashboard](retail-profitability-dashboard/README.md) / 零售盈利看板 | Which markets and categories deserve attention? / 哪些市场与品类值得优先分析？ | R Shiny application, privacy-preserving aggregates and Power BI build assets / Shiny 看板、去标识化聚合数据及 Power BI 搭建资产 |
| [Credit risk model evaluation](credit-risk-model-evaluation/README.md) / 信用风险模型评估 | Can model scores help prioritize manual review? / 模型评分能否辅助人工复核排序？ | SAS model comparison, evaluation and 100-row scoring test / SAS 模型比较、评估与 100 条评分测试 |

These are course projects. 

以上均为课程项目。

## Start here / 展示入口

| Read / 阅读 | What it demonstrates / 展示能力 |
|---|---|
| [Retail evidence / 零售亏损分析](retail-profitability-dashboard/analysis-findings.md) | Recalculation of 51,290 rows; market, subcategory and discount comparisons; precise order-loss definitions / 数据复核、业务诊断与指标口径 |
| [Model decision review / 模型选型复盘](credit-risk-model-evaluation/model-decision-review.md) | Baseline comparison, metric trade-offs and proposed human-review validation / 模型判断与产品取舍 |
| [Portfolio walkthrough / 项目讲述](portfolio-walkthrough.md) | Evidence-backed project summaries and interview prompts / 有依据的项目描述与面试路径 |

## Reproduce the evidence / 复核图表

Retail aggregates can be rebuilt with the R script using the locally held processed data, while the committed aggregate CSVs let the R Shiny dashboard run without source transactions. The separate Python analysis can rebuild the two static figures:

```sh
python -m pip install matplotlib
python build_figures.py
```

The figure generator works without the private source transactions. The R Shiny app runs with R and the committed aggregate CSVs; source transactions are only needed to rebuild those aggregates. SAS training cannot be reproduced from this repository alone.

## Remaining work / 后续补充

- Build and save the documented Power BI report in Windows Power BI Desktop / 在 Windows Power BI Desktop 中完成并保存文档化的 Power BI 看板。
- Confirm source-data redistribution rights before publishing transaction-level data / 发布交易级数据前确认原始数据再分发权利。

Prepared locally in October 2026. / 2026 年 10 月本地整理。
