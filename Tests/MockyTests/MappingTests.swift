@testable import Mocky
import XCTest

final class MappingTests: XCTestCase {
    var env: Environment!

    override func setUp() {
        env = Environment(request: .get("/"))
    }

    override func tearDown() {
        env = nil
    }

    // MARK: - Mapping

    func test_mapping_init() {
        let sut = Mapping(matcher: { _ in true }, handler: { env in env.delay = 1 }, id: "sut-identifier")

        sut.handler(env)

        XCTAssertEqual(sut.id, "sut-identifier")
        XCTAssertTrue(sut.matcher(.get("/")))
        XCTAssertEqual(env.delay, 1)
    }

    func test_mapping_get() {
        let sut: Mapping = .get(path: "/hello") { env in env.delay = 2 }

        sut.handler(env)

        XCTAssertTrue(sut.matcher(.get("/hello")))
        XCTAssertEqual(sut.id, "GET /hello")
        XCTAssertEqual(env.delay, 2)
    }

    func test_mapping_post() {
        let sut: Mapping = .post(path: "/hello") { env in env.delay = 3 }

        sut.handler(env)

        XCTAssertTrue(sut.matcher(.post("/hello")))
        XCTAssertEqual(sut.id, "POST /hello")
        XCTAssertEqual(env.delay, 3)
    }

    // MARK: - Match

    func test_path_matches_pattern() throws {
        let url = URL(string: "https://example.org/absolute")

        XCTAssertNotNil(url)
        XCTAssertEqual(url?.path(matches: "^/absolute$"), true)
    }

    func test_url_matches_pattern() throws {
        let url = URL(string: "https://example.org/absolute")

        XCTAssertNotNil(url)
        XCTAssertEqual(url?.url(matches: "^https://example.org/absolute$"), true)
    }

    func test_path_matches_regexp() throws {
        let url = URL(string: "https://example.org/animals/123/details")

        XCTAssertNotNil(url)
        XCTAssertEqual(url?.path(matches: "^/animals/[0-9]+/[a-z]+$"), true)
    }
}

extension URLRequest {
    static func get(_ path: String) -> URLRequest {
        let url = URL(string: "http://example.org\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }

    static func post(_ path: String) -> URLRequest {
        let url = URL(string: "http://example.org\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
