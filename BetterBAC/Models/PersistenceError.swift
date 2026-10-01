import Foundation

enum PersistenceError: LocalizedError {
    case verificationFailed, unsupportedVersion, invalidRecords

    var errorDescription: String? {
        switch self {
        case .verificationFailed: "Your changes could not be verified. The previous records have been preserved."
        case .unsupportedVersion: "These records were saved by a different app version. They have been preserved."
        case .invalidRecords: "Some saved records could not be read safely. They have been preserved."
        }
    }
}
