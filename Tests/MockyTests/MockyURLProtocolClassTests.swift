import XCTest
@testable import Mocky

final class MockyURLProtocolClassTests: XCTestCase {

  var registry: Registry<Mapping>! {
    didSet {
      MockyURLProtocol.registry = registry
    }
  }

  override func setUp() {
    registry = .init()
    registry.add(.get(path: "^/init/can$") { env in })
  }

  override func tearDown() {
    registry = nil
  }

  // MARK: -

  func test_canonical_request() {
    let request = URLRequest.get("/cannonical")

    let sut = MockyURLProtocol.canonicalRequest(for: request)

    XCTAssertEqual(sut, request)
  }

  func test_can_init() {
    let request = URLRequest.get("/init/can")

    XCTAssertTrue(MockyURLProtocol.canInit(with: request))
  }

  func test_cannot_init() {
    let request = URLRequest.get("/init/cannot")

    XCTAssertFalse(MockyURLProtocol.canInit(with: request))
  }
}
