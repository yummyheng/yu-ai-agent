# Spring AI 框架应用设计

Spring AI 1.0.0 在本工程的应用层设计——框架抽象与项目落点的完整映射（素材源：源码实证，2026-10-09）。消费范式两条线：**ChatClient 高级流式 API**（LoveApp 六能力面）与**低层 Prompt/ToolCallingManager 手动控制**（Agent域 ReAct 循环）。

## 1. 核心抽象映射表

| 框架抽象 | 本项目落点 | 所属域 |
| --- | --- | --- |
| `ChatModel` | zhipuaiChatModel（starter 自动装配，单候选按类型注入） | 全局 |
| `ChatClient` | LoveApp 构造器装配（defaultSystem+defaultAdvisors）；BaseAgent 字段持有（YuManus 手动 new 传入） | LoveApp域 / Agent域 |
| `Advisor`（Call/Stream 双接口） | MessageChatMemoryAdvisor / MyLoggerAdvisor / QuestionAnswerAdvisor / ReReadingAdvisor（注释态） | LoveApp域 |
| `ChatMemory` | MessageWindowChatMemory(20 条窗，内存) 现役；FileBasedChatMemory(Kryo 文件) 注释态备选 | LoveApp域 |
| `ToolCallback` / `ToolCallbackProvider` | `allTools` bean（7 工具）/ MCP client provider（配置注释态） | Tools域 |
| `ToolCallingManager` + `ToolCallingChatOptions` | ToolCallAgent 手动执行循环（接管内建机制） | Agent域 |
| `VectorStore` | SimpleVectorStore（内存，@Lazy） | LoveApp域（RAG 链） |
| `Flux` 流式 | doChatByStream（content 流）+ BaseAgent.runStream（SseEmitter 步进推流） | 双域 |

## 2. ChatClient 装配范式（LoveApp 构造器）

```java
chatClient = ChatClient.builder(chatModel)          // 装配期绑定模型
        .defaultSystem(SYSTEM_PROMPT)               // 人设默认值（请求期可 .system() 覆盖追加）
        .defaultAdvisors(                           // 装配期 Advisor（每次请求默认携带）
                MessageChatMemoryAdvisor.builder(chatMemory).build(),
                new MyLoggerAdvisor())
        .build();
```

- **装配期 vs 请求期 Advisor 二分**：defaultAdvisors 全局生效；`doChatWithRag` 等再以 `.advisors(new QuestionAnswerAdvisor(...))` 请求期追加——RAG/工具面只在该能力面生效。
- 记忆实例同处构造：`MessageWindowChatMemory.builder().chatMemoryRepository(new InMemoryChatMemoryRepository()).maxMessages(20)`。

## 3. 请求期 Fluent 链（六能力面公共骨架）

```
chatClient.prompt().user(message)
    .advisors(spec -> spec.param(ChatMemory.CONVERSATION_ID, chatId))  // 记忆路由键
    ├─ .call().chatResponse()                 // 能力1 同步（doChat）
    ├─ .stream().content()                    // 能力2 流式 Flux<String>（+concatWith [DONE]）
    ├─ .call().entity(LoveReport.class)       // 能力3 结构化输出（record 自动反序列化）
    ├─ .advisors(new QuestionAnswerAdvisor(loveAppVectorStore)).call()   // 能力4 RAG
    ├─ .toolCallbacks(allTools).call()        // 能力5 工具（内建自动执行）
    └─ .toolCallbacks(toolCallbackProvider).call()                      // 能力6 MCP
```

- **结构化输出**：`.entity(Class)` 走框架 BeanOutputConverter（JSON Schema 生成→提示词约束→自动反序列化；pom victools 为其声明面支撑）。
- **SSE 结束契约**：`doChatByStream` 以 `.concatWith(Flux.just("[DONE]"))` 补流末标记（2026-10-09 修复：前端 EventSource 收 [DONE] 主动关流）。

## 4. Advisor 链设计

自定义 Advisor 同时实现 `CallAdvisor` + `StreamAdvisor`（同步/流式双通道），`getOrder()` 控链序：

