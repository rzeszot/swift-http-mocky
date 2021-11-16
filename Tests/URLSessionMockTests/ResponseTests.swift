import XCTest
@testable import URLSessionMock

final class ResponseTests: XCTestCase {
  func test_init() {
    let sut = Response()

    XCTAssertNil(sut.status)
    XCTAssertNil(sut.body)
    XCTAssertTrue(Dictionary(sut.headers).isEmpty)
  }

  func test_json() throws {
    let sut = Response()
    try sut.body(json: Actor.depp)

    XCTAssertEqual(sut.headers["Content-Type"], "application/json")
    XCTAssertEqual(sut.headers.count, 1)

    XCTAssertEqual(sut.body, Fixture.depp.data)
  }
}
