<p align="center">
  <img src="docs/logo.png" alt="太医院" width="280" />
</p>

<h1 align="center">太医院</h1>
<p align="center"><b>个人长寿优化系统 · 兼容 Claude Code 与 OpenClaw</b></p>

<p align="center">
十位 AI 御医各司其职——追踪健康数据、发现跨模块隐藏规律、<br/>
检索科学文献佐证洞察、设计严谨的 N-of-1 自我实验，<br/>
并以贝叶斯因果推断分析结果。全部数据本地存储，绝不上云。<br/>
<b>10 个 Markdown 智能体 + MCP 工具 = Claude Code、OpenClaw 或任何 MCP 兼容平台均可运行。</b>
</p>

<p align="center">
  <a href="#为什么要做这个">为什么</a> · <a href="#工作原理">原理</a> · <a href="#对话示例">示例</a> · <a href="#openclaw-兼容">OpenClaw</a> · <a href="#仪表板">仪表板</a> · <a href="#快速开始">快速开始</a> · <a href="README.md">English</a>
</p>

<p align="center">
  <img src="docs/screenshots/dashboard-hero.png" alt="太医院仪表板" width="100%" />
</p>

---

## 为什么要做这个

市面上的健康应用本质上是**记录器**——记下你告诉它的东西，画几张图表。它们不思考。不会把你的睡眠、饮食和化验单联系起来。更不会去翻文献找出你 CRP 升高的可能原因。

太医院不同。它是一个**智能体系统**——十位专职 AI 御医主动分析你的健康数据：

| 现有应用能做的 | 太医院做的 |
|---|---|
| 手动记录饮食 | 记录饮食、通过 USDA API 估算营养素、学习你的常用菜谱 |
| 看一张体重曲线 | 发现「周蛋白摄入>150g 时体重下降更快」 |
| 用 Excel 管理补剂 | 检查药物相互作用、追踪依从性、与试验方案对齐 |
| 收到千篇一律的健康建议 | 针对**你的数据规律**检索 PubMed & bioRxiv 文献 |
| 猜测某个干预有没有效 | 设计有对照的 N-of-1 试验、监控执行、运行因果分析 |

### 核心创新

**1. 跨模块模式检测。** 建模引擎持续扫描饮食、运动、睡眠、体征与生物标志物之间的关联——支持至多 7 天的滞后分析，Benjamini-Hochberg 校正多重比较。它能发现你自己注意不到的规律：

> *「晚餐蛋白质<20g 的日子，睡眠质量下降 0.8 SD（r=-0.42, p=0.003, lag 0d, n=47）」*

**2. 文献佐证的洞察。** 检测到模式后不止报告相关性——系统会检索 PubMed 和 bioRxiv 寻找机制解释。每条建议都附带文献引用：

> *「这与色氨酸介导的血清素/褪黑素合成通路一致。2024 年一项 RCT（n=112）发现晚餐摄入 30g 蛋白可改善匹兹堡睡眠质量指数 0.7 分（PMID: 38291045）。」*

**3. 双智能体对抗审查的 N-of-1 试验引擎。** 院判设计试验方案，医正独立评审——独立检索文献、检查混杂因素、驳回不严谨的方案。模拟学术同行评议：

> 院判：*「拟 ABA 试验：晚餐蛋白增至 30g，持续 14 天。」*
> 医正：*「驳回——热量摄入与蛋白共变。需加等热量对照。另外基线仅 18 个观测点，建议延长至 21 个以保证检验效力（MDE=0.68, 预期 d=0.5-1.0）。」*

**4. 贝叶斯因果推断。** 试验结束后不只比较均值——运行间断时间序列分析与贝叶斯结构时间序列（自定义卡尔曼滤波器/RTS 平滑器），量化因果效应及不确定性。

**5. 全部本地运行。** 无云端。无账号。SQLite 数据库权限 `0600`（仅所有者可读写）。仪表板仅绑定 `127.0.0.1`。营养查询仅发送食材名称，绝不包含健康数据。

---

## 工作原理

太医院是一个**多智能体技能系统**——10 个 Markdown 智能体提示 + MCP 工具。专为 Claude Code 设计，完全兼容 OpenClaw 及所有支持 MCP 的智能体平台。你通过自然语言（语音或文字）交互。后台的御医（总调度）会将请求分派至专职智能体，各有独立的领域知识和工具。

<p align="center">
  <img src="docs/architecture.svg" alt="系统架构" width="100%" />
</p>

### 御医阁——十官

