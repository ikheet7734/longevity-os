<p align="center">
  <img src="docs/logo.png" alt="太医院" width="280" />
</p>

<h1 align="center">太医院</h1>
<p align="center"><b>个人长寿优化系统 · Agentic Longevity OS</b></p>

<p align="center">
以明清太医院为蓝本，融合现代统计建模与多智能体协作的健康追踪与 N-of-1 自我实验平台。<br/>
十位 AI 御医各司其职，全部数据本地存储，绝不上云。
</p>

<p align="center">
  <img src="docs/screenshots/dashboard-hero.png" alt="太医院仪表板" width="100%" />
</p>

---

## 架构概述

太医院采用**多智能体调度模式**，御医（总调度）接收用户请求后，分派至九科专属智能体执行。每位智能体具备独立的领域知识与约束规则。N-of-1 试验采用双智能体对抗审查机制，确保安全性与科学严谨性。

<p align="center">
  <img src="docs/architecture.svg" alt="系统架构" width="100%" />
</p>

### 智能体调度流程

用户发出请求后，御医判断意图、分派至相应科室、汇总结构化结果后作答。试验类请求须经院判设计与医正独立安全审查两道关卡。

<p align="center">
  <img src="docs/agent-flow.svg" alt="调度流程" width="100%" />
</p>

## 御医阁（十官）

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
<td align="center"><img src="docs/characters/yuanpan.svg" alt="院判" width="80"/><br/><b>院判</b><br/>试验设计</td>
<td align="center"><img src="docs/characters/yizheng.svg" alt="医正" width="80"/><br/><b>医正</b><br/>安全审查</td>
<td align="center"><img src="docs/characters/baogao.svg" alt="报告" width="80"/><br/><b>报告科</b><br/>报告汇总</td>
</tr>
</table>

---

## 仪表板

仪表板为零依赖本地 HTML 页面，由 Python 标准库 HTTP 服务器托管。宫廷中式美学：深色木质底纹、描金边框、青绿色数据可视化。

### 今日总览

四张汇总卡片：热量摄入、蛋白质、运动时长、睡眠时长，附 7 日均值与迷你趋势图。

<p align="center">
  <img src="docs/screenshots/dashboard-summary.png" alt="今日总览" width="100%" />
</p>

### 营养（食医科）

每日宏量营养素堆叠柱状图（蛋白质、碳水、脂肪）及可交互膳食记录。

<p align="center">
  <img src="docs/screenshots/dashboard-nutrition.png" alt="营养图表" width="100%" />
</p>

### 体征（诊脉科）

体重、心率、心率变异性、睡眠、血压的时间序列图表，含 7 日移动平均线与异常检测。

<p align="center">
  <img src="docs/screenshots/dashboard-metrics.png" alt="体征图表" width="100%" />
</p>

### 导引（导引科）

活动热力图（GitHub 风格）及近期训练日志，含时长、距离、心率与自觉疲劳度。

<p align="center">
  <img src="docs/screenshots/dashboard-exercise.png" alt="运动热力图" width="100%" />
</p>

### 本草（本草科）

当前补剂方案：剂量、频次、服用时间与已服天数。

<p align="center">
  <img src="docs/screenshots/dashboard-supplements.png" alt="补剂方案" width="100%" />
</p>

### 验方（验方科）

生物标志物时间序列：糖化血红蛋白、低密度脂蛋白、高密度脂蛋白、C 反应蛋白、血糖、甘油三酯、促甲状腺激素、维生素 D，含临床参考范围。

<p align="center">
  <img src="docs/screenshots/dashboard-biomarkers.png" alt="生物标志物趋势" width="100%" />
</p>

### 试效（试效科）

N-of-1 试验进度：阶段指示器（基线期 → 干预期 → 洗脱期）与完成百分比。

<p align="center">
  <img src="docs/screenshots/dashboard-trials.png" alt="进行中的试验" width="100%" />
</p>

### 洞察（建模引擎）

AI 生成的健康洞察，标注置信度、效应量与严重程度色码（异常、相关性、趋势、建议、日常）。

<p align="center">
  <img src="docs/screenshots/dashboard-insights.png" alt="建模引擎洞察" width="100%" />
</p>

---

## 快速开始

```bash
# 1. 初始化数据库
cd ~/Desktop/Projects/2026/longevity-os
python scripts/setup.py

# 2. 启动仪表板服务器
python dashboard/server.py

# 3. 打开 http://localhost:8420
```

主交互界面为 Claude Code 中的语音/文字，调用 `/longevity` 或 `/taiyiyuan` 技能。仪表板为只读可视化层。

