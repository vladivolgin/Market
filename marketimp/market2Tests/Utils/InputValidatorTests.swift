import XCTest
@testable import market2

final class InputValidatorTests: XCTestCase {

    // MARK: - isSafe

    func testIsSafeAllowsEmptyString() {
        XCTAssertTrue(InputValidator.isSafe(""))
    }

    func testIsSafeAllowsOrdinaryText() {
        XCTAssertTrue(InputValidator.isSafe("iPhone 13, excellent condition - $500"))
    }

    func testIsSafeAllowsNonLatinText() {
        XCTAssertTrue(InputValidator.isSafe("Продам ноутбук, состояние отличное"))
    }

    func testIsSafeRejectsInjectionCharacters() {
        let disallowed = ["<", ">", "\"", "'", ";", "&"]
        for character in disallowed {
            XCTAssertFalse(InputValidator.isSafe("test\(character)value"), "Expected '\(character)' to be rejected")
        }
    }

    func testIsSafeRejectsScriptTag() {
        XCTAssertFalse(InputValidator.isSafe("<script>alert(1)</script>"))
    }

    // MARK: - isLengthValid

    func testIsLengthValidAllowsEmptyString() {
        XCTAssertTrue(InputValidator.isLengthValid(""))
    }

    func testIsLengthValidAtDefaultBoundary() {
        XCTAssertTrue(InputValidator.isLengthValid(String(repeating: "a", count: 256)))
        XCTAssertFalse(InputValidator.isLengthValid(String(repeating: "a", count: 257)))
    }

    func testIsLengthValidWithCustomMaxLength() {
        XCTAssertTrue(InputValidator.isLengthValid("abc", maxLength: 3))
        XCTAssertFalse(InputValidator.isLengthValid("abcd", maxLength: 3))
    }

    // MARK: - isValidEmail

    func testIsValidEmailAcceptsWellFormedAddresses() {
        let valid = [
            "test@example.com",
            "user.name@domain.co.uk",
            "user+tag@example.org",
            "a@b.co"
        ]
        for email in valid {
            XCTAssertTrue(InputValidator.isValidEmail(email), "Expected '\(email)' to be valid")
        }
    }

    func testIsValidEmailRejectsMalformedAddresses() {
        let invalid = [
            "plaintext",
            "missing@domain",
            "@missinguser.com",
            "user@",
            "no-at-sign.com"
        ]
        for email in invalid {
            XCTAssertFalse(InputValidator.isValidEmail(email), "Expected '\(email)' to be invalid")
        }
    }
}
