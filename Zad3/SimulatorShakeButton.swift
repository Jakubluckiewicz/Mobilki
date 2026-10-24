import SwiftUI

struct SimulatorShakeButton: View {
    var body: some View {
        #if targetEnvironment(simulator)
        Button("Shake (simulator)") {
            NotificationCenter.default.post(name: .deviceDidShakeNotification, object: nil)
        }
        .padding(10)
        .foregroundColor(.white)
        .background(Color.gray)
        .cornerRadius(10)
        #else
        EmptyView()
        #endif
    }
}