| Advisor | 机制 | 状态 |
| --- | --- | --- |
| MessageChatMemoryAdvisor | 请求前注入会话历史、响应后回写记忆（框架内建） | 现役（装配期） |
| MyLoggerAdvisor | before 观察请求 prompt / after 观察回复文本；流式用 `ChatClientMessageAggregator` 聚合后再观察 | 现役（装配期+请求期追加） |
| QuestionAnswerAdvisor | 检索向量库→增强进 prompt（框架内建，spring-ai-advisors-vector-store） | 现役（doChatWithRag 请求期挂载） |
| ReReadingAdvisor | Re2 范式：`augmentUserMessage` 改写用户提示（复读一遍提升推理） | 注释态备选 |

## 5. ChatMemory 面

- 接口三元：`add(conversationId, messages)` / `get` / `clear`——**conversationId 即记忆路由键**，由请求期 `ChatMemory.CONVERSATION_ID` param 传入（前端 chatId 直通）。
- 现役内存 20 条滑窗；`FileBasedChatMemory`（Kryo 序列化 `conversationId.kryo` 文件，含 `StdInstantiatorStrategy` 实例化策略）为持久化备选——LoveApp 构造器注释态切换。
- Agent域**不走 ChatMemory**：BaseAgent 自持 `List<Message> messageList` 手动维护（工具调用消息由 ToolCallingManager 结果回填）。

## 6. Tool Calling 双范式

### 6.1 内建自动执行（LoveApp 面）
`.toolCallbacks(allTools)` 默认 `internalToolExecutionEnabled=true`：模型返回 ToolCall→框架自动执行→结果回填→继续生成，单次 `.call()` 黑盒完成。

### 6.2 手动接管（Agent域 ReAct 循环）
`ToolCallAgent` 构造器禁用内建机制换取循环控制权：

```java
this.chatOptions = ToolCallingChatOptions.builder()
        .internalToolExecutionEnabled(false).build();   // 模型中立（原 DashScopeChatOptions 退役）
this.toolCallingManager = ToolCallingManager.builder().build();
```

- **think()**：`Prompt(messageList, chatOptions)` + `.tools(availableTools)` 调模型→解析 `AssistantMessage.getToolCalls()`（空=纯文本回复，非空=需行动）。
- **act()**：`toolCallingManager.executeToolCalls(prompt, toolCallChatResponse)` 执行全部工具→`conversationHistory()` 回填消息上下文→嗅探 `doTerminate` 终止工具置 FINISHED。
- 消息记录约定：不调工具时手动记录助手消息；调工具时由 executionHistory 自动带全。

### 6.3 工具注册（Tools域 单点）
`@Tool` 注解 7 工具 → `ToolCallbacks.from(...)` 反射生成 → `ToolCallback[] allTools` bean；与 MCP `ToolCallbackProvider` 并列注入（同属 toolCallbacks 消费面）。详见 `Tools域/工具族与注册设计.md`。

## 7. 流式面双形态

| 形态 | 实现 | 消费端 |
| --- | --- | --- |
| Reactor Flux | `stream().content()` 逐 token 流（模型级流式） | Controller 三 SSE 形态（Flux 直接返回/SSE 包装/SseEmitter 订阅） |
| SseEmitter 步进流 | `BaseAgent.runStream`：`CompletableFuture.runAsync` 异步执行循环，每 step `sseEmitter.send(result)`（步骤级粒度，非 token 级） | `/ai/manus/chat` |

## 8. 模型中立性设计（智谱切换实证）

- **切换面收敛在 starter+配置**：`spring-ai-starter-model-zhipuai` 替换 dashscope starter 后，ChatClient/Advisor/ChatMemory/Tool/RAG 六面代码零改动——单候选按类型注入（LoveApp 构造器参数名 `dashscopeChatModel` 是历史命名，类型解析与参数名无关）。
- **两个坑位留痕**：① 多 starter 并存时双 ChatModel 候选撞注入点→`autoconfigure.exclude` 排除 ollama 自动装配；② 模型商私有 Options（DashScopeChatOptions）不可移植→统一 `ToolCallingChatOptions` 通用 builder。
- embedding 同理：zhipuaiEmbeddingModel 按 `EmbeddingModel` 类型注入 SimpleVectorStore。

## 关联

- `后端技术栈总览.md`（依赖与版本面）；`LoveApp域/LoveApp应用设计.md`（六能力面）；`LoveApp域/RAG增强链设计.md`（检索链九件）；`Agent域/ReAct智能体链设计.md`（继承链与状态机）；`Tools域/工具族与注册设计.md`
