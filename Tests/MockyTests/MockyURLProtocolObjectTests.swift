import XCTest
@testable import Mocky

final class MockyURLProtocolObjectTests: XCTestCase {

  var registry: Registry<Mapping>! {
    didSet {
      MockyURLProtocol.registry = registry
    }
  }

  var proto: MockyURLProtocol!
  var client: ClientSpy!

  override func setUp() {
    registry = .init()
    client = ClientSpy()
    proto = MockyURLProtocol(request: .get("/hello"), cachedResponse: nil, client: client)
  }

  override func tearDown() {
    registry = nil
    client = nil
    proto = nil
  }

  // MARK: -

  func test_set_status_code() {
    let exp = expectation(description: "request")
    configure(exp) { $0 is FinishedStackFrame }

    registry.add(.get(path: "^/hello$") { env in
      env.response.status = 204
    })

    proto.startLoading()
    wait(for: [exp], timeout: 0.1)

    XCTAssertEqual(client.callstack.count, 2)

    XCTAssertTrue(client.callstack[0] is ReceivedStackFrame)
    let response = (client.callstack[0] as? ReceivedStackFrame)?.response
    XCTAssertEqual(response?.statusCode, 204)

    XCTAssertTrue(client.callstack[1] is FinishedStackFrame)
  }

  func test_uses_success_by_default() {
    let exp = expectation(description: "request")
    configure(exp) { $0 is FinishedStackFrame }

    registry.add(.get(path: "^/hello$") { env in })

    proto.startLoading()
    wait(for: [exp], timeout: 0.1)

    XCTAssertEqual(client.callstack.count, 2)

    XCTAssertTrue(client.callstack[0] is ReceivedStackFrame)
    let response = (client.callstack[0] as? ReceivedStackFrame)?.response
    XCTAssertEqual(response?.statusCode, 200)

    XCTAssertTrue(client.callstack[1] is FinishedStackFrame)
  }

  func test_returns_data() {
    let exp = expectation(description: "request")
    configure(exp) { $0 is FinishedStackFrame }

    registry.add(.get(path: "^/hello$") { env in
      env.response.body = """
        {
          "hello": "world"
        }
        """.data(using: .utf8)
    })

    proto.startLoading()
    wait(for: [exp], timeout: 0.1)

    XCTAssertEqual(client.callstack.count, 3)

    XCTAssertTrue(client.callstack[0] is ReceivedStackFrame)
    let response = (client.callstack[0] as? ReceivedStackFrame)?.response
    XCTAssertEqual(response?.statusCode, 200)

    XCTAssertTrue(client.callstack[1] is LoadedStackFrame)
    let data = (client.callstack[1] as? LoadedStackFrame)?.data
    XCTAssertEqual(data.map { String(data: $0, encoding: .utf8) }, """
      {
        "hello": "world"
      }
      """)

    XCTAssertTrue(client.callstack[2] is FinishedStackFrame)
  }

  // MARK: -

  func test_stop_loading() {
    proto.stopLoading()
  }

  // MARK: -

  private func configure(_ exp: XCTestExpectation, check: @escaping (Any) -> Bool) {
    client.callstackDidChange = { spy in
      guard spy.callstack.contains(where: check) else { return }
      exp.fulfill()
    }
  }
}
