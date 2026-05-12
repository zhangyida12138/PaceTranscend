---
name: pacetranscend
description: >-
  Implements PaceTranscend (步履飞升), a watchOS cultivation game backed by
  HealthKit: nine realms, EXP from active power and sleep/HRV multipliers,
  tribulations, debuffs, complications, and HKLiveWorkoutBuilder for workouts.
  Use when building this repo, Apple Watch SwiftUI, HealthKit queries, game
  balance, or when the user mentions 步履飞升, 修仙模拟器, 渡劫, 灵力, or
  PaceTranscend.
---

# PaceTranscend（步履飞升）

## Scope

Single source of product rules: always align code and copy with [docs/DESIGN.md](../../../docs/DESIGN.md). Numeric detail: [reference-formulas.md](reference-formulas.md).

## Architecture hints

- **watchOS target**: primary UI (SwiftUI), complications, background refresh where allowed.
- **Optional iOS companion**: onboarding, legal text, deeper charts; sync via WatchConnectivity if needed.
- **HealthKit**: request read types explicitly; document each type in App Store privacy nutrition labels.
- **State**: persist realm, minor stage, total EXP, last-processed HK anchor dates, tribulation cooldowns, debuff flags locally on watch.

## HealthKit mapping (implementation)

| Design concept | Typical HK types |
|----------------|------------------|
| 活动能量 / kcal | `HKQuantityTypeIdentifier.activeEnergyBurned` |
| 步数 | `HKQuantityTypeIdentifier.stepCount` |
| 锻炼时间 | Workouts duration or Apple Exercise Time |
| 睡眠时长 / 阶段 | `HKCategoryTypeIdentifier.sleepAnalysis` |
| 静息心率 | `HKQuantityTypeIdentifier.restingHeartRate` |
| HRV | `HKQuantityTypeIdentifier.heartRateVariabilitySDNN` (or preferred variant) |
| VO2 Max | `HKQuantityTypeIdentifier.vo2Max` |
| 圆环 | Summarize from activity/workout + Move goals or use Fitness-related summaries where API allows |

Use `HKStatisticsCollectionQuery` for daily aggregates; `HKSampleQuery` / `HKAnchoredObjectQuery` for sleep samples and incremental updates.

## Game logic modules

1. **Ingestion**: daily buckets per calendar day (user’s timezone).
2. **Active power**: apply kcal / exercise minutes / steps formulas before multipliers.
3. **Mental multipliers**: sleep bracket, RHR vs rolling baseline, HRV for tribulation success only (unless design extends).
4. **Penalties**: evaluate bedtime (last sleep onset vs 02:00 rule), stand reminders window, ring closure streaks.
5. **Level curve**: `EXP_level = Base * Major^3 * (Minor * 1.2)`; tune `Base` in one constant.
6. **Tribulation**: state machine at minor=4 (圆满); gate major promotion; failure −20% EXP, 7-day lockout.

## UI

- Main: avatar + realm label + dual-tone progress (purple/green sources).
- Tags: 洗髓中 / 走火入魔 / 洞天福地（后者需位置/麦克风权限与 App Review 说明）.
- Workout mode: `HKLiveWorkoutBuilder` + prominent 灵力 feedback.

## Quality and App Store

- No medical claims; frame as wellness / entertainment.
- Health data: minimize collection; prefer on-device processing.
- See companion skill `pacetranscend-app-store` for review checklist.

## When editing

- Keep formulas identical to DESIGN.md and reference-formulas.md unless the user explicitly changes balance.
- Add unit tests for EXP rounding, day boundaries, and tribulation edge cases.
