import XCTest
@testable import Mocky

final class RequestTests: XCTestCase {

  // MARK: - Init

  func test_init_url() {
    let request = URLRequest(url: URL(string: "https://example.org/init")!)

    let sut = Request(request: request)

    XCTAssertEqual(sut.url?.absoluteString, "https://example.org/init")
  }

  func test_init_body_nil() {
    let request = URLRequest(url: URL(string: "https://example.org/body")!)

    let sut = Request(request: request)

    XCTAssertNil(sut.body)
  }

  func test_init_body_data() {
    var request = URLRequest(url: URL(string: "https://example.org/body/data")!)
    request.httpBody = "hello world".data(using: .utf8)

    let sut = Request(request: request)

    XCTAssertEqual(sut.body.map { String(data: $0, encoding: .utf8) }, "hello world")
  }

  // MARK: - JSON

  func test_json_success() throws {
    var request = URLRequest(url: URL(string: "https://example.org/body/json")!)
    request.httpBody = Fixture.actors.data

    let sut = Request(request: request)
    let result = try sut.json(type: [Actor].self)

    XCTAssertNotNil(result)
    XCTAssertEqual(result?.count, 4)
    XCTAssertEqual(result?[0].name, "Tom Hanks")
  }

  func test_json_failure() throws {
    var request = URLRequest(url: URL(string: "https://example.org/body/json")!)
    request.httpBody = Fixture.payload.data

    let sut = Request(request: request)

    XCTAssertThrowsError(try sut.json(type: Actor.self)) { error in
      XCTAssertTrue(error is DecodingError)
    }
  }
}
