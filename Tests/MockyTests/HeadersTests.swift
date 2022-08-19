import Mocky
import XCTest

final class HeadersTests: XCTestCase {
    var headers: Headers!

    override func setUp() {
        headers = Headers()
    }

    override func tearDown() {
        headers = nil
    }

    // MARK: -

    func test_value() {
        XCTAssertNil(headers.value(for: "key"))
    }

    // MARK: -

    func test_add_once() {
        headers.add("aaa", for: "key")

        XCTAssertEqual(headers.value(for: "key"), "aaa")
    }

    func test_add_twice() {
        headers.add("aaa", for: "key")
        headers.add("bbb", for: "key")

        XCTAssertEqual(headers.value(for: "key"), "aaa,bbb")
    }

    func test_add_comma_separated() {
        headers.add("aaa", for: "key")
        headers.add("bbb,bbb", for: "key")

        XCTAssertEqual(headers.value(for: "key"), "aaa,bbb,bbb")
    }

    func test_add_case_sensitive() {
        headers.add("aaa", for: "key")
        headers.add("bbb", for: "KEY")

        XCTAssertEqual(headers.value(for: "key"), "aaa,bbb")
        XCTAssertEqual(headers.value(for: "KEY"), "aaa,bbb")
        XCTAssertEqual(Array(Dictionary(headers).keys), ["KEY"])
    }

    // MARK: -

    func test_set_once() {
        headers.set("aaa", for: "key")

        XCTAssertEqual(headers.value(for: "key"), "aaa")
    }

    func test_set_twice() {
        headers.set("aaa", for: "key")
        headers.set("bbb", for: "key")

        XCTAssertEqual(headers.value(for: "key"), "bbb")
    }

    // MARK: - Subscript

    func test_subscript() {
        headers["key"] = "aaa"

        XCTAssertEqual(headers["key"], "aaa")
    }

    func test_subscript_override() {
        headers["key"] = "aaa"
        headers["key"] = "bbb"

        XCTAssertEqual(headers["key"], "bbb")
    }

    // MARK: - Expressible by Dictionary Literal

    func test_init_dictionary() {
        let headers: Headers = [
            "Set-Cookie": "aaa",
            "Set-Cookie": "bbb",
            "Location": "https://example.org/redirected",
        ]

        XCTAssertEqual(headers.value(for: "Set-Cookie"), "aaa,bbb")
        XCTAssertEqual(headers.value(for: "Location"), "https://example.org/redirected")
        XCTAssertEqual(Array(Dictionary(headers).keys).sorted(), ["Location", "Set-Cookie"])
    }
}
