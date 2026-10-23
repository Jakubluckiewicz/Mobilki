import SwiftUI

struct PersonFormView: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let onSave: (Person) -> Void

    @State private var person: Person
    @State private var hasBirthDate: Bool
    @State private var birthDate: Date
    @State private var wasSaveTapped = false
    @State private var isShowingErrors = false

    init(title: String, person: Person, onSave: @escaping (Person) -> Void) {
        self.title = title
        self.onSave = onSave
        _person = State(initialValue: person)
        _hasBirthDate = State(initialValue: person.birthDate != nil)
        _birthDate = State(initialValue: person.birthDate ?? Date())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Personal data") {
                    TextField("First name *", text: $person.firstName)
                        .textInputAutocapitalization(.words)
                    errorText(.firstName)

                    TextField("Last name *", text: $person.lastName)
                        .textInputAutocapitalization(.words)
                    errorText(.lastName)

                    Toggle("Birth date", isOn: $hasBirthDate)
                    if hasBirthDate {
                        DatePicker("Date", selection: $birthDate, displayedComponents: .date)
                    }
                    errorText(.birthDate)
                }

                Section("Contact") {
                    TextField("Phone", text: $person.phone)
                        .keyboardType(.phonePad)
                    errorText(.phone)

                    TextField("E-mail *", text: $person.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    errorText(.email)

                    TextField("Address", text: $person.address)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
            .alert("Please fix the errors", isPresented: $isShowingErrors) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errors.map { "- \($0.message)" }.joined(separator: "\n"))
            }
        }
    }

    var editedPerson: Person {
        var result = person
        result.birthDate = hasBirthDate ? birthDate : nil
        return result
    }

    var errors: [ValidationError] {
        PersonValidator.validate(editedPerson)
    }

    @ViewBuilder
    func errorText(_ field: PersonField) -> some View {
        if wasSaveTapped {
            ForEach(errors.filter { $0.field == field }) { error in
                Text(error.message)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }

    func save() {
        wasSaveTapped = true
        if errors.isEmpty {
            onSave(editedPerson)
            dismiss()
        } else {
            isShowingErrors = true
        }
    }
}

#Preview {
    PersonFormView(title: "New person", person: Person()) { _ in }
}
