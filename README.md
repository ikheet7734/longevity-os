# Longevity OS 太医院

Personal longevity optimization system — 个人长寿优化系统

Health tracking and N-of-1 trial system, modeled after the historical Imperial Medical Academy (太医院). Tracks diet, exercise, body metrics, biomarkers, and supplements — then uses statistical modeling to surface insights and propose self-experiments.

All data stays local. No cloud. SQLite database, Python server, static HTML dashboard.

---

## Quick Start

```bash
# 1. Initialize the database
cd ~/Desktop/Projects/2026/taiyiyuan
sqlite3 data/taiyiyuan.db < ~/programs/ai-skills/taiyiyuan/data/schema.sql
sqlite3 data/taiyiyuan.db "INSERT INTO schema_version VALUES (1, datetime('now'));"

# 2. Start the dashboard server
python ~/programs/ai-skills/taiyiyuan/dashboard/server.py

# 3. Open http://localhost:8420
```

The primary interface is voice/text through Claude Code using the `taiyiyuan` skill. The dashboard is a read-only visualization layer.

---

## Departments

| Department | Chinese | Role |
|------------|---------|------|
| Diet | 食医科 | Meal logging, nutrition lookup, recipe library |
| Exercise | 导引科 | Workout logging, volume and progress tracking |
| Body Metrics | 诊脉科 | Weight, BP, sleep, HRV, custom metrics |
| Biomarkers | 验方科 | Lab results with clinical and optimal reference ranges |
| Supplements | 本草科 | Supplement stack management, interaction checking |
| Modeling | 试效科 | Pattern detection, statistical insights, trial proposals |

Reports (报告科), Trial Design (院判), and Safety Review (医正) are orchestration agents that coordinate across departments.

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

## File Structure

```
~/programs/ai-skills/taiyiyuan/       # Skill definition (prompts, agents, scripts)
├── SKILL.md                          # Main skill prompt (御医 orchestrator)
├── agents/                           # Department agent prompts
│   ├── shiyi.md                      # 食医科 (Diet)
│   ├── daoyin.md                     # 导引科 (Exercise)
│   ├── zhenmai.md                    # 诊脉科 (Body Metrics)
│   ├── yanfang.md                    # 验方科 (Biomarkers)
│   ├── bencao.md                     # 本草科 (Supplements)
│   ├── baogao.md                     # 报告科 (Reports)
│   ├── shixiao.md                    # 试效科 (Modeling)
│   ├── yuanpan.md                    # 院判 (Trial Design)
│   └── yizheng.md                    # 医正 (Safety Review)
├── dashboard/                        # Web dashboard
│   ├── dashboard.html                # Single-file dark-theme dashboard
│   └── server.py                     # Stdlib-only Python HTTP server
├── data/                             # Schema and reference data
│   └── schema.sql                    # SQLite schema v1
├── modeling/                         # Statistical analysis scripts
└── scripts/                          # Utility scripts

~/Desktop/Projects/2026/taiyiyuan/    # Project data (gitignored)
├── data/
│   └── taiyiyuan.db                  # SQLite database (all health data)
├── reports/                          # Generated weekly/monthly reports
├── photos/                           # Meal photos
└── trials/                           # Trial protocol files
```

---

## Data Privacy

All health data is stored in a local SQLite database (`taiyiyuan.db`) with file permissions restricted to the owner. No data is transmitted to external services. Nutrition lookups use only ingredient names (never personal health context). The dashboard server binds to `127.0.0.1` only and is not accessible from other machines.
