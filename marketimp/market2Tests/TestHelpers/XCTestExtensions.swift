import XCTest
import Foundation

extension XCTestCase {
    // Wait for asynchronous code execution
    func waitForAsync(timeout: TimeInterval = 1.0, completion: @escaping () -> Void) {
        let expectation = self.expectation(description: "Async operation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // Check that the array is sorted in ascending order
    func XCTAssertSorted<T: Comparable>(_ array: [T], file: StaticString = #file, line: UInt = #line) {
        for i in 0..<array.count-1 {
            XCTAssertLessThanOrEqual(array[i], array[i+1], "Array is not sorted at index \(i)", file: file, line: line)
        }
    }
}
