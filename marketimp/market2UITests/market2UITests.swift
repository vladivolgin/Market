import XCTest

final class market2UITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Stop immediately when a failure occurs
        continueAfterFailure = false
        
        // Launch the app before each test
        app.launch()
    }

    override func tearDownWithError() throws {
        // Cleanup code after each test
    }

    // MARK: - Tab Navigation Tests
    
    @MainActor
    func testTabNavigation() throws {
        // Check that all tabs exist
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 0).exists)
        
        // Navigate through each tab by index
        for i in 0..<app.tabBars.buttons.count {
            app.tabBars.buttons.element(boundBy: i).tap()
            XCTAssertTrue(app.tabBars.buttons.element(boundBy: i).isSelected)
        }
        
        // Return to the first tab
        app.tabBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 0).isSelected)
    }
    
    // MARK: - Marketplace Tests
    
    @MainActor
    func testMarketProductView() throws {
        // Navigate to the first tab (marketplace)
        app.tabBars.buttons.element(boundBy: 0).tap()
        
        // Check that there are some content elements
        XCTAssertTrue(app.scrollViews.count > 0 || app.collectionViews.count > 0)
        
        // Try to tap on the first item if available
        if app.scrollViews.count > 0 && app.scrollViews.firstMatch.cells.count > 0 {
            app.scrollViews.firstMatch.cells.firstMatch.tap()
        } else if app.collectionViews.count > 0 && app.collectionViews.firstMatch.cells.count > 0 {
            app.collectionViews.firstMatch.cells.firstMatch.tap()
        }
        
        // Go back if possible
        if app.navigationBars.buttons.firstMatch.exists {
            app.navigationBars.buttons.firstMatch.tap()
        }
    }
    
    // MARK: - Profile Tests
    
    @MainActor
    func testProfileSettings() throws {
        // Navigate to the profile tab (usually the last one)
        let lastTabIndex = app.tabBars.buttons.count - 1
        app.tabBars.buttons.element(boundBy: lastTabIndex).tap()
        
        // Check that we're on the profile screen
        XCTAssertTrue(app.navigationBars.count > 0)
        
        // Try to find and tap on settings elements
        let possibleSettingsTexts = ["Edit Profile", "Settings", "Privacy", "Account"]
        
        for text in possibleSettingsTexts {
            if app.staticTexts[text].exists {
                app.staticTexts[text].tap()
                
                // Go back
                if app.navigationBars.buttons.firstMatch.exists {
                    app.navigationBars.buttons.firstMatch.tap()
                }
                break
            } else if app.buttons[text].exists {
                app.buttons[text].tap()
                
                // Go back
                if app.navigationBars.buttons.firstMatch.exists {
                    app.navigationBars.buttons.firstMatch.tap()
                }
                break
            }
        }
    }
    
    // MARK: - Messages Tests
    
    @MainActor
    func testMessagesNavigation() throws {
        // Navigate to the messages tab (usually the second one)
        if app.tabBars.buttons.count > 1 {
            app.tabBars.buttons.element(boundBy: 1).tap()
            
            // Check that we're on the messages screen
            XCTAssertTrue(app.navigationBars.count > 0)
            
            // Tap on the first cell if available
            if app.tables.count > 0 && app.tables.firstMatch.cells.count > 0 {
                app.tables.firstMatch.cells.firstMatch.tap()
                
                // Go back
                if app.navigationBars.buttons.firstMatch.exists {
                    app.navigationBars.buttons.firstMatch.tap()
                }
            }
        }
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // Measure how long it takes to launch the app
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
