import SwiftUI

/// 雷劫结果：成功 / 失败两套镜头语言一致（同总时长、同阶段结构），仅配色与粒子不同。
public enum TribulationOutcome: Sendable {
    case success
    case failure
}

public struct TribulationOutcomeOverlay: View {
    let outcome: TribulationOutcome
    @Binding var isPresented: Bool
    var onFinished: () -> Void = {}

    @State private var stage: Int = 0
    @State private var boltProgress: CGFloat = 0
    @State private var bloom: CGFloat = 0
    @State private var titleOpacity: Double = 0
    @State private var shake: CGFloat = 0

    public init(outcome: TribulationOutcome, isPresented: Binding<Bool>, onFinished: @escaping () -> Void = {}) {
        self.outcome = outcome
        self._isPresented = isPresented
        self.onFinished = onFinished
    }

    public var body: some View {
        ZStack {
            backdrop
            lightningLayer
            mistBurst
            titleLabel
        }
        .compositingGroup()
        .transition(.opacity.combined(with: .scale(0.98)))
        .onAppear { runSequence() }
        .offset(x: shake)
    }

    private var backdrop: some View {
        Group {
            switch outcome {
            case .success:
                RadialGradient(
                    colors: [
                        Color.black.opacity(0.55),
                        Color(red: 0.25, green: 0.2, blue: 0.45).opacity(0.75),
                        Color.black.opacity(0.9),
                    ],
                    center: .center,
                    startRadius: 40,
                    endRadius: 420
                )
            case .failure:
                RadialGradient(
                    colors: [
                        Color.black.opacity(0.7),
                        Color(red: 0.35, green: 0.05, blue: 0.08).opacity(0.85),
                        Color.black.opacity(0.92),
                    ],
                    center: .center,
                    startRadius: 20,
                    endRadius: 420
                )
            }
        }
        .ignoresSafeArea()
        .opacity(stage >= 0 ? 1 : 0)
    }

    private var lightningLayer: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: false)) { _ in
            Canvas { ctx, size in
                let center = CGPoint(x: size.width / 2, y: size.height * 0.38)
                let bolts: [LightningBolt] = outcome == .success ? successBolts(in: size, center: center) : failureBolts(in: size, center: center)
                for bolt in bolts {
                    var path = bolt.path
                    path = path.trimmedPath(from: 0, to: boltProgress)
                    ctx.stroke(path, with: .color(bolt.color), style: StrokeStyle(lineWidth: bolt.width, lineCap: .round, lineJoin: .round))
                }
            }
            .allowsHitTesting(false)
        }
        .opacity(stage >= 1 ? 1 : 0)
    }

    private var mistBurst: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: burstColors,
                    center: .center,
                    startRadius: 10,
                    endRadius: 260 * bloom
                )
            )
            .scaleEffect(0.2 + bloom * 1.1)
            .blur(radius: 18)
            .opacity(stage >= 2 ? 0.95 : 0)
    }

    private var burstColors: [Color] {
        switch outcome {
        case .success:
            return [
                Color.white.opacity(0.95),
                Color(red: 0.98, green: 0.88, blue: 0.45).opacity(0.75),
                Color(red: 0.45, green: 0.85, blue: 0.98).opacity(0.35),
                Color.clear,
            ]
        case .failure:
            return [
                Color(red: 0.98, green: 0.25, blue: 0.2).opacity(0.55),
                Color(red: 0.35, green: 0.05, blue: 0.12).opacity(0.65),
                Color.purple.opacity(0.25),
                Color.clear,
            ]
        }
    }

    private var titleLabel: some View {
        VStack(spacing: 10) {
            Text(outcome == .success ? "雷劫已过" : "劫数未消")
                .font(.system(.title, design: .rounded))
                .fontWeight(.semibold)
                .foregroundStyle(
                    LinearGradient(
                        colors: outcome == .success
                            ? [Color.white, Color(red: 0.98, green: 0.9, blue: 0.55)]
                            : [Color(red: 1.0, green: 0.75, blue: 0.75), Color(red: 0.65, green: 0.45, blue: 0.95)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: (outcome == .success ? Color.yellow : Color.red).opacity(0.35), radius: 12)
            Text(outcome == .success ? "道基更固，仙气自生" : "修为折损，七日后再渡")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .opacity(titleOpacity)
        .padding(.top, 120)
    }

    private func runSequence() {
        stage = 0
        boltProgress = 0
        bloom = 0
        titleOpacity = 0
        shake = 0

        withAnimation(XiuxianMotion.tribulationIntro) {
            stage = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.easeOut(duration: 0.42)) {
                boltProgress = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.48) {
            withAnimation(XiuxianMotion.tribulationPeak) {
                stage = 2
                bloom = 1
            }
            if outcome == .failure {
                withAnimation(.easeInOut(duration: 0.12).repeatCount(5, autoreverses: true)) {
                    shake = 6
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    shake = 0
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.72) {
            withAnimation(XiuxianMotion.tribulationOutro) {
                titleOpacity = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            withAnimation(.easeInOut(duration: 0.35)) {
                isPresented = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                onFinished()
            }
        }
    }
}

private struct LightningBolt {
    let path: Path
    let color: Color
    let width: CGFloat
}

private func successBolts(in size: CGSize, center: CGPoint) -> [LightningBolt] {
    var bolts: [LightningBolt] = []
    let gold = Color(red: 0.98, green: 0.92, blue: 0.62)
    let cyan = Color(red: 0.65, green: 0.92, blue: 0.98)
    for i in 0..<3 {
        var p = Path()
        let offset = CGFloat(i - 1) * 70
        p.move(to: CGPoint(x: center.x + offset, y: center.y - 120))
        p.addLine(to: CGPoint(x: center.x + offset * 0.4, y: center.y - 40))
        p.addLine(to: CGPoint(x: center.x + offset * 0.9, y: center.y + 10))
        p.addLine(to: CGPoint(x: center.x + offset * 0.2, y: center.y + 90))
        bolts.append(LightningBolt(path: p, color: i.isMultiple(of: 2) ? gold : cyan, width: 3.2))
    }
    return bolts
}

private func failureBolts(in size: CGSize, center: CGPoint) -> [LightningBolt] {
    var bolts: [LightningBolt] = []
    let red = Color(red: 0.98, green: 0.35, blue: 0.35)
    let violet = Color(red: 0.55, green: 0.25, blue: 0.85)
    for i in 0..<4 {
        var p = Path()
        let jitter: CGFloat = [-6, 4, 10, -3][i]
        let spread = CGFloat(i - 1) * 55 + jitter
        p.move(to: CGPoint(x: center.x + spread, y: center.y - 110))
        p.addLine(to: CGPoint(x: center.x - spread * 0.3, y: center.y - 20))
        p.addLine(to: CGPoint(x: center.x + spread * 0.8, y: center.y + 30))
        p.addLine(to: CGPoint(x: center.x - spread * 0.2, y: center.y + 100))
        bolts.append(LightningBolt(path: p, color: i.isMultiple(of: 2) ? red : violet, width: 2.6))
    }
    return bolts
}

#if DEBUG
private struct TribulationPreviewHost: View {
    @State private var showSuccess = false
    @State private var showFailure = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                Button("成功雷劫") { showSuccess = true }
                Button("失败雷劫") { showFailure = true }
            }
            if showSuccess {
                TribulationOutcomeOverlay(outcome: .success, isPresented: $showSuccess)
            }
            if showFailure {
                TribulationOutcomeOverlay(outcome: .failure, isPresented: $showFailure)
            }
        }
    }
}

#Preview("Tribulation") {
    TribulationPreviewHost()
}
#endif
