<p align="center">
  <img src="docs/logo.png" alt="Longevity OS 太医院" width="280" />
</p>

<h1 align="center">Longevity OS 太医院</h1>
<p align="center"><b>Agentic Longevity OS · Works with Claude Code & OpenClaw</b></p>

<p align="center">
Your personal team of AI physicians that tracks your health,<br/>
finds hidden patterns across your data, searches the scientific literature,<br/>
and proposes rigorous self-experiments — then analyzes the results.<br/>
<b>10 markdown agent prompts + MCP tools = runs on Claude Code, OpenClaw, or any MCP-compatible agent.</b>
</p>

<p align="center">
  <a href="#why-this-exists">Why</a> · <a href="#how-it-works">How It Works</a> · <a href="#conversation-examples">Examples</a> · <a href="#openclaw-compatibility">OpenClaw</a> · <a href="#dashboard">Dashboard</a> · <a href="#quick-start">Quick Start</a> · <a href="README.zh.md">中文文档</a>
</p>

<p align="center">
  <img src="docs/screenshots/dashboard-hero.png" alt="Longevity OS Dashboard" width="100%" />
</p>

---

## Why This Exists

Most health apps are **trackers** — they record what you tell them and show you charts. They don't think. They don't connect the dots between your sleep, your diet, and your lab results. They don't read papers to figure out why your CRP is trending up.

Longevity OS is different. It's an **agentic system** — a team of 10 specialized AI agents that actively work on your health data:

| What exists today | What Longevity OS does |
|---|---|
| Log meals manually | Logs meals, estimates nutrients via USDA API, learns your recipes |
| See a weight chart | Detects that your weight drops faster on weeks with >150g protein/day |
| Track supplements in a spreadsheet | Flags interactions, tracks compliance, aligns with active trials |
| Get generic health tips | Searches PubMed & bioRxiv for evidence specific to YOUR patterns |
| Wonder if something works | Designs an N-of-1 trial with proper controls, monitors it, and runs causal analysis |

### Key Innovations

**1. Cross-Module Pattern Detection.** The modeling engine continuously scans correlations across diet, exercise, sleep, metrics, and biomarkers — with lag analysis up to 7 days and Benjamini-Hochberg correction for multiple comparisons. It finds things you'd never notice:

> *"Your sleep quality drops 0.8 SD on days with <20g protein at dinner (r=-0.42, p=0.003, lag 0d, n=47)"*

**2. Literature-Grounded Insights.** When the system detects a pattern, it doesn't just report a correlation — it searches PubMed and bioRxiv for mechanistic explanations. Every recommendation comes with citations:

> *"This is consistent with tryptophan-mediated serotonin/melatonin synthesis. A 2024 RCT (n=112) found that 30g protein at dinner improved Pittsburgh Sleep Quality Index by 0.7 points (PMID: 38291045)."*

**3. N-of-1 Trial Engine with Adversarial Review.** Two independent agents handle trial proposals — one designs the protocol (院判), the other tries to break it (医正). The reviewer independently searches the literature, checks for confounders, and rejects weak proposals. This mimics the peer review process:

> 院判: *"Proposed ABA trial: increase dinner protein to 30g for 14 days."*
> 医正: *"REJECT — Calorie intake covaries with protein. Add isocaloric control. Also, baseline has only 18 observations; extend to 21 for adequate power (MDE=0.68, expected d=0.5-1.0)."*

**4. Bayesian Causal Inference.** After a trial completes, the system doesn't just compare means — it runs interrupted time series analysis and Bayesian structural time series with a custom Kalman filter/RTS smoother to estimate the causal effect with proper uncertainty quantification.

**5. Everything Stays Local.** No cloud. No accounts. SQLite database with `0600` permissions. The dashboard binds to `127.0.0.1` only. Nutrition lookups send ingredient names only, never health data.

---

## How It Works

Longevity OS is built as a **multi-agent skill** — 10 markdown agent prompts + MCP tools. Designed for Claude Code, fully compatible with OpenClaw and any agent runtime that supports MCP. You interact through natural language — voice or text. Behind the scenes, an orchestrator dispatches work to specialized agents, each with domain expertise and specific tools.

<p align="center">
  <img src="docs/architecture.svg" alt="System Architecture" width="100%" />
</p>

### The Imperial Court — 10 Agents

