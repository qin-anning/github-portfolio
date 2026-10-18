"""Render aggregate evidence charts. Requires matplotlib: pip install matplotlib."""
import csv
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parent
plt.rcParams.update({'font.size': 10, 'axes.spines.top': False, 'axes.spines.right': False})


def read(path):
    with path.open(encoding='utf-8', newline='') as f:
        return list(csv.DictReader(f))


retail = ROOT / 'retail-profitability-dashboard'
rows = [r for r in read(retail / 'retail-evidence.csv') if r['dimension'] == 'Sub.Category']
fig, ax = plt.subplots(figsize=(10, 7))
values = [float(r['profit']) / 1000 for r in rows]
ax.barh([r['group'] for r in rows], values, color=['#c74747' if x < 0 else '#267b91' for x in values])
ax.axvline(0, color='#555555', linewidth=.8)
ax.set(xlabel='Net profit (USD thousands)', title='Tables is the only subcategory with negative aggregate profit')
fig.text(.12, .02, 'Source: coursework processed transactions, 2011–2014. Descriptive aggregates; no causal claim.', fontsize=8)
fig.tight_layout(rect=(0, .04, 1, 1))
(retail / 'assets').mkdir(exist_ok=True)
fig.savefig(retail / 'assets' / 'subcategory-profit.png', dpi=160)
plt.close(fig)

credit = ROOT / 'credit-risk-model-evaluation'
rows = sorted(read(credit / 'model-comparison.csv'), key=lambda r: float(r['AUC']))
fig, axes = plt.subplots(1, 2, figsize=(12, 7), sharey=True)
names = [r['model'] for r in rows]
for ax, metric, color in zip(axes, ['AUC', 'F1'], ['#267b91', '#8560a9']):
    ax.barh(names, [float(r[metric]) for r in rows], color=color)
    ax.set_xlabel(metric)
    ax.set_xlim(0, .65 if metric == 'AUC' else .22)
    ax.grid(axis='x', alpha=.2)
axes[0].axvline(.5, color='#c74747', linestyle='--', linewidth=1, label='AUC reference 0.5')
axes[0].legend(loc='lower right', fontsize=8)
fig.suptitle('Reported champion: highest AUC, but weak absolute discrimination')
fig.text(.08, .02, 'Source: course report table 2. Split, positive label and thresholds require confirmation. No retraining performed.', fontsize=8)
fig.tight_layout(rect=(0, .04, 1, .95))
(credit / 'assets').mkdir(exist_ok=True)
fig.savefig(credit / 'assets' / 'model-comparison.png', dpi=160)
plt.close(fig)
print('Rendered two evidence figures')
