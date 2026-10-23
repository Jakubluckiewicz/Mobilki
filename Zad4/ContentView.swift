import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: PeopleStore

    @State private var isAddingPerson = false
    @State private var personToDelete: Person?
    @State private var isShowingDeleteAlert = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.people) { person in
                    NavigationLink(destination: PersonDetailView(personId: person.id)) {
                        VStack(alignment: .leading) {
                            Text(person.fullName)
                                .font(.headline)
                            Text(person.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        personToDelete = store.people[index]
                        isShowingDeleteAlert = true
                    }
                }
            }
            .overlay {
                if store.people.isEmpty {
                    Text("No people yet")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("People")
            .toolbar {
                Button {
                    isAddingPerson = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isAddingPerson) {
                PersonFormView(title: "New person", person: Person()) { person in
                    store.add(person)
                }
            }
            .alert("Delete person?", isPresented: $isShowingDeleteAlert, presenting: personToDelete) { person in
                Button("Delete", role: .destructive) { store.delete(person) }
                Button("Cancel", role: .cancel) {}
            } message: { person in
                Text("\(person.fullName) will be removed from the list.")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PeopleStore())
}
