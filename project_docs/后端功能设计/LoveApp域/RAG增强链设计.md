# RAG 增强链设计

rag 包 9 件——恋爱大师知识库问答（doChatWithRag）的文档-检索-增强全链。

## 链路分工

```
LoveAppDocumentLoader（resources/document 三篇恋爱 md 加载，38 行）
    ↓
MyTokenTextSplitter（Token 切分，12 行）+ MyKeywordEnricher（AI 元信息富化，11 行）
    ↓
LoveAppVectorStoreConfig（DashScope 云向量库 bean，25 行）★现役
    [备选] PgVectorVectorStoreConfig（22 行，本地 PgVector——datasource 配置注释态）
    ↓
QueryRewriter（查询改写器，27 行——检索前用户口语查询 → 检索友好查询）
    ↓
QuestionAnswerAdvisor(loveAppVectorStore)（Spring AI 内建检索问答顾问，doChatWithRag 现役挂载）
    [备选] LoveAppRagCloudAdvisorConfig（云知识库顾问）
    [备选] LoveAppRagCustomAdvisorFactory + LoveAppContextualQueryAugmenterFactory（自定义检索器+上下文增强器组合）
```

## 关键设计事实

1. **向量库现役=DashScope 云服务**（`LoveAppVectorStoreConfig`）——无本地库依赖（datasource 注释态）。
2. **服务启动硬前置**：该 bean 在 Spring context 启动期**急切创建并远程验证 key**——`application.yml` 中 dashscope api-key 为占位符时实例化即 HTTP 401，整个应用起不来（含 `/api/health`）。配好有效 key 是跑起本工程的第零步（2026-10-09 实测留痕：orchestrator cl-20261009-yumai-api-route-autogen-onboard T6）。
3. **云-PgVector 切换面**：两套 VectorStore 配置类并存（云现役/PgVector 备选），切换=application.yml 启用 datasource+vectorstore 配置并改 doChatWithRag 注释行——链路其余件（loader/splitter/enricher/rewriter）与存储无关零改动。
4. 知识语料：`resources/document/` 三篇（单身篇/恋爱篇/已婚篇 md）。

## 关联

- `LoveApp应用设计.md`（能力 4 消费面）；`../../api-docs/接口文档.md`（无独立端点——RAG 面走 doChat 链不暴露 HTTP）
