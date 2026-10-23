import Foundation

struct Person: Identifiable, Equatable {
    var id = UUID()
    var firstName: String = ""
    var lastName: String = ""
    var birthDate: Date?
    var phone: String = ""
    var email: String = ""
    var address: String = ""

    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
