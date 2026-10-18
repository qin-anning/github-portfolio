"""Rebuild aggregate portfolio evidence without publishing customer-level data.

Usage: python analyze_retail.py /path/to/processed_superstore_clean.csv
Python 3.9+, standard library only. Outputs are written beside this script.
"""
import argparse
import csv
import math
from collections import defaultdict
from pathlib import Path


def summarize(rows):
    sales = sum(float(r['Sales']) for r in rows)
    profit = sum(float(r['Profit']) for r in rows)
    gross_loss = sum(max(-float(r['Profit']), 0) for r in rows)
    orders = defaultdict(float)
    any_loss = set()
    for r in rows:
        key = (r['Country'], r['Order.ID'])
        orders[key] += float(r['Profit'])
        if float(r['Profit']) < 0:
            any_loss.add(key)
    return dict(rows=len(rows), orders=len(orders), sales=sales, profit=profit,
                margin=profit / sales if sales else None, gross_loss=gross_loss,
                any_loss_orders=len(any_loss), net_loss_orders=sum(p < 0 for p in orders.values()))


def table(groups):
    lines = ['| Group | Rows | Sales | Net profit | Margin | Gross loss |',
             '|---|---:|---:|---:|---:|---:|']
    for name, s in groups:
        margin = f"{s['margin']:.2%}" if s['margin'] is not None else 'N/A'
        lines.append(f"| {name} | {s['rows']:,} | {s['sales']:,.2f} | {s['profit']:,.2f} | {margin} | {s['gross_loss']:,.2f} |")
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    args = parser.parse_args()
    with args.source.open(encoding='utf-8-sig', newline='') as f:
        reader = csv.DictReader(f)
        required = {'Country', 'Order.ID', 'Row.ID', 'Sales', 'Profit', 'Year', 'Sub.Category', 'Market', 'Discount'}
        if not required.issubset(reader.fieldnames or []):
            raise ValueError('Missing columns: ' + ', '.join(sorted(required - set(reader.fieldnames or []))))
        rows = list(reader)
    if not rows:
        raise ValueError('Empty source')
    if len({r['Row.ID'] for r in rows}) != len(rows):
        raise ValueError('Duplicate Row.ID; investigate before aggregation')
    for r in rows:
        for field in ('Sales', 'Profit', 'Discount'):
            if not math.isfinite(float(r[field])):
                raise ValueError('Non-finite value: ' + field)
        d = float(r['Discount'])
        if not 0 <= d <= 1:
            raise ValueError('Discount outside [0,1]')
        r['Discount band'] = '0%' if d == 0 else '(0,20%]' if d <= .2 else '(20,40%]' if d <= .4 else '>40%'
    total = summarize(rows)
    sections = []
    aggregates = []
    for dimension in ('Year', 'Sub.Category', 'Market', 'Discount band'):
        grouped = defaultdict(list)
        for r in rows:
            grouped[r[dimension]].append(r)
        results = [(name, summarize(items)) for name, items in grouped.items()]
        results.sort(key=(lambda x: x[0]) if dimension == 'Year' else (lambda x: x[1]['profit']))
        assert abs(sum(s['profit'] for _, s in results) - total['profit']) < .01
        assert abs(sum(s['sales'] for _, s in results) - total['sales']) < .01
        sections.append('## ' + dimension + '\n\n' + table(results))
        aggregates.extend(dict(dimension=dimension, group=name, **s) for name, s in results)
    out = Path(__file__).resolve().parent
    with (out / 'retail-evidence.csv').open('w', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=list(aggregates[0]))
        writer.writeheader()
        writer.writerows(aggregates)
    report = f'''# Retail evidence | 零售数据复核

Generated from the local coursework processed transaction file by `analyze_retail.py`. This recomputes aggregates; it does not run the Shiny application. Customer names, IDs and transaction records are excluded from the outputs. Currency follows the source coursework convention (USD); no currency conversion is performed.

本页为作品集新增分析，基于本地课程处理数据重新计算；不是实际经营收益或 Shiny 运行截图。输出仅包含汇总结果。

## Overall / 总览

- Transaction rows: **{total['rows']:,}**; country/order composite keys: **{total['orders']:,}**.
- Sales: **{total['sales']:,.2f}**; net profit: **{total['profit']:,.2f}**; aggregate margin: **{total['margin']:.2%}**.
- Gross loss on negative-profit rows: **{total['gross_loss']:,.2f}**. This is not net loss or a recoverable-profit forecast.
- Orders containing any negative-profit row: **{total['any_loss_orders']:,} ({total['any_loss_orders']/total['orders']:.2%})**.
- Orders with negative summed profit: **{total['net_loss_orders']:,} ({total['net_loss_orders']/total['orders']:.2%})**.

“含亏损行的订单”和“整单净亏损”是两种口径。订单按 Country + Order.ID 识别；此分析在完整文件上计算，不能与局部筛选后的订单直接比较。

'''
    report += '\n\n'.join(sections)
    report += '''

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
'''
    (out / 'analysis-findings.md').write_text(report, encoding='utf-8')
    print(f"Validated {len(rows):,} rows; wrote aggregate CSV and analysis-findings.md")


if __name__ == '__main__':
    main()
