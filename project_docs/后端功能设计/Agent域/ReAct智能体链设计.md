# ReAct 智能体链设计

agent 包——Manus 超级智能体（模板方法范式四层继承链）。

## 继承链

| 层 | 类 | 行数 | 职责 |
| --- | --- | --- | --- |
| L1 | `BaseAgent`（抽象） | 170 | 执行骨架：状态机 + 步循环 + 记忆 + 双运行入口 + 资源钩子 |
| L2 | `ReActAgent`（抽象） | 42 | ReAct 范式：`think()`/`act()` 抽象对；`step()` = think→act 组合 |
| L3 | `ToolCallAgent` | 109 | 工具面实现：think=LLM 决策（chatClient+nextStepPrompt+工具清单）/ act=ToolCallback 执行循环 |
| L4 | `YuManus`（@Component） | 26 | 组装：双提示词 + maxSteps=20 + MyLoggerAdvisor + dashscopeChatModel |
| — | `AgentState`（enum） | 22 | IDLE / RUNNING / FINISHED / ERROR 四态 |

## BaseAgent 执行骨架（run / runStream）

```
run(userPrompt):
  校验（state==IDLE && 非空 prompt）→ state=RUNNING → messageList 入列 UserMessage
  → for i < maxSteps(10) && state != FINISHED: step() 逐结果收集（"Step N: …"）
  → 达 maxSteps 强制 FINISHED（防失控护栏）→ finally cleanup()
  异常 → state=ERROR

runStream(userPrompt):                          # SseEmitter 300s
  CompletableFuture.runAsync 异步线程（同上循环，每 step sseEmitter.send 推送）
  + onTimeout（state=ERROR+cleanup）/ onCompletion（RUNNING→FINISHED+cleanup）回调兜底
```

## 关键设计决策

1. **模板方法**：run/runStream 骨架固定在 L1，可变点全压在 `step()`（L2 组合、L3 实现）——新智能体只需继承组装（L4 形态）。
2. **每请求 new 实例**：Controller `doChatWithManus` 每次 `new YuManus(allTools, chatModel)`——messageList 实例级隔离，天然无并发共享；跨请求无记忆（前端 SuperAgent 页无 chatId 与此对齐）。
3. **步数上限双档**：BaseAgent 缺省 10 / YuManus 覆写 20——ReAct 循环的防失控护栏。
4. **SSE 逐 step 而非逐 token**：流式粒度=步骤结果（与 LoveApp 逐 token Flux 形成对照——两套流式形态并存是本工程学习要点）。

## 消费链

Controller `/ai/manus/chat` → `new YuManus(...)` → `runStream`（接口文档 §4.1）；工具面注入 Tools域 `ToolRegistration` 全量注册。

## 备选实验面

无（本域全部现役零注释态）。

## 关联

- `../Tools域/工具族与注册设计.md`（act 面工具来源）；`../../api-docs/接口文档.md` §4.1；前端 `../../前端功能设计/页面设计/SuperAgent.md`
