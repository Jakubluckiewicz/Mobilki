import SwiftUI

@main
struct Zad4App: App {
    @StateObject private var store = PeopleStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
