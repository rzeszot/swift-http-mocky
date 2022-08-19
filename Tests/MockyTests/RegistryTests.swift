@testable import Mocky
import XCTest

final class RegistryTests: XCTestCase {
    var registry: Registry<Agent>!

    override func setUp() {
        registry = Registry()
    }

    override func tearDown() {
        registry = nil
    }

    // MARK: -

    func test_init() {
        XCTAssertEqual(registry.all.count, 0)
    }

    func test_add() {
        registry.add(.smith)

        XCTAssertEqual(registry.all.count, 1)
        XCTAssertEqual(registry.all.first?.name, "Agent Smith")
    }

    func test_remove() {
        registry.add(.smith)

        registry.remove(id: "smith")

        XCTAssertEqual(registry.all.count, 0)
    }

    func test_contains() {
        registry.add(.brown)

        XCTAssertTrue(registry.contains(id: "brown"))
        XCTAssertFalse(registry.contains(id: "smith"))
    }
}
