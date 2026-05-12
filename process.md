# PaceTranscend 工程进度（process）

> 约定：在 **Mac + Xcode** 完成构建、签名、上架相关动作后，将关键结论追加到本文末尾（保持时间倒序或正序均可，但需统一）。

## 2026-05-12

- 已生成可提交的 **Xcode 工程**：`PaceTranscend.xcodeproj`。
- 目标形态：**iPhone 伴侣应用** + **嵌入式 watchOS App**；**纯前端**，修为写入 **App Group 容器** 内 `cultivation_state.json`（无后端、无登录）。
- 共享代码目录：`Shared/`（境界视觉、雷劫动画、`CultivationLocalStore`）。
- 已配置：`PaceTranscend.entitlements` / `PaceTranscendWatchApp.entitlements` 中的 App Group：`group.com.pacetranscend.PaceTranscend`（与 `CultivationLocalStore.appGroupIdentifier` 一致）。
- 已加入：`PrivacyInfo.xcprivacy`（声明不跟踪）。
- 待你在 Xcode 中完成（未在 Windows 环境验证编译）：
  - Signing：**Team**、Bundle ID 是否与你的开发者账号一致；若修改 Bundle ID，请同步改 App Group 标识与 entitlements。
  - Capabilities：确认 iOS / watchOS 两个 target 均已勾选同一 **App Group**。
  - **App Store Connect**：创建 App 记录、填写隐私问卷、准备截图与 **App Icon**（当前仅 `AccentColor`，上架前需补全图标资源）。
  - 真机：安装 iOS App 后，在 Watch 配套流程中安装表端应用；验证 App Group 在真机是否可用（若失败会回退到 Documents 目录，仅单机）。

## 后续迭代（待办占位）

- [ ] HealthKit 读数映射灵力（与设计文档对齐）
- [ ] Complications / 后台刷新策略
- [ ] 本地化与无障碍审计
