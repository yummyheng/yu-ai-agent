# api 封装 connectSSE

`yum-ai-agent-frontend/src/api/index.js`——API 层唯一封装件（axios 基座 + SSE 通用连接）。

## 导出面

| 导出 | 形态 | 说明 |
| --- | --- | --- |
| `connectSSE(url, params, onMessage?, onError?)` | 函数 | 通用 SSE 连接：query 拼接（encodeURIComponent）→ `new EventSource` → onmessage 透传 chunk（`[DONE]` 特殊标记原样透传）→ onerror 关连接；返回 EventSource 实例（页面持有生命周期） |
| `chatWithLoveApp(message, chatId)` | 函数 | `connectSSE('/ai/love_app/chat/sse', { message, chatId })` 直达 |
| `chatWithManus(message)` | 函数 | `connectSSE('/ai/manus/chat', { message })` 直达 |
| default | axios 实例 | baseURL 环境自适应（开发 `http://localhost:8123/api` / 生产 `/api`）+ timeout 60s |

## 契约要点

- **`[DONE]` 结束标记**：服务端流末尾约定（消费方判断后 close）；本层不做终止判断，透传给页面
- **SSE 不走 axios**：原生 EventSource（axios 不支持流式）；axios 仅作非流式预留基座

## 依赖关系

- 消费方：LoveMaster.vue（chatWithLoveApp）、SuperAgent.vue（chatWithManus）
- 后端契约真源：`../../api-docs/接口文档.md` §3.2（love sse）/ §4.1（manus chat）

## 使用示例

```js
const es = chatWithLoveApp(message, chatId.value)
es.onmessage = (event) => { /* chunk = event.data；'[DONE]' 时 close */ }
```
