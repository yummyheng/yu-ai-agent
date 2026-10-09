# yum-ai-agent API Endpoint Lineage

> Unit-Id: ds-ya-api-endpoint-lineage
> Kind: design-api
> 本文档由 orchestrator 生成器自动生成（controller 源码单源），手改会被重跑覆盖自愈；速查键列可 `curl 'http://localhost:8082/api/decl-keys/lookup?key=<键>'` 直达语义层。

## 端点沿袭总表（自动生成：scripts/generate/api-route-autogen/main.py）

> Api-Anchor: k-autogen-api-lineage
> Datasrc-Fp: c5133f80

### AI 应用接口路由（5）

| 方法 | 路由 | 速查键 | Java 真源 | 文档节 | 用途 |
| --- | --- | --- | --- | --- | --- |
| GET | `/ai/love_app/chat/server_sent_event` | `api-yum_ai_agent-GET-ai-love_app-chat-server_sent_event` | `AiController.java:62` | "3.3 SSE 流式对话（ServerSentEvent 包装形态）":L55-L62 | SSE 流式调用 AI 恋爱大师应用 |
| GET | `/ai/love_app/chat/sse` | `api-yum_ai_agent-GET-ai-love_app-chat-sse` | `AiController.java:50` | "3.2 SSE 流式对话（前端消费主入口）":L45-L54 | SSE 流式调用 AI 恋爱大师应用 |
| GET | `/ai/love_app/chat/sse_emitter` | `api-yum_ai_agent-GET-ai-love_app-chat-sse_emitter` | `AiController.java:77` | "3.4 SSE 流式对话（SseEmitter 形态）":L63-L70 | SSE 流式调用 AI 恋爱大师应用 |
| GET | `/ai/love_app/chat/sync` | `api-yum_ai_agent-GET-ai-love_app-chat-sync` | `AiController.java:38` | "3.1 同步对话":L32-L44 | 同步调用 AI 恋爱大师应用 |
| GET | `/ai/manus/chat` | `api-yum_ai_agent-GET-ai-manus-chat` | `AiController.java:100` | "4.1 流式对话（智能体）":L75-L88 | 流式调用 Manus 超级智能体 |

### 健康检查接口路由（1）

| 方法 | 路由 | 速查键 | Java 真源 | 文档节 | 用途 |
| --- | --- | --- | --- | --- | --- |
| GET | `/health` | `api-yum_ai_agent-GET-health` | `HealthController.java:14` | "5.1 存活探针":L91-L98 | 存活探针（返回固定 ok） |


