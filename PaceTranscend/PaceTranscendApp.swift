import SwiftUI

@main
struct PaceTranscendApp: App {
    @StateObject private var store = CultivationLocalStore.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
