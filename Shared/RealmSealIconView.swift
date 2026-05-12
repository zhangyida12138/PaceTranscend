import SwiftUI

/// 境界印章图标：同一构图（外环 + 仙气雾 + 符号），仅随 `MajorRealm` / `MinorRealmStage` 变色与强弱变化。
public struct RealmSealIconView: View {
    let major: MajorRealm
    let minor: MinorRealmStage
    var size: CGFloat = 72
    /// 表盘极小时可关粒子以省算力。
    var showMistParticles: Bool = true

    @State private var pulse: CGFloat = 0

    public init(major: MajorRealm, minor: MinorRealmStage, size: CGFloat = 72, showMistParticles: Bool = true) {
        self.major = major
        self.minor = minor
        self.size = size
        self.showMistParticles = showMistParticles
    }

    public var body: some View {
        let aura = minor.auraStrength
        ZStack {
            // 外晕：仙气漫射
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            major.secondary.opacity(0.55 * aura),
                            major.primary.opacity(0.25 * aura),
                            Color.clear,
                        ],
                        center: .center,
                        startRadius: size * 0.08,
                        endRadius: size * 0.62
                    )
                )
                .frame(width: size * 1.35, height: size * 1.35)
                .blur(radius: size * 0.08)
                .scaleEffect(1.0 + pulse * 0.06)

            // 细雾环（时间轴旋转，避免 0→360 循环跳变）
            TimelineView(.animation(minimumInterval: 1.0 / 24.0, paused: false)) { timeline in
                let rotation = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 24) / 24 * 360
                Circle()
                    .stroke(
                        AngularGradient(
                            colors: [
                                major.primary.opacity(0.9),
                                major.secondary.opacity(0.35),
                                major.primary.opacity(0.9),
                            ],
                            center: .center,
                            angle: .degrees(rotation)
                        ),
                        lineWidth: max(2, size * 0.04)
                    )
                    .frame(width: size * 1.05, height: size * 1.05)
                    .blur(radius: 1)
            }

            // 玉质底
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            major.secondary.opacity(0.55),
                            major.primary.opacity(0.42),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay {
                    Circle()
                        .strokeBorder(Color.white.opacity(0.35), lineWidth: 1)
                }
                .shadow(color: major.primary.opacity(0.55), radius: size * 0.12, y: size * 0.04)

            // 小境界刻度（四象）
            MinorTickRing(stage: minor, size: size)

            Image(systemName: major.symbolName)
                .font(.system(size: size * 0.38, weight: .light, design: .rounded))
                .symbolRenderingMode(.palette)
                .foregroundStyle(
                    Color.white.opacity(0.95),
                    major.primary.opacity(0.95)
                )
                .shadow(color: major.secondary.opacity(0.9), radius: size * 0.06)

            if showMistParticles {
                MistParticles(color: major.mist, size: size)
            }
        }
        .frame(width: size * 1.4, height: size * 1.4)
        .accessibilityLabel(Text("\(major.title) \(minor.title)"))
        .onAppear {
            withAnimation(XiuxianMotion.sealPulse) {
                pulse = 1
            }
        }
    }
}

private struct MinorTickRing: View {
    let stage: MinorRealmStage
    let size: CGFloat

    var body: some View {
        let tickCount = 4
        return ZStack {
            ForEach(0..<tickCount, id: \.self) { index in
                Capsule()
                    .fill(Color.white.opacity(index < stage.rawValue ? 0.55 : 0.12))
                    .frame(width: size * 0.06, height: size * 0.16)
                    .offset(y: -size * 0.42)
                    .rotationEffect(.degrees(Double(index) * 90))
            }
        }
    }
}

private struct MistParticles: View {
    let color: Color
    let size: CGFloat

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: false)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, canvasSize in
                let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
                for i in 0..<10 {
                    let phase = t * 0.35 + Double(i) * 0.7
                    let r = size * (0.35 + 0.08 * sin(phase))
                    let angle = phase + Double(i) * 0.55
                    let p = CGPoint(
                        x: center.x + CGFloat(cos(angle)) * r,
                        y: center.y + CGFloat(sin(angle)) * r * 0.85
                    )
                    let dot = CGRect(x: p.x - 1.2, y: p.y - 1.2, width: 2.4, height: 2.4)
                    context.fill(
                        Path(ellipseIn: dot),
                        with: .color(color.opacity(0.15 + 0.12 * sin(phase + Double(i))))
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .frame(width: size * 1.4, height: size * 1.4)
    }
}

#if DEBUG
#Preview("Seal icons") {
    ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 16)], spacing: 24) {
            ForEach(MajorRealm.allCases, id: \.rawValue) { major in
                VStack(spacing: 8) {
                    RealmSealIconView(major: major, minor: .peak, size: 80)
                    Text(major.title)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
    }
}
#endif
