import Foundation

public class Environment {
    public let request: Request
    public let response: Response

    public var delay: TimeInterval?

    init(request: URLRequest) {
        self.request = Request(request: request)
        self.response = Response()
    }
}