<table>
<tr>
<td align="center" width="20%"><img src="docs/characters/yuyi.svg" alt="御医" width="80"/><br/><b>御医</b><br/>总调度</td>
<td align="center" width="20%"><img src="docs/characters/shiyi.svg" alt="食医" width="80"/><br/><b>食医科</b><br/>膳食营养</td>
<td align="center" width="20%"><img src="docs/characters/daoyin.svg" alt="导引" width="80"/><br/><b>导引科</b><br/>运动锻炼</td>
<td align="center" width="20%"><img src="docs/characters/zhenmai.svg" alt="诊脉" width="80"/><br/><b>诊脉科</b><br/>体征监测</td>
<td align="center" width="20%"><img src="docs/characters/yanfang.svg" alt="验方" width="80"/><br/><b>验方科</b><br/>生物标志物</td>
</tr>
<tr>
<td align="center"><img src="docs/characters/bencao.svg" alt="本草" width="80"/><br/><b>本草科</b><br/>补剂管理</td>
<td align="center"><img src="docs/characters/shixiao.svg" alt="试效" width="80"/><br/><b>试效科</b><br/>试验监测</td>
<td align="center"><img src="docs/characters/yuanpan.svg" alt="院判" width="80"/><br/><b>院判</b><br/>试验设计 + 文献检索</td>
<td align="center"><img src="docs/characters/yizheng.svg" alt="医正" width="80"/><br/><b>医正</b><br/>安全审查 + 文献检索</td>
<td align="center"><img src="docs/characters/baogao.svg" alt="报告" width="80"/><br/><b>报告科</b><br/>报告汇总 + 文献</td>
</tr>
</table>

### 智能体调度流程

<p align="center">
  <img src="docs/agent-flow.svg" alt="调度流程" width="100%" />
</p>

---

## 对话示例

### 记录一餐饭

```
👤 你：  午饭吃了红烧肉配米饭和小白菜

🏥 御医：  已记录午餐——红烧肉

    ┌──────────────────────────────────────────┐
    │  🍚 午餐 · 3月12日                       │
    │                                          │
    │  红烧肉（五花肉，200g）                  │
    │  白米饭（180g）                          │
    │  炒小白菜（150g）                        │
    │                                          │
    │  热量     683 千卡                       │
    │  蛋白质    32g                           │
    │  碳水      68g                           │
    │  脂肪      31g（饱和脂肪：11g）          │
    │  膳食纤维   4g                           │
    │                                          │
    │  数据来源：USDA FoodData Central         │
    │  置信度：0.7（文字估算）                 │
    └──────────────────────────────────────────┘

    今日合计：1,847 / 2,200 千卡 · 蛋白质 98g（目标：150g）
    💡 蛋白质摄入偏低——建议加一份高蛋白加餐。
```

### 周报（含文献佐证）

```
👤 你：  出周报

🏥 御医：  本周健康概览（3月3日–9日）：

    ┌─ 膳食 ────────────────────────────────────────────┐
    │  日均热量：2,369 千卡（较上周 +5%）                │
    │  日均蛋白质：158g（目标 150g ✓）                   │
    │  膳食纤维：18g/天（5/7 天低于 25g 目标）           │
    └───────────────────────────────────────────────────┘

    ┌─ 体征 ────────────────────────────────────────────┐
    │  体重：73.4 → 73.1 kg（趋势：-0.04 kg/天）       │
    │  静息心率：58 bpm（稳定，7日均值 59）             │
    │  睡眠：7.2 小时均值（较上周 7.6 下降 ⚠️）          │
    └───────────────────────────────────────────────────┘

    ┌─ 运动 ────────────────────────────────────────────┐
    │  5 次训练 · 共 287 分钟                            │
    │  3 次力量 · 2 次跑步（22.4 km）                   │
    │  平均 RPE：7.2（中高强度）                        │
    └───────────────────────────────────────────────────┘

    ┌─ 跨模块洞察 ──────────────────────────────────────┐
    │  📊 模式发现：傍晚 6 点后运动与入睡延迟显著       │
    │  相关（r=0.38, p=0.02）。                         │
    │                                                    │
    │  📚 文献：高强度晚间运动通过升高核心体温与皮质    │
    │  醇延迟入睡 20-40 分钟（Stutz et al., Sports      │
    │  Medicine 2019; PMID: 30374942）。中等强度或运动   │
    │  结束>2 小时后影响减弱。                          │
    │                                                    │
    │  💡 建议：将高强度训练移至 6 点前。此模式符合     │
    │  试验候选条件（效应量 d=0.41，基线数据充足）。    │
    └───────────────────────────────────────────────────┘

    进行中试验：肌酸-认知试验（第 26/84 天，基线期）
```

