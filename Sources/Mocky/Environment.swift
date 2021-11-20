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

extension Environment {
  public func load(from file: String, subdirectory: String? = nil, bundle: Bundle = .main) {
    let url = bundle.url(forResource: file, withExtension: nil, subdirectory: subdirectory)!

    let content = try! String(contentsOf: url)
    let chunks = content.components(separatedBy: "\n---\n")

    for option in chunks[0].split(separator: "\n") {
      let parts = option.components(separatedBy: ": ")
      let key = parts[0]
      let value = parts[1]

      switch key {
      case "delay":
        delay = TimeInterval(value)
      default:
        fatalError()
      }
    }

    for header in chunks[1].split(separator: "\n") {
      let parts = header.components(separatedBy: ": ")
      let key = parts[0]
      let value = parts[1]

      switch key {
      case "status":
        response.status = Int(value)
      default:
        response.headers.set(value, for: key)
      }
    }

    response.body = chunks[2].data(using: .utf8)
  }
}
