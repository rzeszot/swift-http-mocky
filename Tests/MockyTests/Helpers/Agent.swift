import Foundation

struct Agent: Identifiable {
    let id: String
    let name: String
}

extension Agent {
    static var smith: Agent {
        .init(id: "smith", name: "Agent Smith")
    }

    static var brown: Agent {
        .init(id: "brown", name: "Agent Brown")
    }
}
