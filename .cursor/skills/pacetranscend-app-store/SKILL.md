---
name: pacetranscend-app-store
description: >-
  App Store and privacy checklist for watchOS HealthKit apps: usage
  descriptions, review notes, complications, background modes, and avoiding
  medical claims. Use when preparing PaceTranscend for submission, privacy
  labels, Info.plist health strings, or App Review responses for 步履飞升.
---

# PaceTranscend — App Store 与合规

## 定位

健康与娱乐结合的养成应用，**不**宣称医疗诊断或治疗功效。文案与截图避免「治病」「疗效」等表述。

## Info.plist / 隐私

- 为每个 HealthKit 读取类型配置清晰的 **Privacy - Health Share Usage Description**（及 Update 若适用）。
- 若使用定位（洞天福地）：说明仅用于粗略场景标签，默认不过度精确追踪；提供关闭选项更易过审。
- 若使用麦克风/环境：同上，非核心功能建议可选且默认关。

## App Store Connect

- **隐私营养标签**：勾选「健康与健身」等实际收集或处理类别；若数据仅本机且不导出，按真实情况填写。
- **审核备注**：列出 HealthKit 用途、无服务端存储（若有则需说明加密与保留期）、圆环与睡眠数据如何映射为游戏数值。
- **年龄分级**：按娱乐软件常规选择；无 UGC 时简化。

## watchOS 技术注意

- Complications：遵守 WidgetKit/ClockKit 刷新预算，避免过度后台查询 HealthKit。
- Background：仅申请必需 capability；HealthKit 后台投递配合系统策略。
- 首次启动：先展示价值再请求授权；拒绝授权时降级为手动输入或有限玩法（若产品允许）。

## 常见拒因预防

- 授权说明空洞或与真实读类型不一致。
- 健康数据用于广告或与声明不符的第三方共享。
- 无 HealthKit 使用说明的元数据。

详细产品设计仍以 [docs/DESIGN.md](../../../docs/DESIGN.md) 为准。
