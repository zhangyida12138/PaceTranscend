# PaceTranscend（步履飞升）

在 **Apple Watch** 上运行的修仙主题健康养成：把圆环、睡眠、心率与运动数据映射为「灵力」「心境」与境界突破，目标形态为可上架 **App Store** 的 watchOS 应用（可选配 iPhone 伴侣用于说明与深度数据）。

---

## 核心理念

**把自律变成仙力**——跑步是为了「结丹」历练，早睡是为了「滋养元神」。数值与玩法以设计文档为单一事实来源，避免实现与策划漂移。

---

## 文档与 Cursor Skills

| 资源 | 路径 |
|------|------|
| 完整产品设计方案 | [docs/DESIGN.md](docs/DESIGN.md) |
| Agent 实现指引（HealthKit、境界、渡劫、架构） | [.cursor/skills/pacetranscend/SKILL.md](.cursor/skills/pacetranscend/SKILL.md) |
| 公式与数值速查 | [.cursor/skills/pacetranscend/reference-formulas.md](.cursor/skills/pacetranscend/reference-formulas.md) |
| App Store / 隐私 / 审核清单 | [.cursor/skills/pacetranscend-app-store/SKILL.md](.cursor/skills/pacetranscend-app-store/SKILL.md) |

在 Cursor 中开发本仓库时，可通过 **@pacetranscend** 或 **@pacetranscend-app-store** 引用上述技能，让助手严格按既定规则改代码与文案。

---

## 工程与运行（Xcode / Mac）

1. 用 **Xcode 15+** 打开 `PaceTranscend.xcodeproj`。
2. 在 **Signing & Capabilities** 为 *PaceTranscend* 与 *PaceTranscend Watch App* 选择同一 **Team**，并确认 **App Groups** 已启用且包含 `group.com.pacetranscend.PaceTranscend`（与源码中 `CultivationLocalStore.appGroupIdentifier` 一致；若你改名，请三处同步）。
3. 运行 Scheme **PaceTranscend**（会先构建并嵌入 Watch App）。表端可单独在 Xcode 中选择 Watch 目标运行。
4. 修为数据：写入 App Group 容器内 `Library/Application Support/cultivation_state.json`（**纯前端、无服务端**）；未开通 App Group 时回退到各端 `Documents`。

## 仓库状态

- 已包含 **iOS + watchOS** 可编译工程、共享 `Shared/` 模块、隐私清单与上架用占位说明。
- 根目录 **[process.md](process.md)**：记录工程与上架相关进度，请在 Mac 侧完成构建/签名/提审步骤后**追加**更新。

---

## 技术方向（规划）

- **平台**：watchOS（主），SwiftUI；Complications（WidgetKit / 表盘复杂功能）。
- **数据**：HealthKit（活动能量、步数、睡眠分期、静息心率、HRV、体能训练、`HKLiveWorkoutBuilder` 等，按实际上线范围裁剪）。
- **存储（当前实现）**：App Group 内 JSON；无后端。后续若增加 iCloud，需在隐私政策与 App Store 问卷中声明。

具体 HealthKit 类型与模块拆分见 `pacetranscend` skill。

---

## 许可证

未指定；后续可补充 `LICENSE` 文件。
