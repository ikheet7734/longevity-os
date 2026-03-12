# Longevity OS 太医院

**Personal longevity optimization system — 个人长寿优化系统**

A scientifically rigorous health tracking and N-of-1 self-experimentation platform, modeled after the historical Imperial Medical Academy (太医院). Built as a Claude Code multi-agent skill system with 10 specialized AI agents, a statistical modeling engine, and an imperial Chinese–themed dashboard.

All data stays local. No cloud. SQLite database, Python server, static HTML dashboard.

<p align="center">
  <img src="docs/screenshots/dashboard-hero.png" alt="Longevity OS Dashboard — Header and Summary" width="100%" />
</p>

---

## Architecture

Longevity OS uses a **multi-agent orchestration pattern** inspired by the historical Imperial Medical Academy's departmental structure. The 御医 (Imperial Physician) orchestrator dispatches work to 9 specialized sub-agents, each with domain-specific knowledge and constraints.

<p align="center">
  <img src="docs/architecture.svg" alt="System Architecture" width="100%" />
</p>

### Agent Dispatch Flow

When a user makes a request, the orchestrator classifies intent, dispatches to the appropriate department agent(s), collects structured results, and responds. For N-of-1 trials, a two-agent adversarial review process ensures safety and scientific rigor.

<p align="center">
  <img src="docs/agent-flow.svg" alt="Agent Dispatch Flow" width="100%" />
</p>

### The Imperial Court (十官)

<table>
<tr>
<td align="center" width="20%"><img src="docs/characters/yuyi.svg" alt="御医" width="80"/><br/><b>御医</b><br/>Orchestrator</td>
<td align="center" width="20%"><img src="docs/characters/shiyi.svg" alt="食医" width="80"/><br/><b>食医科</b><br/>Diet</td>
<td align="center" width="20%"><img src="docs/characters/daoyin.svg" alt="导引" width="80"/><br/><b>导引科</b><br/>Exercise</td>
<td align="center" width="20%"><img src="docs/characters/zhenmai.svg" alt="诊脉" width="80"/><br/><b>诊脉科</b><br/>Body Metrics</td>
<td align="center" width="20%"><img src="docs/characters/yanfang.svg" alt="验方" width="80"/><br/><b>验方科</b><br/>Biomarkers</td>
</tr>
<tr>
<td align="center"><img src="docs/characters/bencao.svg" alt="本草" width="80"/><br/><b>本草科</b><br/>Supplements</td>
<td align="center"><img src="docs/characters/shixiao.svg" alt="试效" width="80"/><br/><b>试效科</b><br/>Trials</td>
<td align="center"><img src="docs/characters/yuanpan.svg" alt="院判" width="80"/><br/><b>院判</b><br/>Trial Design</td>
<td align="center"><img src="docs/characters/yizheng.svg" alt="医正" width="80"/><br/><b>医正</b><br/>Safety Review</td>
<td align="center"><img src="docs/characters/baogao.svg" alt="报告" width="80"/><br/><b>报告科</b><br/>Reports</td>
</tr>
</table>

---

## Dashboard

The dashboard is a zero-dependency local HTML file served by a Python stdlib HTTP server. Imperial Chinese aesthetic with dark wood panels, gold accents, and teal data visualizations.

### Today's Summary — 今日总览

Four summary cards showing calories, protein, exercise minutes, and sleep hours with 7-day averages and sparklines.

<p align="center">
  <img src="docs/screenshots/dashboard-summary.png" alt="Today's Summary Cards" width="100%" />
</p>

### Nutrition — 营养 (食医科)

Stacked bar chart of daily macronutrient breakdown (protein, carbs, fat) with interactive meal log.

<p align="center">
  <img src="docs/screenshots/dashboard-nutrition.png" alt="Nutrition Chart" width="100%" />
</p>

### Body Metrics — 体征 (诊脉科)

Time series charts for weight, heart rate, HRV, sleep, and blood pressure with 7-day moving averages and anomaly detection.

<p align="center">
  <img src="docs/screenshots/dashboard-metrics.png" alt="Body Metrics Chart" width="100%" />
</p>

### Exercise — 导引 (导引科)

Activity heatmap (GitHub-style) and recent workout log with duration, distance, heart rate, and RPE.

<p align="center">
  <img src="docs/screenshots/dashboard-exercise.png" alt="Exercise Heatmap" width="100%" />
</p>

### Supplement Stack — 本草 (本草科)

Current supplement stack with dosage, frequency, timing, and days active.

<p align="center">
  <img src="docs/screenshots/dashboard-supplements.png" alt="Supplement Stack" width="100%" />
</p>

### Biomarker Trends — 验方 (验方科)

Lab result time series with reference ranges for HbA1c, LDL, HDL, CRP, glucose, triglycerides, TSH, and Vitamin D.

<p align="center">
  <img src="docs/screenshots/dashboard-biomarkers.png" alt="Biomarker Trends" width="100%" />
</p>

### Active Trials — 试效 (试效科)

N-of-1 trial progress tracking with phase indicators (baseline → intervention → washout) and completion percentage.

<p align="center">
  <img src="docs/screenshots/dashboard-trials.png" alt="Active Trials" width="100%" />
</p>

### Modeling Engine — 洞察

AI-generated insights with confidence levels, effect sizes, and color-coded severity (anomaly, correlation, trend, recommendation, routine).

