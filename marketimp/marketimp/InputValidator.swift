// InputValidator.swift
import Foundation

struct InputValidator {
    
    /// A set of characters commonly used in injection attacks (XSS, SQLi).
    /// We are being very strict here for demonstration purposes.
    private static let disallowedCharacters = CharacterSet(charactersIn: "<>\"';&")

    /// Validates a string to ensure it does not contain any disallowed characters.
    /// - Parameter input: The string to validate.
    /// - Returns: `true` if the input is safe, `false` otherwise.
    static func isSafe(_ input: String) -> Bool {
        // An empty string is considered safe.
        if input.isEmpty {
            return true
        }
        
        // Check if the input contains any character from the disallowed set.
        if let _ = input.rangeOfCharacter(from: disallowedCharacters) {
            return false // Found a disallowed character.
        }
        
        return true // No disallowed characters found.
    }
    
    /// A simple function to check for overly long input, which can be a vector for DoS attacks.
    /// - Parameter input: The string to check.
    /// - Parameter maxLength: The maximum allowed length.
    /// - Returns: `true` if the input length is within the limit, `false` otherwise.
    static func isLengthValid(_ input: String, maxLength: Int = 256) -> Bool {
        return input.count <= maxLength
    }
}
