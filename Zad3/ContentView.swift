import SwiftUI

struct ContentView: View {
    @State private var message = "Listening to gestures..."
    @State private var color: Color = .yellow
    @State private var isShowingDialog = false
    @State private var wasShaken = false
    @State private var isVisible = false
    @State private var isPinching = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Text(message)
                    .font(.title2)
                    .padding(10)

                NavigationLink(destination: SecondView(wasShaken: $wasShaken)) {
                    Text("Go to the second view")
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(10)

                SimulatorShakeButton()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color)
            .contentShape(Rectangle())
            .onTapGesture(count: 3) { self.message = "Triple tap!" }
            .onTapGesture(count: 2) { self.message = "Double tap!" }
            .onTapGesture(count: 1) { self.message = "Tap!" }
            .onLongPressGesture { self.message = "Long press!" }
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        if !isPinching {
                            self.message = "Dragging..."
                        }
                    }
                    .onEnded { value in
                        if !isPinching {
                            self.message = swipeDirection(value.translation)
                        }
                    }
            )
            .simultaneousGesture(
                MagnifyGesture()
                    .onChanged { value in
                        isPinching = true
                        self.message = value.magnification > 1 ? "Pinch out" : "Pinch in"
                    }
                    .onEnded { value in
                        isPinching = false
                        self.message = value.magnification > 1 ? "Zoomed in" : "Zoomed out"
                    }
            )
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
                if isVisible {
                    self.message = "Shaken"
                    isShowingDialog = true
                }
            }
            .confirmationDialog(
                "Do you want to change the background color?",
                isPresented: $isShowingDialog,
                titleVisibility: .visible
            ) {
                Button("Yes") {
                    self.color = ColorHelper.getRandomColor()
                    wasShaken = true
                }
                Button("No", role: .destructive) {}
                Button("Cancel", role: .cancel) {}
            }
            .onAppear { isVisible = true }
            .onDisappear { isVisible = false }
        }
    }

    func swipeDirection(_ translation: CGSize) -> String {
        if abs(translation.width) > abs(translation.height) {
            return translation.width > 0 ? "Swipe right" : "Swipe left"
        } else {
            return translation.height > 0 ? "Swipe down" : "Swipe up"
        }
    }
}

#Preview {
    ContentView()
}
