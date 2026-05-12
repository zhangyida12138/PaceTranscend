import SwiftUI

struct WatchContentView: View {
    @EnvironmentObject private var store: CultivationLocalStore
    @Environment(\.scenePhase) private var scenePhase

    @State private var tribulationVisible = false
    @State private var tribulationKind: TribulationOutcome = .success

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                RealmSealIconView(major: store.majorRealm, minor: store.minorStage, size: 64, showMistParticles: false)

                Text("\(store.majorRealm.title) · \(store.minorStage.title)")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                ProgressView(value: store.progressUnit)
                    .tint(store.majorRealm.primary)

                Button("+灵力") {
                    store.gainSpirit(80)
                }

                if store.awaitingTribulation {
                    HStack(spacing: 6) {
                        Button("成劫") {
                            tribulationKind = .success
                            tribulationVisible = true
                        }
                        Button("败劫") {
                            tribulationKind = .failure
                            tribulationVisible = true
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(.vertical, 8)
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
}

#if DEBUG
#Preview {
    WatchContentView()
        .environmentObject(CultivationLocalStore.shared)
}
#endif