<table>
<tr>
<td align="center" width="20%"><img src="docs/characters/yuyi.svg" alt="Imperial Physician" width="80"/><br/><b>Imperial Physician</b><br/>Orchestrator</td>
<td align="center" width="20%"><img src="docs/characters/shiyi.svg" alt="Diet Physician" width="80"/><br/><b>Diet Physician</b><br/>Nutrition</td>
<td align="center" width="20%"><img src="docs/characters/daoyin.svg" alt="Movement Master" width="80"/><br/><b>Movement Master</b><br/>Exercise</td>
<td align="center" width="20%"><img src="docs/characters/zhenmai.svg" alt="Pulse Reader" width="80"/><br/><b>Pulse Reader</b><br/>Body Metrics</td>
<td align="center" width="20%"><img src="docs/characters/yanfang.svg" alt="Formula Tester" width="80"/><br/><b>Formula Tester</b><br/>Biomarkers</td>
</tr>
<tr>
<td align="center"><img src="docs/characters/bencao.svg" alt="Herbalist" width="80"/><br/><b>Herbalist</b><br/>Supplements</td>
<td align="center"><img src="docs/characters/shixiao.svg" alt="Trial Monitor" width="80"/><br/><b>Trial Monitor</b><br/>Experiments</td>
<td align="center"><img src="docs/characters/yuanpan.svg" alt="Court Magistrate" width="80"/><br/><b>Court Magistrate</b><br/>Trial Design + PubMed</td>
<td align="center"><img src="docs/characters/yizheng.svg" alt="Medical Censor" width="80"/><br/><b>Medical Censor</b><br/>Safety Review + PubMed</td>
<td align="center"><img src="docs/characters/baogao.svg" alt="Court Scribe" width="80"/><br/><b>Court Scribe</b><br/>Reports + Literature</td>
</tr>
</table>

### Agent Dispatch Flow

<p align="center">
  <img src="docs/agent-flow.svg" alt="Agent Dispatch Flow" width="100%" />
</p>

---

## Conversation Examples

### Logging a Meal

```
👤 You:  Had 红烧肉 with rice and bok choy for lunch

🏥 御医:  Logged lunch — 红烧肉 (Braised Pork Belly)

    ┌──────────────────────────────────────────┐
    │  🍚 Lunch · Mar 12                       │
    │                                          │
    │  红烧肉 (braised pork belly, 200g)       │
    │  Steamed white rice (180g)               │
    │  Bok choy, sautéed (150g)               │
    │                                          │
    │  Calories   683 kcal                     │
    │  Protein     32g                         │
    │  Carbs       68g                         │
    │  Fat         31g   (saturated: 11g)      │
    │  Fiber        4g                         │
    │                                          │
    │  Source: USDA FoodData Central           │
    │  Confidence: 0.7 (text estimate)         │
    └──────────────────────────────────────────┘

    Today so far: 1,847 / 2,200 kcal · 98g protein (target: 150g)
    💡 You're behind on protein — consider a high-protein snack.
```

### Getting a Weekly Report with Literature-Backed Insights

```
👤 You:  Weekly report

🏥 御医:  Here's your week in review (Mar 3–9):

    ┌─ DIET ─────────────────────────────────────────────────┐
    │  Avg calories: 2,369/day (+5% vs prior week)           │
    │  Avg protein: 158g/day (target: 150g ✓)                │
    │  Fiber: 18g/day (below 25g target on 5/7 days)         │
    └────────────────────────────────────────────────────────┘

    ┌─ BODY METRICS ─────────────────────────────────────────┐
    │  Weight: 73.4 → 73.1 kg (trend: -0.04 kg/day)         │
    │  Resting HR: 58 bpm (stable, 7d avg: 59)              │
    │  Sleep: 7.2 hrs avg (down from 7.6 — ⚠️ declining)     │
    └────────────────────────────────────────────────────────┘

    ┌─ EXERCISE ─────────────────────────────────────────────┐
    │  5 sessions · 287 min total                            │
    │  3x weightlifting · 2x running (22.4 km)              │
    │  Avg RPE: 7.2 (moderate-hard)                         │
    └────────────────────────────────────────────────────────┘

    ┌─ CROSS-MODULE INSIGHT ─────────────────────────────────┐
    │  📊 Pattern detected: Evening exercise (after 6pm)     │
    │  correlates with worse sleep onset (r=0.38, p=0.02).   │
    │                                                        │
    │  📚 Literature: Late-evening high-intensity exercise    │
    │  delays sleep onset by 20-40 min via elevated core     │
    │  body temperature and cortisol (Stutz et al., Sports   │
    │  Medicine 2019; PMID: 30374942). Effect is attenuated  │
    │  for moderate-intensity and exercises ending >2h        │
    │  before bed.                                           │
    │                                                        │
    │  💡 Recommendation: Try finishing intense workouts by   │
    │  6pm. This pattern qualifies as a trial candidate      │
    │  (effect size d=0.41, sufficient baseline data).       │
    └────────────────────────────────────────────────────────┘

    Active trial: Creatine-Cognition (Day 26/84, baseline phase)
```