### N-of-1 试验提议（含对抗审查）

```
👤 你：  我发现多吃蛋白质的时候睡得好一些，能不能测一下？

🏥 御医：  你的数据确实显示了这个趋势。我让院判设计方案，
          医正独立审查。

    ┌─ 院判（试验设计）──────────────────────────────────┐
    │                                                    │
    │  假设：将晚餐蛋白提高至≥30g 可改善次日睡眠       │
    │  质量评分≥0.5 分                                  │
    │                                                    │
    │  你的数据证据：                                    │
    │  • 相关性：r=-0.42, p=0.003, n=47                 │
    │  • 基线睡眠质量 SD：1.12                          │
    │  • MDE（14 obs/phase, α=0.05, β=0.20）：d=0.68   │
    │                                                    │
    │  文献支持：                                        │
    │  1. Cao et al. (2024) Nutrients — 晚餐 30g 酪蛋   │
    │     白改善 PSQI 0.7 分（n=112，RCT）              │
    │     PMID: 38291045                                 │
    │  2. Sutanto et al. (2022) Clin Nutr — 膳食蛋白    │
    │     中的色氨酸呈剂量依赖性增加褪黑素              │
    │     PMID: 35123543                                 │
    │  3. Kinsey & Ormsbee (2015) Nutrients — 睡前蛋     │
    │     白不损害脂肪氧化 PMID: 26690472               │
    │                                                    │
    │  方案：                                            │
    │  设计：ABA（基线期→干预期→洗脱期）               │
    │  每阶段 14 天（共 42 天）                          │
    │  干预：晚餐≥30g 蛋白质                           │
    │  主要结局：睡眠质量评分（0-10）                   │
    │  次要结局：睡眠时长、入睡潜伏期                   │
    │  洗脱期：7 天（恢复日常饮食）                     │
    │                                                    │
    └────────────────────────────────────────────────────┘

    ┌─ 医正（独立安全审查）──────────────────────────────┐
    │                                                    │
    │  ✅ 批准（附修改意见）                             │
    │  置信度：0.78                                      │
    │                                                    │
    │  文献核实通过——额外找到 2 篇支持文献及 1 篇      │
    │  反面证据（Crispim et al.，高脂晚餐损害睡眠       │
    │  ——恰好佐证「关键在蛋白质而非总热量」）。        │
    │                                                    │
    │  发现的问题：                                      │
    │  ⚠️  需将总热量作为协变量追踪——增加蛋白质可     │
    │     能伴随总热量上升。建议尽量做等热量替换。      │
    │                                                    │
    │  安全性：无顾虑。晚餐 30g 蛋白在正常饮食范围内。  │
    │                                                    │
    └────────────────────────────────────────────────────┘

    是否启动此试验？（你可以先修改方案。）
```

### 健康问题咨询（文献检索）

```
👤 你：  我的 CRP 最近三个月在涨（1.2 → 1.8），需要担心吗？
         我的数据里有没有什么线索？

🏥 御医：  我查一下你的数据和文献。

    ┌─ 你的数据 ────────────────────────────────────────┐
    │  CRP 趋势：1.2 → 1.5 → 1.8 mg/L（1月→3月）     │
    │  仍在临床正常范围（<3.0），但趋势上升。           │
    │                                                    │
    │  数据中的可能关联因素：                            │
    │  • 睡眠从 7.8 降至 7.1 小时（r=0.34, p=0.04）    │
    │  • 膳食纤维 18g/天（低于 25g 推荐量）             │
    │  • 运动和体重无显著变化                            │
    └───────────────────────────────────────────────────┘

    ┌─ 文献背景 ────────────────────────────────────────┐
    │                                                    │
    │  📚 即使是轻度睡眠不足（<7 小时）也会在数周内     │
    │  使 CRP 升高 0.5-1.0 mg/L（Meier-Ewert et al.,   │
    │  JACC 2004; PMID: 14975482）。                     │
    │                                                    │
    │  📚 低膳食纤维（<20g/天）与多个队列中较高的 CRP   │
    │  相关。将纤维增至≥25g/天可在 8 周内降低 CRP      │
    │  25-30%（King et al., Arch Intern Med 2007;       │
    │  PMID: 17339501）。                                │
    │                                                    │
    │  💡 建议行动：                                     │
    │  1. 优先保证睡眠——≥7.5 小时（影响最大）         │
    │  2. 增加膳食纤维：多吃浆果、扁豆、蔬菜           │
    │  3. 4-6 周后复查 CRP                              │
    │  4. 如需正式验证，可将「纤维→CRP」假说设计为     │
    │     N-of-1 试验。                                  │
    │                                                    │
    └───────────────────────────────────────────────────┘
```

