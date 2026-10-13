import SwiftUI

struct SecondView: View {
    @Binding var surname: String

    var body: some View {
        VStack(spacing: 10) {
            Text("Your surname")
                .padding(10)

            TextField("Enter your surname", text: $surname)
                .padding(10)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
        }
        .padding(10)
    }
}

#Preview {
    SecondView(surname: .constant("Surname"))
}
