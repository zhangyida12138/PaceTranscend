import Combine
import Foundation
import SwiftUI

// MARK: - 升级曲线（与 docs/DESIGN.md 公式一致，Base 可调）

public enum CultivationCurve: Sendable {
    public static var base: Double = 100

    /// 当前小境界升满所需 EXP（未满圆满时用于进度条；圆满时亦为渡劫前容量上限）。
    public static func expRequired(major: Int, minor: Int) -> Double {
        let m = max(1, min(major, 9))
        let n = max(1, min(minor, 4))
        return base * pow(Double(m), 3) * (Double(n) * 1.2)
    }
}

// MARK: - 纯前端持久化（App Group 容器内 JSON，无服务端）

@MainActor
public final class CultivationLocalStore: ObservableObject {
    public static let shared = CultivationLocalStore()
    public static let appGroupIdentifier = "group.com.pacetranscend.PaceTranscend"
    private static let fileName = "cultivation_state.json"

    @Published public private(set) var major: Int = 1
    @Published public private(set) var minor: Int = 1
    @Published public private(set) var experience: Double = 0
    /// 小境界圆满且经验已满，等待渡劫突破大境界。
    @Published public private(set) var awaitingTribulation: Bool = false

    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.outputFormatting = [.sortedKeys, .prettyPrinted]
        return e
    }()

    private let decoder = JSONDecoder()

    private struct Snapshot: Codable, Equatable {
        var major: Int
        var minor: Int
        var experience: Double
        var awaitingTribulation: Bool
    }

    private init() {
        load()
    }

    public var majorRealm: MajorRealm { MajorRealm.clampedMajor(major) }
    public var minorStage: MinorRealmStage { MajorRealm.clampedMinor(minor) }

    public func expRequiredNow() -> Double {
        CultivationCurve.expRequired(major: major, minor: minor)
    }

    public var progressUnit: Double {
        let need = expRequiredNow()
        guard need > 0 else { return 0 }
        return min(1, experience / need)
    }

    /// 从磁盘重新读取（手表与手机切换前台时调用，便于共享容器写入后刷新）。
    public func reloadFromDisk() {
        load()
    }

    /// 增加修为（未满圆满时自动晋升小境界；圆满则封顶并等待渡劫）。
    public func gainSpirit(_ amount: Double) {
        guard amount > 0, !awaitingTribulation else { return }
        var exp = experience + amount

        while minor < 4 {
            let need = CultivationCurve.expRequired(major: major, minor: minor)
            if exp >= need {
                exp -= need
                minor += 1
            } else {
                experience = exp
                save()
                return
            }
        }

        let cap = CultivationCurve.expRequired(major: major, minor: 4)
        if exp >= cap {
            experience = cap
            awaitingTribulation = true
        } else {
            experience = exp
        }
        save()
    }

    public func resolveTribulationSuccess() {
        guard awaitingTribulation, minor == 4 else { return }
        if major < 9 {
            major += 1
            minor = 1
        }
        // 第九境圆满：渡劫成功仅清劫数状态，仍保持大乘圆满位格。
        experience = 0
        awaitingTribulation = false
        save()
    }

    public func resolveTribulationFailure() {
        guard awaitingTribulation else { return }
        experience = max(0, experience * 0.8)
        awaitingTribulation = false
        save()
    }

    public func resetProgress() {
        major = 1
        minor = 1
        experience = 0
        awaitingTribulation = false
        save()
    }

    private func load() {
        guard let url = persistenceURL() else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        guard let snap = try? decoder.decode(Snapshot.self, from: data) else { return }
        major = max(1, min(9, snap.major))
        minor = max(1, min(4, snap.minor))
        experience = max(0, snap.experience)
        awaitingTribulation = snap.awaitingTribulation

        if minor < 4 {
            awaitingTribulation = false
        } else {
            let cap = CultivationCurve.expRequired(major: major, minor: 4)
            if experience >= cap {
                experience = cap
                awaitingTribulation = true
            } else {
                awaitingTribulation = false
            }
        }
    }

    private func save() {
        guard let url = persistenceURL() else { return }
        let snap = Snapshot(
            major: major,
            minor: minor,
            experience: experience,
            awaitingTribulation: awaitingTribulation
        )
        do {
            let data = try encoder.encode(snap)
            try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: url, options: [.atomic])
        } catch {
            // 纯前端：失败时仅保持内存态；上架前可在 Xcode 确认 App Group 已开启。
        }
    }

    private func persistenceURL() -> URL? {
        if let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Self.appGroupIdentifier) {
            return container.appendingPathComponent("Library/Application Support", isDirectory: true)
                .appendingPathComponent(Self.fileName, isDirectory: false)
        }
        #if os(iOS)
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return base?.appendingPathComponent(Self.fileName)
        #elseif os(watchOS)
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return base?.appendingPathComponent(Self.fileName)
        #else
        return nil
        #endif
    }
}
