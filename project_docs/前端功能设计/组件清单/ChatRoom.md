# ChatRoom

聊天室容器组件——受控展示件（无 API 依赖，SSE 数据流归页面级，见 `../页面设计/`）。

## Props

| prop | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| messages | Array | `[]` | 消息列表，项 `{ content, isUser, time, type? }` |
| connectionStatus | String | `'disconnected'` | 连接状态（connecting/connected/error/disconnected，页面级维护） |
| aiType | String | `'default'` | AI 类型（`'love'` 恋爱大师 / `'super'` 超级智能体）——控制头像选择 |

## Events

| event | 载荷 | 说明 |
| --- | --- | --- |
| send-message | String | 用户输入的消息文本（组件内已清空输入框） |

## Slots

无（消息渲染完全由 messages 驱动）。

## Methods / 内部状态

| 项 | 说明 |
| --- | --- |
| inputMessage / messagesContainer | ref：输入框值 / 消息容器滚动锚点 |
| aiAvatar（computed） | 按 aiType 选 `/ai-love-avatar.png` 或 `/ai-super-avatar.png` |
| sendMessage() | 空输入短路 → emit('send-message') → 清空 |
| formatTime(timestamp) | zh-CN HH:mm |
| scrollToBottom() | nextTick 后滚动到底部；双 watch（消息数 / 全量 content 拼接串变化）+ onMounted 三触发点 |

## 依赖关系

- 子组件：AiAvatarFallback（头像 onError 兜底）
- 消费方：LoveMaster.vue（aiType=love）、SuperAgent.vue（aiType=super）

## 使用示例

```vue
<ChatRoom
  :messages="messages"
  :connection-status="connectionStatus"
  ai-type="love"
  @send-message="sendMessage"
/>
```
