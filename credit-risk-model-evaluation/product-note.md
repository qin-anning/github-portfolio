# Human review concept | 人工审核产品设想

This is a **proposed extension** to the coursework, not an implemented product. / 这是基于课程结果的**新增方案**，尚未实现。

## User and job / 用户与任务

A credit reviewer has limited time and needs to choose which applications warrant closer inspection. A score can be useful only if it improves that ordering over simple baselines at the team's actual review capacity.

信贷审核人员时间有限，需要判断哪些申请值得优先复核。只有在真实审核容量下，排序效果优于简单基线时，模型评分才有产品价值。

## Minimum validation / 最小验证

1. Confirm which value of `kredit` represents risk and which probability SAS exported. / 核对风险标签和 SAS 概率字段方向。
2. Use a held-out test set. Report precision and recall for the top 5%, 10% and 20% review queues, alongside the share of risky applications found. / 用独立测试集报告前 5%、10%、20% 审核队列的 precision、recall 和风险覆盖率。
3. Compare against random ordering, majority-class predictions and a logistic-regression ranking baseline. / 与随机排序、多数类预测、逻辑回归排序比较。
4. Review false positives, false negatives, fairness and stability before choosing any threshold. / 决定阈值前检查误报、漏报、公平性和稳定性。

## Proposed interface / 拟议界面

The queue would show a case ID, score band, relevant application facts and a reviewer decision field. A reviewer could open supporting details, record an override reason and request additional information. Monitoring would track review throughput, risk capture and appeal or override patterns. No automatic rejection is proposed.

审核队列可展示案件编号、评分区间、相关申请信息和审核决定字段。审核人员可查看详细资料、记录改判原因或索取材料；监控审核量、风险覆盖和申诉/改判情况。这里没有自动拒绝功能。

The course's AUC of 0.5754 and F1 of 0.0323 mean this is a discovery concept, not a deployment recommendation. / 课程模型的 AUC 0.5754 和 F1 0.0323 意味着这只是探索方案，不是上线建议。
