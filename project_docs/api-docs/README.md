# yum-ai-agent api-docs 目录说明

## 目的

本目录存放 `yum-ai-agent` 后端接口文档，`接口文档.md` 为接口契约的唯一真源（仿 gitbook-local 工作区 `project_docs/api-docs/` 同名目录约定建立）。

与运行时文档的关系：项目自带 springdoc + knife4j（`/api/swagger-ui.html`、`/api/v3/api-docs`），该面由源码注解自动派生，作为联调参考；**契约变更以本目录 `接口文档.md` 为准**，两者不一致时以本目录为准并回改代码注释。

## 目录内容

| 文件 | 性质 | 说明 |
| --- | --- | --- |
| `接口文档.md` | 接口契约正文 | 全部 HTTP 端点的路径/参数/响应结构（当前 6 端点：AI 恋爱大师 4 + Manus 智能体 1 + 健康检查 1） |
| `00-接口标签声明.yaml` | 接口标签 sidecar | 6 路由键→stack（技术栈）/patterns（设计模式）双数组；值全部引 tech_kb 统一词表（37/37 对拍命中，0 自造词）；证据=JavaStructCli 直抓（imports/returns + extends 行号区间读） |

## 新增/变更接口后怎么进速查体系（正式四步链）

1. **改 `接口文档.md`**：新增接口章节（含路径/参数/响应），或变更既有章节的路径/用途
2. **路由总表自动同步**：`python3 ~/orchestrator/scripts/generate/api-route-autogen/main.py --workspace yum-ai-agent`（controller 源码单源幂等重跑——总表/路由卡/lineage 三面同刷，禁止手改生成段）
3. **刷新缓存**：`curl -s -X POST 'http://localhost:8082/api/decl-keys/cache/refresh'`
4. **lookup 验证恰 1 命中**：`curl -s 'http://localhost:8082/api/decl-keys/lookup?key=api-yum_ai_agent-<方法-路径键>'`（键形如 `api-yum_ai_agent-GET-api-health`，路径 `/`→`-`）

运行前置：后端起（`sh scripts/start-yum-ai-agent.sh start`，health 探针就绪）——写回态生成器会跑查询面冒烟（接口测试案例.md「一、查询接口」区 health 样例；AI 端点 SSE/纯文本豁免冒烟归「二、」人工联调面）。

## 暂不直接纳入本目录的内容

- MCP server（`yum-image-search-mcp-server/`）的工具契约——MCP 工具非 HTTP 端点，如需文档另建目录承接
- 前端内部组件 props/events（归 `../前端功能设计/`，目录建立后承接）

## 关联文档

- `接口文档.md`
- `../README.md`（project_docs 根说明）
- `../00-项目文档索引.md`（全册导航）
- `../前端功能设计/前端架构设计.md`（前端 SSE 消费链设计）

## 变更历史

- 2026-10-09 21:00:00：新增 `00-接口标签声明.yaml` 接口标签 sidecar（cl-20261009-yumai-api-tag-sidecar-task_short-s01）——6 路由键→stack/patterns 双数组，值全引 tech_kb 统一词表（spring-ai 子族补册后 37/37 命中）；键集与 route-card sdkRegistry 双向一致
- 2026-10-09 10:45:00：根治理件落地联动（cl-20261009-yumai-projectdocs-p1-batch T9）——关联文档占位行消除（根 README/00-项目文档索引/前端架构设计正式回链）
- 2026-10-09 09:40:00：后端目录更名 `backend/`→`yum-ai-agent-backend/`（对齐 gitbook-local `gitbook-local-backend/` 命名范式，git mv 保留历史）；`接口文档.md` 概述源码路径同步；mvn compile 过 + tag-scan 全量 exit 0（controllers=2/endpoints=6 零漂移）
- 2026-10-09 09:30:00：模块前缀更名 `yu-`→`yum-`——目录 `yu-ai-agent-frontend/`→`yum-ai-agent-frontend/`、`yu-image-search-mcp-server/`→`yum-image-search-mcp-server/`（git mv 保留历史）；配置面同步（backend pom artifactId/name、application.yml 应用名、Dockerfile jar 名 `yum-ai-agent-0.0.1-SNAPSHOT.jar`、mcp-servers.json 服务键与 jar 路径、MCP 侧 pom+3 份 yml、前端 package.json/lock name）；java 包名 com.yupi.* 与 README 上游仓库 URL 不动；backend mvn compile BUILD SUCCESS + tag-scan 全量 exit 0（数据面零漂移）；本目录两文档路径引用同步
- 2026-10-09 09:15:00：后端源码重组同步——根 `src/`+`pom.xml`+`Dockerfile`+`.mvn/`+`mvnw*` 挪入 `backend/`（对称前端模块目录），`接口文档.md` 概述源码路径同步改写；后端 pom lombok 1.18.36→1.18.46（本机 JDK 24 编译兼容，parse-hub 同款先例）；tag-scan 全量探针含 call-chain 复跑 exit 0（数据面 controllers=2/endpoints=6 零漂移）
- 2026-10-08 22:45:00：目录建立首批（rp-yumai-projectdocs-pilot-survey 试点）——`接口文档.md` 初版收录 6 端点 + 路由总表；README 建册说明「契约真源 vs swagger 派生面」双真源关系与简版维护流程
