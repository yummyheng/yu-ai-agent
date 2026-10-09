# LoveMaster 页面设计

路由 `/love`——AI 恋爱大师聊天页（SSE 流式对话 + 多轮记忆）。

## 状态与数据流

| 状态 | 说明 |
| --- | --- |
| messages | 消息列表 `{ content, isUser, time }` |
| chatId | 会话 ID，onMounted 生成 `'love_' + 随机串`（服务端记忆隔离键，见接口文档 §3.1 chatId 参数） |
| connectionStatus | connecting / disconnected / error 三态流转 |
| eventSource | 模块级单实例（发送前先 close 旧连接） |

## 发送链（核心交互）

```
ChatRoom @send-message → sendMessage(message)
  1. addMessage(message, true)          // 用户消息入列
  2. eventSource?.close()               // 关旧流（串行会话）
  3. aiMessageIndex = messages.length; addMessage('', false)  // 预占 AI 回复位
  4. connectionStatus='connecting'; eventSource = chatWithLoveApp(message, chatId)
  5. onmessage: chunk !== '[DONE]' → messages[aiMessageIndex].content += chunk（打字机增量拼接）
  6. '[DONE]' → disconnected + close；onerror → error + close
```

## 组件装配

- ChatRoom（aiType=love，props 下传三态）+ AppFooter
- useHead（AI恋爱大师 SEO 元数据）

## 关联

- `../组件清单/ChatRoom.md`、`../组件清单/api封装connectSSE.md`
- 后端契约：`../../api-docs/接口文档.md` §3.2（SSE 端点）/ LoveApp 域（记忆机制 → `../../后端功能设计/LoveApp域/LoveApp应用设计.md`）
