# Demo Output — Modeling Engine

Generated from 90 days of demo data (2026-01-01 to 2026-03-31) using the TaiYiYuan modeling pipeline.

## Output Files

### Core Engine (`modeling/engine.py`)

| File | Command | Description |
|------|---------|-------------|
| `daily-digest.txt` | `daily_digest --date 2026-03-10` | Single-day summary: 5 meals (2,390 kcal, 160g protein), 1 weightlifting session (63 min, RPE 8), 7 body metrics, 5 active supplements, 1 active trial |
| `weekly-report.txt` | `weekly_report --start 2026-03-03 --end 2026-03-09` | Week-long report with diet/exercise summaries, metric trends, biomarkers, anomaly scan, trial updates |
| `rolling-stats.txt` | `rolling_stats --metric weight` | 7/30/90-day rolling statistics for weight: 90-day mean 74.12 kg, current 71.59 kg (-3.42% vs mean), consistent downward trend |
| `trend-analysis.txt` | `trend --metric weight --days 90` | Linear trend: -0.039 kg/day, R²=0.84, p<0.001 — statistically significant weight loss of ~4.6% over 90 days |
| `anomaly-detection.txt` | `anomaly_detect --metric weight --days 90` | 9 anomalous low-weight readings detected (z-scores -2.09 to -2.96), clustered in mid-Feb and mid-Mar, consistent with accelerating downtrend |
| `nutrient-summary.txt` | `nutrient_summary --days 30` | 30-day nutrition: avg 2,319 kcal/day, 152g protein, 252g carbs, 79g fat, 14g fiber across 116 meals |
| `exercise-summary.txt` | `exercise_summary --days 30` | 30-day exercise: 18 sessions, 1,022 total minutes, weightlifting/running/flexibility, 49,780 kg volume load |
| `periodicity-detection.txt` | `periodicity --metric sleep_quality --days 90` | Day-of-week and monthly ANOVA for sleep quality (no significant periodic patterns detected in this dataset) |

### Pattern Detection (`modeling/patterns.py`)

| File | Command | Description |
|------|---------|-------------|
| `pattern-scan.txt` | `scan --days 90` | Pairwise correlation scan across all metrics with Benjamini-Hochberg FDR correction. Many significant correlations found (140 KB of results) |
| `cross-module-scan.txt` | `cross_module --days 90` | Cross-module relationships: diet calories → sleep duration (r=0.40, lag 1d, p=0.0001), protein → sleep duration (r=0.33, lag 1d), exercise → body composition correlations |
| `trial-candidates.txt` | `trial_candidates` | N-of-1 trial nominations based on effect size, significance, and data availability. Top candidates involve diet-body metric relationships |

### Causal Inference (`modeling/causal.py`)

| File | Command | Description |
|------|---------|-------------|
| `causal-trial-analysis.txt` | `analyze_trial --trial_id 1` | Full analysis of the Protein-Sleep Quality Trial (ABA design): large effect (d=0.94, p=0.022), sleep quality improved from 6.98 to 7.64 on high-protein dinner. ITS shows level change +0.84 (p=0.11). Confidence rated "low" due to confounders (calories, exercise, weight all changed during trial) |
| `power-analysis.txt` | `power --metric sleep_quality --baseline_days 60` | MDE = 0.36 SD (0.28 points) with 60 baseline observations. 32 observations per phase recommended for medium effect detection |
| `confounders-check.txt` | `confounders --trial_id 1` | Confounding analysis: blood pressure stable, but HRV improved (+16%), resting HR decreased (-4%), weight decreased, calories increased 32%, exercise minutes nearly doubled — multiple confounders flagged |

### Database Interface (`data/db.py`)

| File | Description |
|------|-------------|
| `db-query-demo.txt` | Demonstrates the Python DB API: meal logging with Chinese/English descriptions, daily weight tracking, 5 active supplements (creatine, Mg, multivitamin, omega-3, vitamin D3), 2 N-of-1 trials, 75 biomarker readings across 33 markers, exercise logging. Database totals: 349 diet entries, 1,126 ingredients, 65 exercise sessions, 192 exercise details, 571 body metrics, 75 biomarkers |

## Key Findings

1. **Weight trend**: Strong downward trend (-0.039 kg/day, R²=0.84) from ~75.9 to ~71.6 kg over 90 days
2. **Diet-sleep link**: Higher calorie/protein intake correlates with better sleep duration next day (r=0.40, lag 1d)
3. **Protein-sleep trial**: Large effect size (d=0.94) but confounded by simultaneous changes in calories (+32%), exercise (+86%), and other metrics
4. **Anomaly clusters**: Weight anomalies cluster in mid-Feb and mid-Mar, suggesting periodic acceleration phases
5. **Vitamin D deficiency**: Baseline 22 ng/mL (below 30 reference), supplementation started Feb 2026
