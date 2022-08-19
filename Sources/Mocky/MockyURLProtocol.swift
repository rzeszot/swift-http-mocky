import Foundation

public final class MockyURLProtocol: URLProtocol {
    static var registry: Registry<Mapping>!

    // MARK: -

    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override public class func canInit(with request: URLRequest) -> Bool {
        !registry.filter(for: request).isEmpty
    }

    // MARK: -

    override public func startLoading() {
        let mappings = Self.registry.filter(for: request)
        let env = Environment(request: request)

        for mapping in mappings {
            mapping.handler(env)
        }

        after(env.delay ?? 0) { [self] in
            self.complete(env)
        }
    }

    override public func stopLoading() {
        // nop
    }

    // MARK: -

    private func complete(_ env: Environment) {
        let response = HTTPURLResponse(env: env)

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        if let data = env.response.body {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    private func after(_ delay: TimeInterval, completion: @escaping () -> Void) {
        let queue = DispatchQueue.global(qos: .background)

        queue.asyncAfter(deadline: .now() + .milliseconds(Int(delay * 1000)), execute: completion)
    }
}

extension HTTPURLResponse {
    convenience init(env: Environment) {
        let url = env.request.url!
        let status = env.response.status ?? 200
        let headers = Dictionary(env.response.headers)

        self.init(url: url, statusCode: status, httpVersion: nil, headerFields: headers)!
    }
}

extension Registry where T == Mapping {
    func filter(for request: URLRequest) -> [Mapping] {
        all.filter { $0.matcher(request) }
    }
}
