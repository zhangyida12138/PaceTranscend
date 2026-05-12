import SwiftUI

@main
struct PaceTranscendWatchApp: App {
    @StateObject private var store = CultivationLocalStore.shared

    var body: some Scene {
        WindowGroup {
            WatchContentView()
                .environmentObject(store)
        }
    }
}
