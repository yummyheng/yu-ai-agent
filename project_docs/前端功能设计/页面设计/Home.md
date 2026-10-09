# Home 页面设计

路由 `/`——落地页：平台特性展示 + 双入口导航。

## 交互与数据流

| 项 | 说明 |
| --- | --- |
| useHead | 标题「鱼皮AI超级智能体应用平台 - 首页」+ description/keywords（SEO） |
| navigateTo(path) | `router.push` → `/love`、`/super` 双特性卡片导航 |
| 特性展示 | 恋爱大师 / 超级智能体双卡片（静态文案+图标） |

## 组件装配

- AppFooter（页脚）

无 API 调用、无状态流转（纯静态导航页，523 行主体为模板与样式）。

## 关联

- `../前端架构设计.md`（路由树）、`../组件清单/AppFooter.md`
