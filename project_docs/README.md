# yum-ai-agent 项目文档

## 目的

统一承接 `yum-ai-agent` 工作区（Spring AI 学习试点，克隆自 github.com/liyupi/yu-ai-agent）的项目文档：接口契约、前后端功能设计。建册范式仿 gitbook-local 工作区 project_docs（目录类型调研见 orchestrator reports/rp-yumai-projectdocs-pilot-survey）。

## 当前目录

| 目录 | 说明 |
| --- | --- |
| `api-docs/` | 接口契约唯一真源（`接口文档.md`）+ 测试案例 + 端点沿袭派生件（自动生成，禁手改） |
| `前端功能设计/` | 前端功能区域级设计：架构设计 / 组件清单 / 页面设计 |
| `后端功能设计/` | 后端功能域聚档：LoveApp域 / Agent域 / Tools域 |

## 当前定位

- 三模块工程：`yum-ai-agent-backend/`（Spring Boot 8123）、`yum-ai-agent-frontend/`（Vite+Vue3）、`yum-image-search-mcp-server/`（MCP）
- 学习档定位：不承接业务系统开发与常驻服务运行；文档服务学习沉淀与后续改造
- **无数据库**（datasource/PgVector 配置注释态）：无 ddl-docs 目录；服务启动硬前置=有效 dashscope key（云向量库 bean 启动期验 key，详见 `后端功能设计/LoveApp域/RAG增强链设计.md`）

## 暂不直接纳入本目录

- demo 演示件（backend `demo/` 包 invoke 5 形态对照——自解释学习件）
- 脚手架残留（HelloWorld.vue）
- history/reports/开发清单（随首个真实产物滚动建立）

## 关联文档

- [00-项目文档索引.md](00-项目文档索引.md)
- [api-docs/README.md](api-docs/README.md)

## 变更历史

- 2026-10-09 10:30:00：根治理件建立（cl-20261009-yumai-projectdocs-p1-batch T1）——根 README + 00-项目文档索引；目录定位表收编 api-docs 试点与前后端功能设计两平行目录（仿 gitbook-local 现势形态）
