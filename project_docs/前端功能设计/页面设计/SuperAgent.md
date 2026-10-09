# SuperAgent 页面设计

路由 `/super`——AI 超级智能体页（Manus ReAct 流式执行）。与 LoveMaster 同构，差异点如下。

## 与 LoveMaster 的差异

| 面 | LoveMaster | SuperAgent |
| --- | --- | --- |
| API | chatWithLoveApp(message, chatId) | chatWithManus(message) |
| 会话键 | chatId（服务端多轮记忆） | 无——YuManus 每请求 new 实例、实例级 messageList，天然无跨请求记忆（见后端 Agent域设计） |
| 消息形态 | `{ content, isUser, time }` | addMessage 带 `type` 第三参（工具/步骤类消息视觉区分，AI 消息 class 按 type 着色） |
| 首屏引导 | 恋爱咨询引导文案 | 智能体能力引导（搜索/文件/终端等工具说明） |

相同面：eventSource 单实例串行 + aiMessageIndex 增量拼接 + connectionStatus 三态 + useHead SEO + ChatRoom（aiType=super）+ AppFooter。

## 组件装配与关联

- ChatRoom（aiType=super）+ AppFooter
- 后端契约：`../../api-docs/接口文档.md` §4.1（manus/chat 端点）；智能体执行链 → `../../后端功能设计/Agent域/ReAct智能体链设计.md`
