import SwiftUI

struct PersonDetailView: View {
    @EnvironmentObject var store: PeopleStore
    @Environment(\.dismiss) private var dismiss

    let personId: UUID

    @State private var isEditing = false
    @State private var isShowingDeleteAlert = false

    var body: some View {
        if let person = store.person(with: personId) {
            Form {
                Section("Personal data") {
                    row("First name", person.firstName)
                    row("Last name", person.lastName)
                    row("Birth date", person.birthDate?.formatted(date: .long, time: .omitted) ?? "")
                }

                Section("Contact") {
                    row("Phone", person.phone)
                    row("E-mail", person.email)
                    row("Address", person.address)
                }

                Section {
                    Button("Delete person", role: .destructive) {
                        isShowingDeleteAlert = true
                    }
                }
            }
            .navigationTitle(person.fullName)
            .toolbar {
                Button("Edit") {
                    isEditing = true
                }
            }
            .sheet(isPresented: $isEditing) {
                PersonFormView(title: "Edit person", person: person) { edited in
                    store.update(edited)
                }
            }
            .alert("Delete person?", isPresented: $isShowingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    store.delete(person)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("\(person.fullName) will be removed from the list.")
            }
        }
    }

    func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value.isEmpty ? "-" : value)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    let store = PeopleStore()
    return NavigationStack {
        PersonDetailView(personId: store.people[0].id)
    }
    .environmentObject(store)
}
