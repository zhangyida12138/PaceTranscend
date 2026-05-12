import SwiftUI

// MARK: - 境界视觉规范（单一事实来源，保证 iPhone / Watch 一致）

/// 小境界：用于光环刻度与轻微饱和度偏移（不改变大境界主色）。
public enum MinorRealmStage: Int, CaseIterable, Sendable {
    case early = 1
    case mid = 2
    case late = 3
    case peak = 4

    public var title: String {
        switch self {
        case .early: "初期"
        case .mid: "中期"
        case .late: "后期"
        case .peak: "圆满"
        }
    }

    /// 0...1，用于统一微调发光强度，避免每处魔法数。
    public var auraStrength: Double {
        switch self {
        case .early: 0.72
        case .mid: 0.82
        case .late: 0.92
        case .peak: 1.0
        }
    }
}

/// 九大境界：色板、符号、命名全部由此派生，图标与背景只用这里，避免漂移。
public enum MajorRealm: Int, CaseIterable, Sendable {
    case qiIntroduction = 1
    case foundation = 2
    case aperture = 3
    case tranquility = 4
    case goldenCore = 5
    case nascentSoul = 6
    case union = 7
    case tribulation = 8
    case ascension = 9

    public var title: String {
        switch self {
        case .qiIntroduction: "引气入体"
        case .foundation: "筑基培元"
        case .aperture: "开光通窍"
        case .tranquility: "灵寂虚度"
        case .goldenCore: "金丹凝练"
        case .nascentSoul: "元神出窍"
        case .union: "合体期"
        case .tribulation: "渡劫期"
        case .ascension: "大乘飞升"
        }
    }

    /// SF Symbol：同一视觉语言（圆/气/光/雷），表盘小尺寸仍可辨。
    public var symbolName: String {
        switch self {
        case .qiIntroduction: "wind"
        case .foundation: "leaf.circle"
        case .aperture: "sun.max.circle"
        case .tranquility: "moon.stars.circle"
        case .goldenCore: "circle.circle"
        case .nascentSoul: "sparkles"
        case .union: "person.2.circle"
        case .tribulation: "cloud.bolt.circle"
        case .ascension: "crown.fill"
        }
    }

    /// 主色：仙气冷调为主，高境界略偏金银与电紫。
    public var primary: Color {
        switch self {
        case .qiIntroduction: Color(red: 0.55, green: 0.92, blue: 0.78)
        case .foundation: Color(red: 0.35, green: 0.78, blue: 0.72)
        case .aperture: Color(red: 0.98, green: 0.82, blue: 0.45)
        case .tranquility: Color(red: 0.72, green: 0.62, blue: 0.95)
        case .goldenCore: Color(red: 0.98, green: 0.62, blue: 0.28)
        case .nascentSoul: Color(red: 0.45, green: 0.92, blue: 0.98)
        case .union: Color(red: 0.98, green: 0.72, blue: 0.82)
        case .tribulation: Color(red: 0.62, green: 0.48, blue: 0.98)
        case .ascension: Color(red: 0.95, green: 0.94, blue: 0.88)
        }
    }

    public var secondary: Color {
        switch self {
        case .qiIntroduction: Color(red: 0.82, green: 0.98, blue: 0.95)
        case .foundation: Color(red: 0.55, green: 0.92, blue: 0.85)
        case .aperture: Color(red: 0.98, green: 0.94, blue: 0.62)
        case .tranquility: Color(red: 0.88, green: 0.78, blue: 0.98)
        case .goldenCore: Color(red: 0.98, green: 0.88, blue: 0.42)
        case .nascentSoul: Color(red: 0.72, green: 0.55, blue: 0.98)
        case .union: Color(red: 0.98, green: 0.85, blue: 0.72)
        case .tribulation: Color(red: 0.42, green: 0.78, blue: 0.98)
        case .ascension: Color(red: 0.98, green: 0.92, blue: 0.72)
        }
    }

    public var mist: Color {
        primary.opacity(0.35)
    }

    public static func clampedMajor(_ raw: Int) -> MajorRealm {
        let v = min(max(raw, 1), 9)
        return MajorRealm(rawValue: v) ?? .qiIntroduction
    }

    public static func clampedMinor(_ raw: Int) -> MinorRealmStage {
        let v = min(max(raw, 1), 4)
        return MinorRealmStage(rawValue: v) ?? .early
    }
}

// MARK: - 全局动效 token（雷劫与光环共用节奏）

public enum XiuxianMotion: Sendable {
    public static let sealPulse = Animation.easeInOut(duration: 2.8).repeatForever(autoreverses: true)
    public static let tribulationIntro = Animation.easeOut(duration: 0.35)
    public static let tribulationPeak = Animation.spring(response: 0.55, dampingFraction: 0.72)
    public static let tribulationOutro = Animation.easeInOut(duration: 0.45)
}
