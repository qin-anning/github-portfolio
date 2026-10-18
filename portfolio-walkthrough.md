# Portfolio walkthrough | 项目讲述

## Retail / 零售盈利诊断

**Project description / 项目描述：** 独立完成基于 R Shiny 的零售盈利与市场机会看板，整合交易数据和世界银行国家指标，支持按年份、市场、品类、客群与配送方式分析。作品集阶段使用 Python 复核 51,290 条交易行，生成年度、市场、子品类和折扣区间汇总，识别 Tables 子品类约 6.41 万美元净亏损，并区分含亏损行订单占比（30.16%）和整单净亏损占比（24.54%）。

Evidence: [application](retail-profitability-dashboard/app.R), [computed tables](retail-profitability-dashboard/analysis-findings.md), [analysis script](retail-profitability-dashboard/analyze_retail.py).

**Three-minute explanation / 三分钟讲述：**

1. 用户与问题：品类经理需要同时看增长和利润质量；销售增长不足以判断经营是否健康。
2. 方法：统一国家名称、关联国家年份指标、明确指标聚合层级，通过筛选和下钻定位需要调查的范围。
3. 结果：展示 Tables 净亏损、市场差异以及不同折扣区间的历史表现，不把它们解读为已证实的因果关系。
4. 复盘：订单中某一行亏损，不代表整单亏损。先明确口径，再解释比例。
5. 下一步：在相同市场和子品类内检查折扣差异，设计有对照的验证；实际转化与退货数据尚缺。

## Credit risk / 信用风险模型评估

**Project description / 项目描述：** 独立完成 SAS 信用风险分类模型比较，涵盖六类模型及修改配置，在 SAS Model Manager 注册选中模型并完成 100 条记录的评分测试。复盘冠军模型 AUC 0.5754、F1 0.0323 与约 70/30 类别分布的局限，提出按 5%、10%、20% 人工审核容量比较排序效果的验证方案。

Evidence: [reported metrics](credit-risk-model-evaluation/model-comparison.csv), [decision review](credit-risk-model-evaluation/model-decision-review.md). Capacity-based validation is proposed, not completed; the repository does not contain an independently runnable SAS training export.

**Questions to prepare / 面试准备：**

- 为什么不直接选准确率最高的模型？结合类别比例解释基线，并核实评价集上的确切比例。
- 为什么没有把神经网络描述为业务突破？相对逻辑回归的 AUC 差只有 0.0076，还缺少不确定性分析。
- 如果审核资源有限，先测什么？确认风险概率方向后，比较固定审核容量下的 precision、recall 与 lift。
- 100 条评分测试证明什么？证明课程评分流程能产出结果，不能证明真实部署或风险识别效果。

## Claims boundary / 描述边界

These descriptions combine original independent coursework with new portfolio analysis. They do not establish production deployment, revenue improvement, model-driven loss reduction or implemented search/recommendation/advertising systems. No hypothetical savings are presented as achieved results.

以上可以用于项目介绍；后续新增界面、审核策略和实验方案应继续明确标注“拟议”或“已实现”。
