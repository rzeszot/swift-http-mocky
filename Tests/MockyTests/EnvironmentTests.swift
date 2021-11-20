import XCTest
@testable import Mocky

final class EnvironmentTests: XCTestCase {
  func test_init() {
    let request = URLRequest(url: URL(string: "https://example.org/env")!)
    let sut = Environment(request: request)

    XCTAssertNil(sut.delay)

    XCTAssertEqual(sut.request.url?.absoluteString, "https://example.org/env")
    XCTAssertNil(sut.request.body)

    XCTAssertNil(sut.response.status)
    XCTAssertEqual(sut.response.headers.count, 0)
    XCTAssertNil(sut.response.body)
  }

  func test_load_from_file() {
    let request = URLRequest(url: URL(string: "https://example.org/env")!)
    let env = Environment(request: request)
    env.load(from: "custom-response.json", subdirectory: "Responses", bundle: .module)

    XCTAssertEqual(env.response.status, 418)

    XCTAssertEqual(env.delay, 0.3)

    XCTAssertEqual(env.response["location"], "https://example.org/")
    XCTAssertEqual(env.response["authorization"], "bearer 12345")
    XCTAssertEqual(env.response["custom-header"], "custom-value")
    XCTAssertEqual(env.response.body, "this is body\n".data(using: .utf8))
  }
}