### N-of-1 Trial Proposal with Adversarial Review

```
👤 You:  I've noticed I sleep better when I eat more protein. Can we test this?

🏥 御医:  I see the same pattern in your data. Let me have 院判 design
          a trial and 医正 review it independently.

    ┌─ 院判 (Trial Design) ──────────────────────────────────┐
    │                                                        │
    │  HYPOTHESIS: Increasing dinner protein to ≥30g         │
    │  improves next-day sleep quality score by ≥0.5 points  │
    │                                                        │
    │  EVIDENCE FROM YOUR DATA:                              │
    │  • Correlation: r=-0.42, p=0.003, n=47                 │
    │  • Baseline sleep quality SD: 1.12                     │
    │  • MDE (14 obs/phase, α=0.05, β=0.20): d=0.68         │
    │                                                        │
    │  LITERATURE SUPPORT:                                   │
    │  1. Cao et al. (2024) Nutrients — 30g casein at        │
    │     dinner improved PSQI by 0.7 in adults 40-65        │
    │     (n=112, RCT). PMID: 38291045                       │
    │  2. Sutanto et al. (2022) Clin Nutr — Tryptophan       │
    │     from dietary protein dose-dependently increases     │
    │     melatonin. PMID: 35123543                          │
    │  3. Kinsey & Ormsbee (2015) Nutrients — Pre-sleep      │
    │     protein does not impair fat oxidation.              │
    │     PMID: 26690472                                     │
    │                                                        │
    │  PROTOCOL:                                             │
    │  Design: ABA (baseline → intervention → washout)       │
    │  Phase duration: 14 days each (42 days total)          │
    │  Intervention: ≥30g protein at dinner                  │
    │  Primary outcome: Sleep quality score (0-10)           │
    │  Secondary: Sleep duration, sleep onset latency        │
    │  Washout: 7 days (return to habitual diet)             │
    │                                                        │
    └────────────────────────────────────────────────────────┘

    ┌─ 医正 (Independent Safety Review) ─────────────────────┐
    │                                                        │
    │  ✅ APPROVED (with minor revisions)                    │
    │  Confidence: 0.78                                      │
    │                                                        │
    │  Literature verified — found 2 additional supporting   │
    │  papers plus 1 contradicting (Crispim et al., showing  │
    │  high-fat dinner impairs sleep — confirms protein      │
    │  specifically, not calories, is the mechanism).        │
    │                                                        │
    │  Issues found:                                         │
    │  ⚠️  Track total dinner calories as covariate —        │
    │     increased protein may come with increased total    │
    │     calories. Use isocaloric substitution if possible. │
    │                                                        │
    │  Safety: No concerns. 30g protein at dinner is within  │
    │  normal dietary range.                                 │
    │                                                        │
    └────────────────────────────────────────────────────────┘

    Shall I activate this trial? (You can modify the protocol first.)
```

### Asking a Health Question (Literature Search)

```
👤 You:  My CRP has been creeping up (1.2 → 1.8 over 3 months).
         Should I be worried? Anything in my data that might explain it?

🏥 御医:  Let me check your data and the literature.

    ┌─ YOUR DATA ────────────────────────────────────────────┐
    │  CRP trend: 1.2 → 1.5 → 1.8 mg/L (Jan → Mar)         │
    │  Still within clinical range (<3.0) but trending up.   │
    │                                                        │
    │  Possible correlates in your data:                     │
    │  • Sleep dropped from 7.8 → 7.1 hrs (r=0.34, p=0.04) │
    │  • Fiber intake 18g/day (below 25g recommendation)     │
    │  • No change in exercise or weight                     │
    └────────────────────────────────────────────────────────┘

    ┌─ LITERATURE CONTEXT ───────────────────────────────────┐
    │                                                        │
    │  📚 Sleep restriction (even modest, <7h) elevates      │
    │  CRP by 0.5-1.0 mg/L within weeks (Meier-Ewert et     │
    │  al., JACC 2004; PMID: 14975482).                      │
    │                                                        │
    │  📚 Low dietary fiber (<20g/day) is associated with    │
    │  higher CRP in multiple cohorts. Increasing fiber to   │
    │  ≥25g/day reduces CRP by 25-30% over 8 weeks (King    │
    │  et al., Arch Intern Med 2007; PMID: 17339501).        │
    │                                                        │
    │  💡 Suggested actions:                                  │
    │  1. Prioritize sleep — aim for ≥7.5h (high impact)    │
    │  2. Increase fiber: add berries, lentils, vegetables   │
    │  3. Recheck CRP in 4-6 weeks                          │
    │  4. This qualifies as a trial candidate if you want    │
    │     to formally test the fiber → CRP hypothesis.       │
    │                                                        │
    └────────────────────────────────────────────────────────┘
```

