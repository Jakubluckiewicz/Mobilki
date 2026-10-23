import Foundation

enum PersonField {
    case firstName, lastName, birthDate, phone, email
}

struct ValidationError: Identifiable {
    let id = UUID()
    let field: PersonField
    let message: String
}

enum PersonValidator {
    static func validate(_ person: Person) -> [ValidationError] {
        var errors: [ValidationError] = []

        if person.firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append(ValidationError(field: .firstName, message: "First name is required"))
        }

        if person.lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append(ValidationError(field: .lastName, message: "Last name is required"))
        }

        if let birthDate = person.birthDate, birthDate > Date() {
            errors.append(ValidationError(field: .birthDate, message: "Birth date cannot be in the future"))
        }

        let phone = person.phone.trimmingCharacters(in: .whitespaces)
        if !phone.isEmpty {
            if !isPhoneFormatValid(phone) {
                errors.append(ValidationError(field: .phone, message: "Phone number can contain only digits, spaces, dashes and + at the beginning"))
            } else if phone.filter({ $0.isNumber }).count < 7 {
                errors.append(ValidationError(field: .phone, message: "Phone number must have at least 7 digits"))
            }
        }

        let email = person.email.trimmingCharacters(in: .whitespaces)
        if email.isEmpty {
            errors.append(ValidationError(field: .email, message: "E-mail is required"))
        } else if !isEmailValid(email) {
            errors.append(ValidationError(field: .email, message: "E-mail has an invalid format"))
        }

        return errors
    }

    static func isPhoneFormatValid(_ phone: String) -> Bool {
        NSPredicate(format: "SELF MATCHES %@", "^\\+?[0-9 -]+$").evaluate(with: phone)
    }

    static func isEmailValid(_ email: String) -> Bool {
        NSPredicate(format: "SELF MATCHES %@", "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$").evaluate(with: email)
    }
}
