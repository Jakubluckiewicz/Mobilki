import SwiftUI

struct ContentView: View {
    let myName = "Jakub"

    @State private var firstName: String = ""
    @State private var surname: String = ""
    @State private var message: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                TextField("Enter your name", text: $firstName)
                    .padding(10)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.words)
                    .onChange(of: firstName) { oldValue, newValue in
                        message = updateMessage(newFirstName: newValue, newSurname: surname)
                    }

                TextField("Enter your surname", text: $surname)
                    .padding(10)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.words)
                    .onChange(of: surname) { oldValue, newValue in
                        message = updateMessage(newFirstName: firstName, newSurname: newValue)
                    }

                Text(message)
                    .padding(10)

                NavigationLink(destination: SecondView(surname: $surname)) {
                    Text("Go to the second view")
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(10)
            }
            .padding(10)
        }
    }

    func updateMessage(newFirstName: String, newSurname: String) -> String {
        if newFirstName == myName {
            return "Hello \(newFirstName) \(newSurname)! We have the same name"
        } else {
            return "Hello \(newFirstName) \(newSurname)"
        }
    }
}

#Preview {
    ContentView()
}