<p align="center">
  <img src="docs/screenshots/dashboard-insights.png" alt="Modeling Engine Insights" width="100%" />
</p>

---

## Quick Start

```bash
# 1. Initialize the database
cd ~/Desktop/Projects/2026/longevity-os
python scripts/setup.py

# 2. Start the dashboard server
python dashboard/server.py

# 3. Open http://localhost:8420
```

The primary interface is voice/text through Claude Code using the `/longevity` or `/taiyiyuan` skill. The dashboard is a read-only visualization layer.

---

## Usage Examples

**Log a meal:**
> "Had grilled salmon with brown rice and broccoli for lunch"

**Log exercise:**
> "Ran 5K in 28 minutes, felt good"

**Log a metric:**
> "Weight 72.1 kg this morning"

**Check status:**
> "Daily summary" or "How's my protein this week?"

**Start a trial:**
> "Propose an experiment" — the system detects patterns, designs an N-of-1 trial, runs adversarial safety review, and presents for approval.

---

## Modules

| Module | Department | Chinese | Role |
|--------|------------|---------|------|
| Diet | 食医科 | 食医 | Meal logging, USDA nutrition lookup, recipe library |
| Exercise | 导引科 | 导引 | Workout logging, volume tracking, activity heatmaps |
| Body Metrics | 诊脉科 | 诊脉 | Weight, BP, sleep, HRV, custom metrics |
| Biomarkers | 验方科 | 验方 | Lab results with clinical and optimal reference ranges |
| Supplements | 本草科 | 本草 | Supplement stack, interaction checking, compliance |
| Trials | 试效科 | 试效 | N-of-1 trial monitoring and analysis |
| Trial Design | 院判 | 院判 | Evidence-based trial protocol design |
| Safety Review | 医正 | 医正 | Independent adversarial review of trial proposals |
| Reports | 报告科 | 报告 | Daily digests, weekly reports, trend summaries |

### Modeling Engine

The statistical modeling engine runs behind all modules:

- **Rolling statistics**: 7d, 30d, 90d averages for all tracked metrics
- **Anomaly detection**: Flags values >2 SD from rolling mean
- **Trend analysis**: Linear regression over 30d/90d windows
- **Cross-module correlations**: Pairwise analysis with lag (up to 7 days) and Benjamini-Hochberg correction
- **Causal inference**: Interrupted time series analysis, Bayesian structural time series with custom Kalman filter
- **Power analysis**: Estimates minimum detectable effect size given within-person variance

---

## File Structure

```
longevity-os/
├── SKILL.md                          # 御医 orchestrator (main entry point)
├── agents/                           # Department agent system prompts
│   ├── shiyi.md                      # 食医科 (Diet)
│   ├── daoyin.md                     # 导引科 (Exercise)
│   ├── zhenmai.md                    # 诊脉科 (Body Metrics)
│   ├── yanfang.md                    # 验方科 (Biomarkers)
│   ├── bencao.md                     # 本草科 (Supplements)
│   ├── shixiao.md                    # 试效科 (Trial Monitoring)
│   ├── yuanpan.md                    # 院判 (Trial Design)
│   ├── yizheng.md                    # 医正 (Safety Review)
│   └── baogao.md                     # 报告科 (Reports)
├── dashboard/
│   ├── dashboard.html                # Imperial-themed single-file dashboard
│   └── server.py                     # Python stdlib HTTP server (8 API endpoints)
├── data/
│   ├── schema.sql                    # SQLite schema (17 tables, 25+ indexes)
│   ├── db.py                         # Database interface (TaiYiYuanDB class)
│   ├── nutrition_api.py              # USDA + Open Food Facts nutrition lookup
│   └── migrations/
│       └── 001_init.sql              # Initial schema migration
├── modeling/
│   ├── engine.py                     # Core statistical engine
│   ├── patterns.py                   # Pattern detection & correlation scanner
│   └── causal.py                     # Causal inference (ITS, Bayesian STS)
├── scripts/
│   ├── setup.py                      # Database & directory initialization
│   ├── migrate.py                    # Schema migration runner
│   ├── backup.py                     # Automated backup (30 daily + 12 monthly)
│   ├── export.py                     # JSON/CSV data export
│   ├── import_labs.py                # Lab report parser (~150 marker aliases)
│   └── import_apple_health.py        # Apple Health XML importer
└── docs/
    ├── architecture.svg              # System architecture diagram
    ├── agent-flow.svg                # Agent dispatch flow diagram
    ├── characters/                   # Chibi imperial character illustrations
    └── screenshots/                  # Dashboard screenshots
```

---

## Data Privacy

All health data is stored in a local SQLite database (`taiyiyuan.db`) with file permissions restricted to the owner (`0600`). No data is transmitted to external services. Nutrition lookups use only ingredient names (never personal health context). The dashboard server binds to `127.0.0.1` only and is not accessible from other machines.

---

## Tech Stack

- **AI**: Claude Code multi-agent skill system (10 agents)
- **Database**: SQLite with WAL journal mode
- **Server**: Python stdlib HTTP server (zero dependencies)
- **Dashboard**: Single HTML file, Chart.js 4.x
- **Modeling**: Python (scipy, statsmodels, numpy, pandas)
- **Nutrition API**: USDA FoodData Central + Open Food Facts
