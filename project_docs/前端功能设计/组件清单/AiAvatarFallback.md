# AiAvatarFallback

AI 头像加载失败兜底件——父级头像图 onError 时显示 emoji 渐变圆标。

## Props

| prop | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| type | String | `'default'` | `'love'` → ❤️ 粉渐变；其余（default/super）→ 🤖 蓝渐变 |

## Events

无。

## Slots

无。

## Methods / 内部状态

无逻辑态（纯模板件：`v-if="type === 'love'"` 双分支）。

## 依赖关系

- 消费方：ChatRoom.vue（AI 头像 `<img>` onError 时切换）
- 样式：`.love` / `.default,.super` 双渐变 class

## 使用示例

```vue
<AiAvatarFallback type="love" />
```
