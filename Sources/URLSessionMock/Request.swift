import Foundation

final public class Request {

  private let request: URLRequest

  init(request: URLRequest) {
    self.request = request
  }

  public var url: URL? {
    request.url
  }

  public var body: Data? {
    request.httpBody
  }

  // MARK: -

  public func json<T: Decodable>(type: T.Type, using decoder: JSONDecoder = .init()) throws -> T? {
    guard let body = body else { return nil }
    return try decoder.decode(type, from: body)
  }

}
