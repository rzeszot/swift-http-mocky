import Foundation

public class Response {
    public var status: Int?
    public let headers: Headers = [:]
    public var body: Data?

    public subscript(_ key: String) -> String? {
        get {
            headers[key]
        }
        set(value) {
            headers[key] = value
        }
    }
}

public extension Response {
    func body<T: Encodable>(json: T, using encoder: JSONEncoder) throws {
        body = try encoder.encode(json)
        headers["Content-Type"] = "application/json"
    }

    func body<T: Encodable>(json: T) throws {
        try body(json: json, using: .default)
    }
}

extension JSONEncoder {
    static var `default`: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}
