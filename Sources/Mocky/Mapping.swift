import Foundation

public typealias Matcher = (URLRequest) -> Bool
public typealias Handler = (Environment) -> Void

public struct Mapping: Identifiable {
    public let matcher: Matcher
    public let handler: Handler
    public let id: String

    public init(matcher: @escaping Matcher, handler: @escaping Handler, id: String) {
        self.matcher = matcher
        self.handler = handler
        self.id = id
    }

    public init(method: String, path: String, handler: @escaping Handler) {
        let id = "\(method) \(path)"
        let matcher: Matcher = { request in
            request.httpMethod == method && request.url?.path(matches: path) == true
        }

        self.init(matcher: matcher, handler: handler, id: id)
    }

    public static func get(path: String, handler: @escaping Handler) -> Mapping {
        .init(method: "GET", path: path, handler: handler)
    }

    public static func post(path: String, handler: @escaping Handler) -> Mapping {
        .init(method: "POST", path: path, handler: handler)
    }

    public static func patch(path: String, handler: @escaping Handler) -> Mapping {
        .init(method: "PATCH", path: path, handler: handler)
    }
}

extension URL {
    func url(matches regexp: NSRegularExpression) -> Bool {
        matches(what: absoluteString, regexp: regexp)
    }

    func url(matches pattern: String) -> Bool {
        do {
            let regexp = try NSRegularExpression(pattern: pattern, options: [])
            return url(matches: regexp)
        } catch {
            return false
        }
    }

    func path(matches regexp: NSRegularExpression) -> Bool {
        matches(what: path, regexp: regexp)
    }

    func path(matches pattern: String) -> Bool {
        do {
            let regexp = try NSRegularExpression(pattern: pattern, options: [])
            return path(matches: regexp)
        } catch {
            return false
        }
    }

    // MARK: -

    private func matches(what: String, regexp: NSRegularExpression) -> Bool {
        let result = regexp.matches(in: what, options: [], range: NSRange(location: 0, length: what.count))
        return !result.isEmpty
    }
}
