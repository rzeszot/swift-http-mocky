import Foundation

public class Headers {

  fileprivate var request = URLRequest(url: URL(string: "https://internal")!)

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

}

extension Dictionary where Key == String, Value == String {
  public init(_ headers: Headers) {
    self = headers.request.allHTTPHeaderFields ?? [:]
  }
}