### 每日简报（自动推送）

```
🏥 御医：  早上好！以下是今日简报：

    📊 昨日数据：2,390 千卡 · 蛋白质 160g · 运动 63 分钟
    😴 睡眠：7.4 小时（高于 7 日均值 7.1 ✓）
    ⚖️  体重：73.2 kg（7 日趋势：-0.3 kg）

    ⚠️  异常：昨日静息心率 72 bpm（30 日均值 59）。
    恰逢大重量深蹲训练后的休息日，伴 8.3 小时睡眠。
    可能为运动后恢复反应——今日继续观察。

    📋 进行中试验：肌酸-认知试验（第 26/84 天）
    阶段：基线期 · 依从性：100% · 距干预期开始还有 8 天

    🔬 新发现：维生素 D 补充期间（2-3月），CRP 从 2.14
    降至 1.04 mg/L（降幅 50%, p<0.01）。
    文献支持 维生素 D → NF-κB 抑制通路。
```

---

## 仪表板

零依赖本地 HTML 页面，支持中英双语切换。浅色宣纸主题，宫廷中式设计元素。

<p align="center">
  <img src="docs/screenshots/dashboard-summary.png" alt="今日总览" width="100%" />
</p>

<details>
<summary><b>营养（食医科）</b>——每日宏量营养素堆叠柱状图</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-nutrition.png" alt="营养图表" width="100%" />
</p>
</details>

<details>
<summary><b>体征（诊脉科）</b>——体重、心率、HRV、睡眠、血压时序图</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-metrics.png" alt="体征图表" width="100%" />
</p>
</details>

<details>
<summary><b>运动（导引科）</b>——活动热力图与训练日志</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-exercise.png" alt="运动热力图" width="100%" />
</p>
</details>

<details>
<summary><b>补剂（本草科）</b>——当前方案、剂量与服用时间</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-supplements.png" alt="补剂方案" width="100%" />
</p>
</details>

<details>
<summary><b>化验（验方科）</b>——生物标志物趋势与参考范围</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-biomarkers.png" alt="生物标志物趋势" width="100%" />
</p>
</details>

<details>
<summary><b>试验（试效科）</b>——N-of-1 试验进度追踪</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-trials.png" alt="进行中的试验" width="100%" />
</p>
</details>

<details>
<summary><b>洞察（建模引擎）</b>——AI 发现与证据等级</summary>
<p align="center">
  <img src="docs/screenshots/dashboard-insights.png" alt="建模引擎洞察" width="100%" />
</p>
</details>

---

## 建模引擎

统计引擎贯穿所有模块，以下是 90 天数据的实际分析结果：

**模式检测** — 发现体脂率与体重强相关（r=0.91, p<0.001），热量摄入可预测次日睡眠时长（r=0.40, lag 1d, p=0.0001）。

**趋势分析** — 体重以 -0.039 kg/天下降（R²=0.84），90 天内从 75.9 降至 71.6 kg。

**异常检测** — 标记 9 次异常体重骤降，集中在 2 月中旬和 3 月中旬的恢复期。

**试验分析** — 蛋白质-睡眠试验（已完成）：效应量 d=0.94，睡眠质量从 6.98 升至 7.64，但因混杂因素（热量 +32%、运动 +86%）置信度评为「低」。

完整演示输出见 [`docs/demo-output/`](docs/demo-output/)。

---

## OpenClaw 兼容

太医院**原生兼容 OpenClaw**。整个系统就是 Markdown 智能体提示 + MCP 工具——与 OpenClaw 使用完全相同的基础组件。

### 为什么开箱即用

| 组件 | 格式 | OpenClaw 对应 |
|------|------|--------------|
| `SKILL.md` | Markdown 提示 | `skill.md` 编排器 |
| `agents/*.md` | 9 个 Markdown 智能体提示 | 各智能体 `skill.md` |
| PubMed、bioRxiv | MCP 工具 | ClawHub MCP 技能服务器 |
| 多智能体调度 | 编排器 → 子智能体 | OpenClaw 多智能体路由 |
| SQLite + Python 脚本 | Bash 工具调用 | OpenClaw 工具执行 |

### 在 OpenClaw 上部署

```bash
# 1. 克隆仓库
git clone https://github.com/albert-ying/longevity-os.git

# 2. 初始化数据库
cd longevity-os && python scripts/setup.py

# 3. 复制智能体提示到 OpenClaw 工作区
cp SKILL.md ~/.openclaw/skills/longevity/skill.md
cp agents/*.md ~/.openclaw/skills/longevity/agents/

# 4. 通过 ClawHub 或本地配置启用 MCP 工具（PubMed、bioRxiv）
```

