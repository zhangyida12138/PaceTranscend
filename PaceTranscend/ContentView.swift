import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: CultivationLocalStore
    @Environment(\.scenePhase) private var scenePhase

    @State private var tribulationVisible = false
    @State private var tribulationKind: TribulationOutcome = .success

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    RealmSealIconView(major: store.majorRealm, minor: store.minorStage, size: 112, showMistParticles: true)

                    VStack(spacing: 6) {
                        Text(store.majorRealm.title)
                            .font(.title2.weight(.semibold))
                        Text(store.minorStage.title)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }

                    progressSection

                    VStack(spacing: 12) {
                        Button("吐纳 · 吸纳灵力 (+120)") {
                            store.gainSpirit(120)
                        }
                        .buttonStyle(.borderedProminent)

                        if store.awaitingTribulation {
                            HStack(spacing: 12) {
                                Button("渡劫 · 成") {
                                    tribulationKind = .success
                                    tribulationVisible = true
                                }
                                .buttonStyle(.bordered)

                                Button("渡劫 · 败") {
                                    tribulationKind = .failure
                                    tribulationVisible = true
                                }
                                .buttonStyle(.bordered)
                            }
                        }

                        Button("重开仙途（清空本地存档）", role: .destructive) {
                            store.resetProgress()
                        }
                        .font(.footnote)
                    }
                    .padding(.top, 8)

                    Text("修为仅存于本机 App Group 容器 JSON，无后端。")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 12)
                }
                .padding()
            }
            .navigationTitle("步履飞升")
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                store.reloadFromDisk()
            }
        }
        .overlay {
            if tribulationVisible {
                TribulationOutcomeOverlay(
                    outcome: tribulationKind,
                    isPresented: $tribulationVisible,
                    onFinished: {
                        switch tribulationKind {
                        case .success:
                            store.resolveTribulationSuccess()
                        case .failure:
                            store.resolveTribulationFailure()
                        }
                    }
                )
            }
        }
    }

    private var progressSection: some View {
        let need = store.expRequiredNow()
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("灵力修为")
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text("\(Int(store.experience)) / \(Int(need))")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: store.progressUnit)
                .tint(store.majorRealm.primary)
            if store.awaitingTribulation {
                Text("圆满待劫：需渡雷劫方可突破下一境。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#if DEBUG
#Preview {
    ContentView()
        .environmentObject(CultivationLocalStore.shared)
}
#endif