### Daily Digest (Autonomous)

```
🏥 御医:  Good morning! Here's your daily brief:

    📊 Yesterday's stats: 2,390 kcal · 160g protein · 63 min exercise
    😴 Sleep: 7.4 hrs (above your 7d avg of 7.1 ✓)
    ⚖️  Weight: 73.2 kg (7d trend: -0.3 kg)

    ⚠️  Anomaly: Resting HR was 72 bpm yesterday (your 30d avg is 59).
    Coincided with rest day after heavy squat session and 8.3h sleep.
    Likely post-exercise recovery — monitor today.

    📋 Active trial: Creatine-Cognition (Day 26/84)
    Phase: baseline · Compliance: 100% · 8 days until intervention phase

    🔬 New insight: Vitamin D supplementation period (Feb-Mar) shows
    16% increase in serotonin proxy (COALESCE(223→HHI 18g)) and
    concurrent 50% reduction in CRP (2.14 → 1.04 mg/L, p<0.01).
    Literature supports Vitamin D → NF-κB suppression pathway.
```

---

## Dashboard

Zero-dependency local HTML with EN/CN language toggle. Light rice-paper theme with imperial Chinese accents.

<p align="center">
  <img src="docs/screenshots/dashboard-summary.png" alt="Today's Summary" width="100%" />
</p>

<details>
<summary><b>Nutrition</b> — Daily macros with meal drill-down</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-nutrition.png" alt="Nutrition" width="100%" />
</p>
</details>

<details>
<summary><b>Body Metrics</b> — Weight, HR, HRV, Sleep, BP with 7d moving average</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-metrics.png" alt="Body Metrics" width="100%" />
</p>
</details>

<details>
<summary><b>Exercise</b> — Activity heatmap and workout log</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-exercise.png" alt="Exercise" width="100%" />
</p>
</details>

<details>
<summary><b>Supplements</b> — Active stack with dosage and timing</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-supplements.png" alt="Supplements" width="100%" />
</p>
</details>

<details>
<summary><b>Biomarkers</b> — Lab trends with reference ranges</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-biomarkers.png" alt="Biomarkers" width="100%" />
</p>
</details>

<details>
<summary><b>Trials</b> — N-of-1 progress tracking</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-trials.png" alt="Trials" width="100%" />
</p>
</details>

<details>
<summary><b>Insights</b> — AI-generated findings with evidence levels</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-insights.png" alt="Insights" width="100%" />
</p>
</details>

---

## Modeling Engine

The statistical engine runs behind all modules and produces real analytical output. Here are actual results from 90 days of data:

**Pattern Detection** — Found body fat strongly tracks weight (r=0.91, p<0.001) and calorie intake predicts next-day sleep duration (r=0.40, lag 1d, p=0.0001).

**Trend Analysis** — Weight declining at -0.039 kg/day (R²=0.84), from 75.9 to 71.6 kg over 90 days.

**Anomaly Detection** — 9 anomalous weight dips flagged, clustered in mid-Feb and mid-Mar recovery periods.

**Trial Analysis** — Protein-Sleep trial (completed): effect size d=0.94, sleep quality improved 6.98 → 7.64, but confidence rated "low" due to confounders (calories +32%, exercise +86% during intervention).

Full demo outputs available in [`docs/demo-output/`](docs/demo-output/).

---

## OpenClaw Compatibility

Longevity OS is **natively compatible with OpenClaw**. The entire system is markdown agent prompts + MCP tools — the same primitives OpenClaw uses.

### Why it works out of the box

| Component | Format | OpenClaw equivalent |
|-----------|--------|-------------------|
| `SKILL.md` | Markdown prompt | `skill.md` orchestrator |
| `agents/*.md` | 9 markdown agent prompts | Per-agent `skill.md` files |
| PubMed, bioRxiv | MCP tools | MCP skill servers on ClawHub |
| Multi-agent dispatch | Orchestrator → sub-agents | OpenClaw multi-agent routing |
| SQLite + Python scripts | Bash tool calls | OpenClaw tool execution |

### Setup on OpenClaw

