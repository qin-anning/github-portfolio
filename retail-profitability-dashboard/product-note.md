# Decision workflow | 决策流程

## Audience / 用户

Commercial analysts and category managers comparing growth with profit quality. / 比较增长与利润质量的商业分析师及品类经理。

## Three decisions / 三类决策

1. **Where to investigate?** Sort country-year results by sales and margin; use GDP, population and internet use only as context. / **调查哪里？** 按国家年份对比销售和利润率，人均 GDP、人口和互联网使用率仅作为背景。
2. **What is driving losses?** Drill into category, segment and shipping mode; inspect discounts and shipping costs before proposing changes. / **亏损来自哪里？** 下钻品类、客群和配送方式，先检查折扣与运费，再提出调整。
3. **What should be tested?** Draft a discount or fulfillment hypothesis, define a control group and measure margin, sales and customer effects. / **下一步验证什么？** 提出折扣或履约假设，设置对照并衡量利润率、销售和客户影响。

## Metric contract / 指标约定

| Metric / 指标 | Definition / 定义 | Caveat / 限制 |
|---|---|---|
| Profit margin / 利润率 | Sum of profit divided by sum of sales in selected records / 选中记录的利润总额除以销售总额 | Exclude zero-sales groups / 排除零销售额分组 |
| Sales and profit trend / 销售与利润趋势 | Yearly sums under active filters / 当前筛选条件下的年度总额 | Descriptive, not causal / 描述性，不代表因果 |
| Shipping days / 配送天数 | Mean of grouped averages in current app / 当前应用为分组均值的平均值 | Not an order-weighted mean; refine before business use / 非订单加权均值，业务使用前应改进 |
| Loss order rate / 亏损订单率 | Share of orders with any loss-making row in a country-year / 国家年份内存在亏损行的订单占比 | Not currently displayed in UI; aggregation depends on order ID consistency / 当前界面未展示，依赖订单编号一致性 |

## Next iteration / 下一轮改进

Add sample sizes and coverage indicators beside market comparisons; make every metric's grain explicit; test hypotheses with transactions or controlled experiments. These are proposals, not completed features.

在市场比较旁增加样本量与覆盖率；明确每项指标的聚合层级；用交易明细或对照实验验证假设。这些是后续设计，并非已完成功能。
