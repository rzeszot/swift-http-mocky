import Foundation

struct ReceivedStackFrame {
    let response: HTTPURLResponse
}

struct LoadedStackFrame {
    let data: Data
}

struct FinishedStackFrame {}

class ClientSpy: NSObject, URLProtocolClient {
    var callstackDidChange: ((ClientSpy) -> Void)?
    var callstack: [Any] = [] {
        didSet {
            callstackDidChange?(self)
        }
    }

    // MARK: -

    func urlProtocol(_: URLProtocol, didReceive response: URLResponse, cacheStoragePolicy _: URLCache.StoragePolicy) {
        callstack.append(ReceivedStackFrame(response: response as! HTTPURLResponse))
    }

    func urlProtocol(_: URLProtocol, didLoad data: Data) {
        callstack.append(LoadedStackFrame(data: data))
    }

    func urlProtocolDidFinishLoading(_: URLProtocol) {
        callstack.append(FinishedStackFrame())
    }

    // MARK: -

    func urlProtocol(_: URLProtocol, wasRedirectedTo _: URLRequest, redirectResponse _: URLResponse) {
        fatalError()
    }

    func urlProtocol(_: URLProtocol, cachedResponseIsValid _: CachedURLResponse) {
        fatalError()
    }

    func urlProtocol(_: URLProtocol, didFailWithError _: Error) {
        fatalError()
    }

    func urlProtocol(_: URLProtocol, didReceive _: URLAuthenticationChallenge) {
        fatalError()
    }

    func urlProtocol(_: URLProtocol, didCancel _: URLAuthenticationChallenge) {
        fatalError()
    }
}
