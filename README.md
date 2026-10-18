# Product portfolio | 产品作品集

Two independently completed coursework case studies prepared for data and AI product internships. They show how I frame a business decision, define metrics, examine data, and state the limits of a result. Original assignment briefs and grading materials are excluded.

两项均由我独立完成，基于课程成果整理，面向数据产品和 AI 产品实习。重点展示业务问题、指标口径、数据分析和结果边界。已排除课程题目及评分材料。

| Project / 项目 | Product question / 产品问题 | Evidence / 已有成果 |
|---|---|---|
| [Retail profitability dashboard](retail-profitability-dashboard/README.md) / 零售盈利看板 | Which markets and categories deserve attention? / 哪些市场与品类值得优先分析？ | R Shiny application, Superstore and World Bank analysis / Shiny 看板及多源数据分析 |
| [Credit risk model evaluation](credit-risk-model-evaluation/README.md) / 信用风险模型评估 | Can model scores help prioritize manual review? / 模型评分能否辅助人工复核排序？ | SAS model comparison, evaluation and 100-row scoring test / SAS 模型比较、评估与 100 条评分测试 |

These are course projects. They do not claim production deployment, live business impact, or experience building a search, advertising, or recommendation system.

以上均为课程项目，不宣称生产部署、线上业务收益或已实现搜广推系统。

## Start here / 展示入口

| Read / 阅读 | What it demonstrates / 展示能力 |
|---|---|
| [Retail evidence / 零售亏损分析](retail-profitability-dashboard/analysis-findings.md) | Recalculation of 51,290 rows; market, subcategory and discount comparisons; precise order-loss definitions / 数据复核、业务诊断与指标口径 |
| [Model decision review / 模型选型复盘](credit-risk-model-evaluation/model-decision-review.md) | Baseline comparison, metric trade-offs and proposed human-review validation / 模型判断与产品取舍 |
| [Portfolio walkthrough / 项目讲述](portfolio-walkthrough.md) | Evidence-backed project summaries and interview prompts / 有依据的项目描述与面试路径 |

## Reproduce the evidence / 复核图表

Retail aggregates can be rebuilt using Python 3.9+ and the locally held processed data; see the project analysis script. To rebuild the two figures from the committed aggregate CSVs:

```sh
python -m pip install matplotlib
python build_figures.py
```

The figure generator works without the private source transactions. Full Shiny execution still requires R and the four source files listed in the retail README. SAS training cannot be reproduced from this repository alone.

## Remaining work / 后续补充

- Add one screenshot of the dashboard and selected figures from the model report after removing student ID / 脱敏后补充看板截图与模型图表。
- Confirm source-data redistribution rights / 确认原始数据能否再分发。
- Verify the Shiny app with R and the four source files / 使用 R 和四个源文件运行看板。

Prepared locally in October 2026. / 2026 年 10 月本地整理。
