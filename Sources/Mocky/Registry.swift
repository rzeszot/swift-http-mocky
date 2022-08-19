import Foundation

class Registry<T: Identifiable> where T.ID == String {
    private(set) var all: [T] = []

    // MARK: -

    func add(_ value: T) {
        all.append(value)
    }

    func remove(id: String) {
        all.removeAll { $0.id == id }
    }

    func contains(id: String) -> Bool {
        all.contains { $0.id == id }
    }
}
