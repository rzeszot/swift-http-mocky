import Foundation

struct ReceivedStackFrame {
  let response: HTTPURLResponse
}

struct LoadedStackFrame {
  let data: Data
}

struct FinishedStackFrame {

}

class ClientSpy: NSObject, URLProtocolClient {

  var callstackDidChange: ((ClientSpy) -> Void)?
  var callstack: [Any] = [] {
    didSet {
      callstackDidChange?(self)
    }
  }

  // MARK: -

  func urlProtocol(_ protocol: URLProtocol, didReceive response: URLResponse, cacheStoragePolicy policy: URLCache.StoragePolicy) {
    callstack.append(ReceivedStackFrame(response: response as! HTTPURLResponse))
  }

  func urlProtocol(_ protocol: URLProtocol, didLoad data: Data) {
    callstack.append(LoadedStackFrame(data: data))
  }

  func urlProtocolDidFinishLoading(_ protocol: URLProtocol) {
    callstack.append(FinishedStackFrame())
  }

  // MARK: -

  func urlProtocol(_ protocol: URLProtocol, wasRedirectedTo request: URLRequest, redirectResponse: URLResponse) {
    fatalError()
  }

  func urlProtocol(_ protocol: URLProtocol, cachedResponseIsValid cachedResponse: CachedURLResponse) {
    fatalError()
  }

  func urlProtocol(_ protocol: URLProtocol, didFailWithError error: Error) {
    fatalError()
  }

  func urlProtocol(_ protocol: URLProtocol, didReceive challenge: URLAuthenticationChallenge) {
    fatalError()
  }

  func urlProtocol(_ protocol: URLProtocol, didCancel challenge: URLAuthenticationChallenge) {
    fatalError()
  }
}
