import Foundation

final class PeopleStore: ObservableObject {
    @Published var people: [Person] = [
        Person(firstName: "Jan", lastName: "Kowalski", phone: "+48 600 100 200", email: "jan.kowalski@example.com", address: "Białystok, ul. Lipowa 1"),
        Person(firstName: "Anna", lastName: "Nowak", email: "anna.nowak@example.com")
    ]

    func person(with id: UUID) -> Person? {
        people.first { $0.id == id }
    }

    func add(_ person: Person) {
        people.append(person)
    }

    func update(_ person: Person) {
        if let index = people.firstIndex(where: { $0.id == person.id }) {
            people[index] = person
        }
    }

    func delete(_ person: Person) {
        people.removeAll { $0.id == person.id }
    }
}
