import Foundation

final public class Request {
  private let request: URLRequest

  init(request: URLRequest) {
    self.request = request
  }

  public var url: URL? {
    request.url
  }

  public var method: String {
    request.httpMethod ?? "GET"
  }

  public var body: Data? {
    if let data = request.httpBody {
      return data
    } else if let stream = request.httpBodyStream {
      return Data(reading: stream)
    } else {
      return nil
    }
  }

  public var headers: Headers {
    Headers(dictionary: request.allHTTPHeaderFields ?? [:])
  }

  // MARK: -

  public func json<T: Decodable>(type: T.Type, using decoder: JSONDecoder = .init()) throws -> T? {
    guard let body = body else { return nil }
    return try decoder.decode(type, from: body)
  }
}

private extension Data {
  init(reading input: InputStream) {
    self.init()

    input.open()

    let bufferSize = 1024
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
    while input.hasBytesAvailable {
        let read = input.read(buffer, maxLength: bufferSize)
        append(buffer, count: read)
    }
    buffer.deallocate()
    input.close()
  }
}