---

## 使用示例

**记录膳食：**
> "午饭吃了烤三文鱼配糙米和西兰花"

**记录运动：**
> "跑了 5 公里，用时 28 分钟，感觉不错"

**记录体征：**
> "今早体重 72.1 公斤"

**查看状态：**
> "今日总结" 或 "这周蛋白质摄入怎么样？"

**发起试验：**
> "提议一个实验" — 系统检测模式、设计 N-of-1 方案、经医正安全审查后提交审批。

---

## 六部

| 科室 | 职责 |
|------|------|
| 食医科 | 膳食记录、USDA 营养查询、食谱库 |
| 导引科 | 运动记录、训练量追踪、活动热力图 |
| 诊脉科 | 体重、血压、睡眠、心率变异性、自定义指标 |
| 验方科 | 检验结果，含临床与最优参考范围 |
| 本草科 | 补剂方案、药物相互作用检查、依从性 |
| 试效科 | N-of-1 试验监测与分析 |
| 院判 | 循证试验方案设计 |
| 医正 | 独立对抗式安全审查 |
| 报告科 | 日报、周报、趋势摘要 |

## 建模引擎

统计建模引擎贯穿所有科室：

- **滚动统计**：所有追踪指标的 7 日、30 日、90 日均值
- **异常检测**：偏离滚动均值超过 2 个标准差时触发告警
- **趋势分析**：30 日/90 日窗口线性回归
- **跨模块相关性**：带时滞（至多 7 日）的成对分析，Benjamini-Hochberg 多重检验校正
- **因果推断**：间断时间序列分析、贝叶斯结构时间序列（自定义卡尔曼滤波器）
- **效力分析**：基于个体内方差估算最小可检测效应量

---

## 文件结构

```
longevity-os/
├── SKILL.md                          # 御医总调度（主入口）
├── agents/                           # 各科智能体系统提示
│   ├── shiyi.md                      # 食医科
│   ├── daoyin.md                     # 导引科
│   ├── zhenmai.md                    # 诊脉科
│   ├── yanfang.md                    # 验方科
│   ├── bencao.md                     # 本草科
│   ├── shixiao.md                    # 试效科
│   ├── yuanpan.md                    # 院判
│   ├── yizheng.md                    # 医正
│   └── baogao.md                     # 报告科
├── dashboard/
│   ├── dashboard.html                # 宫廷风格单页仪表板
│   └── server.py                     # Python 标准库 HTTP 服务器（8 个 API 端点）
├── data/
│   ├── schema.sql                    # SQLite 模式（17 张表、25+ 索引）
│   ├── db.py                         # 数据库接口（TaiYiYuanDB 类）
│   ├── nutrition_api.py              # USDA + Open Food Facts 营养查询
│   └── migrations/
│       └── 001_init.sql              # 初始模式迁移
├── modeling/
│   ├── engine.py                     # 核心统计引擎
│   ├── patterns.py                   # 模式检测与相关性扫描
│   └── causal.py                     # 因果推断（ITS、贝叶斯 STS）
├── scripts/
│   ├── setup.py                      # 数据库与目录初始化
│   ├── migrate.py                    # 模式迁移执行器
│   ├── backup.py                     # 自动备份（30 日 + 12 月）
│   ├── export.py                     # JSON/CSV 数据导出
│   ├── import_labs.py                # 检验报告解析器（约 150 个标志物别名）
│   └── import_apple_health.py        # Apple Health XML 导入器
└── docs/
    ├── architecture.svg              # 系统架构图
    ├── agent-flow.svg                # 调度流程图
    ├── characters/                   # Q 版宫廷人物插画
    └── screenshots/                  # 仪表板截图
```

---

## 数据隐私

所有健康数据存储于本地 SQLite 数据库（`taiyiyuan.db`），文件权限限定为所有者可读写（`0600`）。不向任何外部服务传输数据。营养查询仅发送食材名称，绝不包含个人健康上下文。仪表板服务器仅绑定 `127.0.0.1`，其他机器无法访问。

---

## 技术栈

- **AI**：Claude Code 多智能体技能系统（10 位智能体）
- **数据库**：SQLite，WAL 日志模式
- **服务器**：Python 标准库 HTTP 服务器（零依赖）
- **仪表板**：单 HTML 文件，Chart.js 4.x
- **建模**：Python（scipy、statsmodels、numpy、pandas）
- **营养 API**：USDA FoodData Central + Open Food Facts

---

<p align="center">
  📖 <a href="README.md">English Documentation</a>
</p>
