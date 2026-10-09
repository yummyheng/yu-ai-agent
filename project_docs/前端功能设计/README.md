# 前端功能设计 目录说明

## 目的

承接 `yum-ai-agent-frontend/`（Vite + Vue3）的功能区域级设计文档：整端架构、组件 API 清单、页面设计。与后端功能设计平行（仿 gitbook-local 现势形态）。

## 当前目录结构

```
前端功能设计/
├── README.md                  # 本说明
├── 00-前端功能设计索引.md      # 注册表
├── 前端架构设计.md             # 目录结构/路由树/组件树/SSE 消费链
├── 组件清单/                   # 组件 API 文档（6 段形态）
│   ├── 00-组件清单索引.md
│   ├── ChatRoom.md / AppFooter.md / AiAvatarFallback.md / api封装connectSSE.md
└── 页面设计/                   # 3 页面交互与数据流
    ├── 00-页面设计索引.md
    └── Home.md / LoveMaster.md / SuperAgent.md
```

## 当前定位

- 组件清单按 gitbook-local「6 段形态」（props/events/slots/methods/依赖关系/使用示例）逐组件落档
- 页面设计承接 SSE 数据流（eventSource 生命周期/增量拼接/连接状态三态）——ChatRoom 是受控展示件不含数据流
- HelloWorld.vue 脚手架残留不入册

## 建议纳入 / 暂不纳入

- 纳入：新组件/页面落地时的设计与 API 契约
- 暂不纳入：构建配置（vite.config.js 自解释）、一次性调试产物

## 关联文档

- [00-前端功能设计索引.md](00-前端功能设计索引.md)
- [../README.md](../README.md)

## 变更历史

- 2026-10-09 10:35:00：目录建立（cl-20261009-yumai-projectdocs-p1-batch T2）——治理件 + 前端架构设计 + 组件清单 4 件 + 页面设计 3 件首批落档
