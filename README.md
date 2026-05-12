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

## 技术方向（规划）

- **平台**：watchOS（主），SwiftUI；Complications（WidgetKit / 表盘复杂功能）。
- **数据**：HealthKit（活动能量、步数、睡眠分期、静息心率、HRV、体能训练、`HKLiveWorkoutBuilder` 等，按实际上线范围裁剪）。
- **存储**：以手表端本地状态为主；如需 iCloud 或 iPhone 同步，在隐私政策中单独说明。

具体 HealthKit 类型与模块拆分见 `pacetranscend` skill。

---

## 仓库状态

当前仓库以**设计与工程指引**为主；Xcode 工程与源码可在本目录下后续添加（例如 `PaceTranscend.xcodeproj` + watchOS target）。

---

## 许可证

未指定；后续可补充 `LICENSE` 文件。
