import Foundation

public class Mocky {
  public static let shared = Mocky()

  // MARK: -

  private let registry: Registry<Mapping>

  init(registry: Registry<Mapping> = .init()) {
    self.registry = registry
  }

  // MARK: - Sugar

  public func get(_ path: String, with handler: @escaping Handler) {
    registry.add(.get(path: path, handler: handler))
  }

  public func post(_ path: String, with handler: @escaping Handler) {
    registry.add(.post(path: path, handler: handler))
  }
  
  public func unmatch(get id: String) {
    registry.remove(id: "GET \(id)")
  }

  public func unmatch(post id: String) {
    registry.remove(id: "POST \(id)")
  }

  // MARK: -

  public func start() {
    MockyURLProtocol.registry = registry
    URLProtocol.registerClass(MockyURLProtocol.self)
  }

  public func stop() {
    URLProtocol.unregisterClass(MockyURLProtocol.self)
    MockyURLProtocol.registry = nil
  }
}