```bash
# 1. Clone the repo
git clone https://github.com/albert-ying/longevity-os.git

# 2. Initialize the database
cd longevity-os && python scripts/setup.py

# 3. Copy agent prompts to your OpenClaw workspace
cp SKILL.md ~/.openclaw/skills/longevity/skill.md
cp agents/*.md ~/.openclaw/skills/longevity/agents/

# 4. Enable MCP tools (PubMed, bioRxiv) via ClawHub or local config
```

Each of the 10 agents works as an independent OpenClaw skill — you can use the full system or pick individual modules (e.g., just the diet tracker or just the N-of-1 trial engine).

### Multi-Agent on OpenClaw

The orchestrator (御医) pattern maps directly to OpenClaw's [multi-agent routing](https://docs.openclaw.ai/concepts/multi-agent): a persistent orchestrator agent handles user chat and spawns sub-agents for parallel tasks (diet logging + exercise logging from one message, trial design + safety review as sequential agents).

---

## Quick Start

### Claude Code

```bash
# 1. Initialize the database
cd ~/Desktop/Projects/2026/longevity-os
python scripts/setup.py

# 2. Start the dashboard server
python dashboard/server.py

# 3. Open http://localhost:8420
```

The primary interface is natural language through Claude Code:
```
/longevity Had salmon and rice for lunch
/longevity Weekly report
/longevity How's my sleep trending?
/longevity Propose a trial for my protein-sleep pattern
```

### OpenClaw

After copying skills to your OpenClaw workspace (see [OpenClaw setup](#setup-on-openclaw) above), interact via any connected platform — WhatsApp, Telegram, Slack, Discord, or iMessage:

```
@longevity Had salmon and rice for lunch
@longevity Weekly report
@longevity How's my sleep trending?
```

---

## Modules

| Module | Agent | Capabilities |
|--------|-------|-------------|
| **Diet** | Diet Physician | USDA nutrition lookup, recipe learning, Chinese dish decomposition |
| **Exercise** | Movement Master | Workout logging, volume tracking, muscle group balance, RPE trends |
| **Body Metrics** | Pulse Reader | Weight, BP, HR, HRV, sleep, glucose, custom metrics |
| **Biomarkers** | Formula Tester | Lab results, reference range flagging, rate-of-change alerts |
| **Supplements** | Herbalist | Stack management, interaction checking (NIH ODS), trial compliance |
| **Trials** | Trial Monitor | Protocol adherence, daily observations, completion tracking |
| **Trial Design** | Court Magistrate | Literature search (PubMed + bioRxiv), protocol design, power analysis |
| **Safety Review** | Medical Censor | Independent review, literature verification, confounder identification |
| **Reports** | Court Scribe | Daily digests, weekly reports, literature-backed recommendations |

---

## File Structure

```
longevity-os/
├── SKILL.md                    # Orchestrator (main entry point)
├── agents/                     # 9 department agent prompts
├── dashboard/
│   ├── dashboard.html          # Light theme, EN/CN toggle
│   └── server.py               # Python stdlib HTTP server
├── data/
│   ├── schema.sql              # 17 tables, 25+ indexes
│   ├── db.py                   # TaiYiYuanDB interface
│   └── nutrition_api.py        # USDA + Open Food Facts
├── modeling/
│   ├── engine.py               # Rolling stats, trends, anomalies
│   ├── patterns.py             # Cross-module correlation scanner
│   └── causal.py               # ITS, Bayesian STS, power analysis
├── scripts/                    # Setup, backup, import, export
└── docs/
    ├── architecture.svg        # System architecture diagram
    ├── agent-flow.svg          # Agent dispatch flow
    ├── characters/             # 10 agent character illustrations
    ├── screenshots/            # Dashboard screenshots
    └── demo-output/            # Modeling engine demo results
```

---

## Data Privacy

All health data stays in a local SQLite database with owner-only permissions (`0600`). No cloud sync. No telemetry. Nutrition lookups send only ingredient names. The dashboard binds to `127.0.0.1`. Literature searches go through Claude's MCP tools — your health data is never included in search queries.

---

## Tech Stack

- **AI**: 10 markdown agent prompts — works on Claude Code, OpenClaw, or any MCP-compatible runtime
- **Tools**: MCP protocol (PubMed, bioRxiv, USDA nutrition API)
- **Database**: SQLite with WAL journal mode
- **Modeling**: scipy, statsmodels, numpy, pandas + custom Bayesian STS
- **Dashboard**: Single HTML, Chart.js 4.x, EN/CN i18n
- **Server**: Python stdlib (zero external dependencies)

---

<p align="center">
  📖 <a href="README.zh.md">中文文档 / Chinese Documentation</a>
</p>
