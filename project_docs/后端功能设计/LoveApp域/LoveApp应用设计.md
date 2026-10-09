# LoveApp 应用设计

`app/LoveApp.java`（198 行）——恋爱大师 AI 对话应用（@Component）。

## ChatClient 装配（构造器）

`SYSTEM_PROMPT`（恋爱心理专家人设：单身/恋爱/已婚三状态引导）+ `MessageChatMemoryAdvisor(MessageWindowChatMemory, 20 条窗)` + `MyLoggerAdvisor`。

## 六能力面

| # | 能力 | 方法 | 关键机制 |
| --- | --- | --- | --- |
| 1 | 基础对话 | `doChat(message, chatId)` | chatId 会话记忆键（CONVERSATION_ID param） |
| 2 | 流式对话 | `doChatByStream(message, chatId)` | Flux content——Controller 三 SSE 形态的消费源（§3.2/3.3/3.4） |
| 3 | 结构化输出 | `doChatWithReport(message, chatId)` | record `LoveReport(title, suggestions)` + `.entity()` 自动反序列化 |
| 4 | RAG 问答 | `doChatWithRag(message, chatId)` | QueryRewriter 查询改写 → `QuestionAnswerAdvisor(loveAppVectorStore)` |
| 5 | 工具调用 | `doChatWithTools(message, chatId)` | `.toolCallbacks(allTools)`（Tools域 注册面同源） |
| 6 | MCP 服务 | `doChatWithMcp(message, chatId)` | `.toolCallbacks(toolCallbackProvider)`（MCP client 配置注释态） |

**暴露面事实**：Controller 只消费能力 1/2（接口文档 §3.x）；能力 3-6 为 demo 面（仅 LoveAppTest 消费）——学习六种 Spring AI 调用形态的主线。

## 记忆与 Advisor 面

| 件 | 行数 | 状态 | 说明 |
| --- | --- | --- | --- |
| MessageWindowChatMemory(InMemory, 20) | — | 现役 | 每会话保留最近 20 条消息窗口 |
| FileBasedChatMemory | 66 | 注释态备选 | 文件持久化（`tmp/chat-memory` 目录） |
| MyLoggerAdvisor | 37 | 现役 | 请求/响应文本 info 日志 |
| ReReadingAdvisor | 41 | 注释态备选 | Re2 重复输入推理增强 |

## 备选实验面（集中登记，注释态零消费）

1. `FileBasedChatMemory`（LoveApp 构造器注释块）——记忆持久化切换实验
2. `ReReadingAdvisor`（LoveApp 构造器注释行）——推理增强实验
3. `loveAppRagCloudAdvisor`（doChatWithRag 注释行）——云知识库顾问（LoveAppRagCloudAdvisorConfig）
4. `pgVectorVectorStore`（doChatWithRag 注释行）——PgVector 检索切换（见 RAG增强链设计.md）
5. `LoveAppRagCustomAdvisorFactory`（doChatWithRag 注释块）——自定义检索器+上下文增强器组合

## 关联

- `RAG增强链设计.md`（能力 4 的链路）；`../../api-docs/接口文档.md` §3（能力 1/2 契约）；`../Tools域/工具族与注册设计.md`（能力 5）
