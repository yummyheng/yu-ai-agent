# 后端功能设计 目录说明

## 目的

承接 `yum-ai-agent-backend/` 的功能域级设计文档：按域聚档（仿 gitbook-local 后端功能设计双范式之域聚档）。接口契约不在本目录（归 `../api-docs/`）。

## 当前目录结构

```
后端功能设计/
├── README.md                  # 本说明
├── 00-后端功能设计索引.md      # 域导航注册表
├── LoveApp域/                  # 恋爱大师应用（六能力面 + RAG 增强链）
│   ├── 00-LoveApp域索引.md
│   ├── LoveApp应用设计.md
│   └── RAG增强链设计.md
├── Agent域/                    # ReAct 智能体继承链
│   ├── 00-Agent域索引.md
│   └── ReAct智能体链设计.md
└── Tools域/                    # 工具族与注册
    ├── 00-Tools域索引.md
    └── 工具族与注册设计.md
```

## 当前定位

- 域目录最小形态：`00-<域>索引.md` 承载域级说明与注册（不单建域 README）
- demo 包（invoke 5 形态对照）不入册；五个注释态备选实验面集中登记于所属域「备选实验面」章节
- MCP server（`yum-image-search-mcp-server/`）独立模块留后续批（workload 裁决 1a：归后端功能设计 MCPserver域，P3）

## 关联文档

- [00-后端功能设计索引.md](00-后端功能设计索引.md)
- [../api-docs/接口文档.md](../api-docs/接口文档.md)（接口契约真源）

## 变更历史

- 2026-10-09 10:40:00：目录建立（cl-20261009-yumai-projectdocs-p1-batch T5-T8）——治理件 + 三域四正文首批落档（素材源：orchestrator reports/rp-yumai-domains-deepread-survey 深读调研）
