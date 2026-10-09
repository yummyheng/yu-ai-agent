# RAG 增强链设计

rag 包 9 件——恋爱大师知识库问答（doChatWithRag）的文档-检索-增强全链。

## 链路分工

```
LoveAppDocumentLoader（resources/document 三篇恋爱 md 加载，38 行）
    ↓
MyTokenTextSplitter（Token 切分，12 行）+ MyKeywordEnricher（AI 元信息富化，11 行）
    ↓
LoveAppVectorStoreConfig（SimpleVectorStore 内存向量库 bean，47 行）★现役
    [备选] PgVectorVectorStoreConfig（22 行，本地 PgVector——datasource 配置注释态）
    ↓
QueryRewriter（查询改写器，27 行——检索前用户口语查询 → 检索友好查询）
    ↓
QuestionAnswerAdvisor(loveAppVectorStore)（Spring AI 内建检索问答顾问，doChatWithRag 现役挂载）
    [备选] LoveAppRagCloudAdvisorConfig（云知识库顾问）
    [备选] LoveAppRagCustomAdvisorFactory + LoveAppContextualQueryAugmenterFactory（自定义检索器+上下文增强器组合）
```

## 关键设计事实

1. **向量库现役=SimpleVectorStore 内存态**（`LoveAppVectorStoreConfig`，builder 注入 EmbeddingModel=智谱 embedding-3）——无外部库依赖（datasource 注释态），服务重启向量重建。
2. **@Lazy 懒初始化（智谱切换批改造）**：bean 创建期对 3 篇 md 做 AI 富化+向量化（embedding 按 token 计费），故 bean 定义与 LoveApp 注入点**双 @Lazy 配对**——服务启动零余额可用（health/对话/Manus 立即就绪），RAG 首次调用才初始化向量库。历史留痕：改造前急切创建+DashScope key 校验 401 起不来（orchestrator cl-20261009-yumai-api-route-autogen-onboard T6）；@Lazy 单标 bean 无效（@Resource 注入点拉穿）为 429 排障实证。
3. **内存-PgVector 切换面**：两套 VectorStore 配置类并存（内存现役/PgVector 备选），切换=application.yml 启用 datasource+vectorstore 配置并改 doChatWithRag 注释行——链路其余件（loader/splitter/enricher/rewriter）与存储无关零改动。
4. 知识语料：`resources/document/` 三篇（单身篇/恋爱篇/已婚篇 md）。

## 关联

- `LoveApp应用设计.md`（能力 4 消费面）；`../../api-docs/接口文档.md`（无独立端点——RAG 面走 doChat 链不暴露 HTTP）