10 个智能体各自可作为独立的 OpenClaw 技能使用——你可以部署完整系统，也可以只选单个模块（如只用膳食追踪或 N-of-1 试验引擎）。

### OpenClaw 上的多智能体模式

御医（编排器）模式直接映射到 OpenClaw 的[多智能体路由](https://docs.openclaw.ai/concepts/multi-agent)：一个常驻编排智能体处理用户对话，按需派生子智能体并行执行任务。通过 WhatsApp、Telegram、Slack、Discord 或 iMessage 均可交互。

---

## 快速开始

### Claude Code

```bash
# 1. 初始化数据库
cd ~/Desktop/Projects/2026/longevity-os
python scripts/setup.py

# 2. 启动仪表板
python dashboard/server.py

# 3. 打开 http://localhost:8420
```

主交互界面为 Claude Code 自然语言：
```
/longevity 午饭吃了烤三文鱼配糙米和西兰花
/longevity 出周报
/longevity 最近睡眠怎么样？
/longevity 帮我设计一个蛋白质-睡眠试验
```

### OpenClaw

将技能复制到 OpenClaw 工作区后（见[上方部署说明](#在-openclaw-上部署)），即可通过任意连接平台交互：

```
@longevity 午饭吃了烤三文鱼配糙米和西兰花
@longevity 出周报
@longevity 最近睡眠怎么样？
```

---

## 九科总览

| 科室 | 智能体 | 核心能力 |
|------|--------|----------|
| **食医科** | 食医 | USDA 营养查询、食谱学习、中菜食材拆解 |
| **导引科** | 导引师 | 运动记录、训练量追踪、肌群平衡、RPE 趋势 |
| **诊脉科** | 诊脉师 | 体重、血压、心率、HRV、睡眠、血糖、自定义指标 |
| **验方科** | 验方师 | 化验结果、参考范围标记、变化率预警 |
| **本草科** | 本草师 | 补剂方案、相互作用检查（NIH ODS）、试验依从性 |
| **试效科** | 试效师 | 方案执行监测、每日观察、完成度追踪 |
| **院判** | 院判 | 文献检索（PubMed + bioRxiv）、方案设计、效力分析 |
| **医正** | 医正 | 独立审查、文献核实、混杂因素识别 |
| **报告科** | 报告师 | 日报、周报、文献佐证的建议 |

---

## 文件结构

```
longevity-os/
├── SKILL.md                    # 御医总调度（主入口）
├── agents/                     # 9 位智能体系统提示
├── dashboard/
│   ├── dashboard.html          # 浅色宣纸主题，中英双语
│   └── server.py               # Python 标准库 HTTP 服务器
├── data/
│   ├── schema.sql              # 17 张表、25+ 索引
│   ├── db.py                   # TaiYiYuanDB 数据库接口
│   └── nutrition_api.py        # USDA + Open Food Facts
├── modeling/
│   ├── engine.py               # 滚动统计、趋势、异常检测
│   ├── patterns.py             # 跨模块相关性扫描
│   └── causal.py               # ITS、贝叶斯 STS、效力分析
├── scripts/                    # 初始化、备份、导入、导出
└── docs/
    ├── architecture.svg        # 系统架构图
    ├── agent-flow.svg          # 调度流程图
    ├── characters/             # 10 位智能体 Q 版形象
    ├── screenshots/            # 仪表板截图
    └── demo-output/            # 建模引擎演示输出
```

---

## 数据隐私

所有健康数据存储于本地 SQLite 数据库，文件权限 `0600`（仅所有者可读写）。无云端同步。无遥测。营养查询仅发送食材名称，绝不包含健康数据。仪表板仅绑定 `127.0.0.1`。文献检索通过 Claude MCP 工具——你的健康数据永远不会出现在搜索请求中。

---

## 技术栈

- **AI**：10 个 Markdown 智能体提示——Claude Code、OpenClaw 或任何 MCP 兼容平台均可运行
- **工具**：MCP 协议（PubMed、bioRxiv、USDA 营养 API）
- **数据库**：SQLite，WAL 日志模式
- **建模**：scipy, statsmodels, numpy, pandas + 自定义贝叶斯 STS
- **仪表板**：单 HTML 文件，Chart.js 4.x，中英双语 i18n
- **服务器**：Python 标准库（零外部依赖）

---

<p align="center">
  📖 <a href="README.md">English Documentation</a>
</p>
