import XCTest

final class market2UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Take a screenshot of the launch screen
        let launchScreenshot = XCTAttachment(screenshot: app.screenshot())
        launchScreenshot.name = "Launch Screen"
        launchScreenshot.lifetime = .keepAlways
        add(launchScreenshot)
    }
    
    @MainActor
    func testMarketplaceScreenshot() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Ensure we're on the Market tab
        app.tabBars.buttons["Market"].tap()
        
        // Wait a moment for content to load
        sleep(1)
        
        // Take a screenshot of the marketplace
        let marketScreenshot = XCTAttachment(screenshot: app.screenshot())
        marketScreenshot.name = "Marketplace Screen"
        marketScreenshot.lifetime = .keepAlways
        add(marketScreenshot)
    }
    
    @MainActor
    func testProfileScreenshot() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Profile tab
        app.tabBars.buttons["Profile"].tap()
        
        // Wait a moment for content to load
        sleep(1)
        
        // Take a screenshot of the profile
        let profileScreenshot = XCTAttachment(screenshot: app.screenshot())
        profileScreenshot.name = "Profile Screen"
        profileScreenshot.lifetime = .keepAlways
        add(profileScreenshot)
    }
    
    @MainActor
    func testMessagesScreenshot() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Messages tab
        app.tabBars.buttons["Messages"].tap()
        
        // Wait a moment for content to load
        sleep(1)
        
        // Take a screenshot of the messages list
        let messagesScreenshot = XCTAttachment(screenshot: app.screenshot())
        messagesScreenshot.name = "Messages Screen"
        messagesScreenshot.lifetime = .keepAlways
        add(messagesScreenshot)
    }
    
    @MainActor
    func testAddProductScreenshot() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Add tab
        app.tabBars.buttons["Add"].tap()
        
        // Wait a moment for content to load
        sleep(1)
        
        // Take a screenshot of the add product screen
        let addScreenshot = XCTAttachment(screenshot: app.screenshot())
        addScreenshot.name = "Add Product Screen"
        addScreenshot.lifetime = .keepAlways
        add(addScreenshot)
        
        // Tap to open the add product form
        app.buttons["Tap to Add"].tap()
        
        // Wait for the form to appear
        sleep(1)
        
        // Take a screenshot of the add product form
        let formScreenshot = XCTAttachment(screenshot: app.screenshot())
        formScreenshot.name = "Add Product Form"
        formScreenshot.lifetime = .keepAlways
        add(formScreenshot)
    }
    
    @MainActor
    func testProductDetailScreenshot() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Ensure we're on the Market tab
        app.tabBars.buttons["Market"].tap()
        
        // Wait a moment for content to load
        sleep(1)
        
        // Try to tap on the first product (if any exist)
        if app.scrollViews.otherElements.firstMatch.exists {
            app.scrollViews.otherElements.firstMatch.tap()
            
            // Wait for the product detail to load
            sleep(1)
            
            // Take a screenshot of the product detail
            let detailScreenshot = XCTAttachment(screenshot: app.screenshot())
            detailScreenshot.name = "Product Detail Screen"
            detailScreenshot.lifetime = .keepAlways
            add(detailScreenshot)
        }
    }
    
    @MainActor
    func testSettingsScreenshot() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Profile tab
        app.tabBars.buttons["Profile"].tap()
        
        // Look for settings button or navigation
        if app.buttons["Settings"].exists {
            app.buttons["Settings"].tap()
        } else if app.staticTexts["Settings"].exists {
            app.staticTexts["Settings"].tap()
        } else if app.staticTexts["Privacy Settings"].exists {
            // If we can't find a direct Settings option, try Privacy Settings
            app.staticTexts["Privacy Settings"].tap()
        }
        
        // Wait for settings to load
        sleep(1)
        
        // Take a screenshot of settings
        let settingsScreenshot = XCTAttachment(screenshot: app.screenshot())
        settingsScreenshot.name = "Settings Screen"
        settingsScreenshot.lifetime = .keepAlways
        add(settingsScreenshot)
    }
    
    @MainActor
    func testDarkModeScreenshot() throws {
        // This test assumes there's a way to toggle dark mode in the app
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Profile tab
        app.tabBars.buttons["Profile"].tap()
        
        // Try to find settings
        if app.buttons["Settings"].exists {
            app.buttons["Settings"].tap()
            
            // Look for dark mode toggle
            if app.switches["Dark Mode"].exists {
                // Toggle dark mode on
                app.switches["Dark Mode"].tap()
                
                // Wait for UI to update
                sleep(1)
                
                // Take a screenshot in dark mode
                let darkModeScreenshot = XCTAttachment(screenshot: app.screenshot())
                darkModeScreenshot.name = "Dark Mode Screen"
                darkModeScreenshot.lifetime = .keepAlways
                add(darkModeScreenshot)
            }
        }
    }
}

