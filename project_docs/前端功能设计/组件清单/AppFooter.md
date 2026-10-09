# AppFooter

全站页脚（三页面复用）。

## Props

无。

## Events

无。

## Slots

无（纯静态展示 + 外链）。

## Methods / 内部状态

| 项 | 说明 |
| --- | --- |
| currentYear（computed） | 动态年份 `new Date().getFullYear()` |

## 依赖关系

- 消费方：Home.vue / LoveMaster.vue / SuperAgent.vue
- 外链：GitHub 仓库（liyupi/yu-ai-agent）等静态链接

## 使用示例

```vue
<AppFooter />
```
