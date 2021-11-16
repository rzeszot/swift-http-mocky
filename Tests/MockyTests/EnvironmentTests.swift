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
}

