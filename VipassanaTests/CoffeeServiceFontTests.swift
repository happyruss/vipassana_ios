import XCTest
@testable import Vipassana

class CoffeeServiceFontTests: XCTestCase {

    func testUsesFirstRegisteredCoffeeServiceName() {
        let choice = CoffeeServiceFont.selectTitleFont(registeredFamilyNames: ["CoffeeService"]) { name in
            name == "CoffeeService"
        }
        XCTAssertEqual(choice, .named("CoffeeService"))
    }

    func testFallsBackToSystemFontWhenFamilyIsNotRegistered() {
        let choice = CoffeeServiceFont.selectTitleFont(registeredFamilyNames: []) { _ in
            true
        }
        XCTAssertEqual(choice, .system)
    }

    func testFallsBackWhenFirstNameDoesNotResolve() {
        let choice = CoffeeServiceFont.selectTitleFont(registeredFamilyNames: ["MissingFace"]) { _ in
            false
        }
        XCTAssertEqual(choice, .system)
    }

    func testSkipsAnEmptyNameAndUsesTheNextRegisteredFace() {
        let choice = CoffeeServiceFont.selectTitleFont(registeredFamilyNames: ["", "CoffeeService"]) { name in
            name == "CoffeeService"
        }
        XCTAssertEqual(choice, .named("CoffeeService"))
    }
}
