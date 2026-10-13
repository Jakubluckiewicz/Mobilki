import SwiftUI

struct ContentView: View {
    let numberOfPrograms: Int = 4

    @State private var isAlertVisible: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            Image(NSLocalizedString("Filename", comment: "Localized filename"))
                .resizable()
                .scaledToFit()
                .padding(10)

            Button(NSLocalizedString("Button", comment: "Button label")) {
                isAlertVisible = true
            }
            .padding(10)
        }
        .padding(10)
        .alert(alertText(), isPresented: $isAlertVisible) {
            Button("OK", role: .cancel) {}
        }
    }

    func alertText() -> String {
        String(format: NSLocalizedString("AlertText", comment: "Number of programs at the faculty"), numberOfPrograms)
    }
}

#Preview {
    ContentView()
}
