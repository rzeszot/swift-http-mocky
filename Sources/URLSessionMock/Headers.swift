import Foundation

final public class Headers: ExpressibleByDictionaryLiteral {

  fileprivate var request = URLRequest(url: URL(string: "https://internal")!)

  // MARK: -

  public init() {

  }

  // MARK: - ExpressibleByDictionaryLiteral

  public init(dictionaryLiteral elements: (String, String)...) {
    for (key, value) in elements {
      add(value, for: key)
    }
  }

  // MARK: -

  /// If a value was previously set for the given key, the value is appended to the previously-existing value.
  public func add(_ value: String, for key: String) {
    request.addValue(value, forHTTPHeaderField: key)
  }

  /// If a value was previously set for the given key, that value is replaced with the value.
  public func set(_ value: String?, for key: String) {
    request.setValue(value, forHTTPHeaderField: key)
  }

  public func value(for key: String) -> String? {
    request.value(forHTTPHeaderField: key)
  }

  // MARK: -

  public subscript(_ key: String) -> String? {
    get {
      value(for: key)
    }
    set(value) {
      set(value, for: key)
    }
  }

}

extension Dictionary where Key == String, Value == String {
  public init(_ headers: Headers) {
    self = headers.request.allHTTPHeaderFields ?? [:]
  }
}
