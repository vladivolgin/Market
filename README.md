# GamerMarketplace App

This application is a mobile marketplace designed for users to browse, search, sell items, and interact within a community. It is built using modern iOS development practices with SwiftUI and a Firebase backend.

## Table of Contents
- [Features](#features)
- [Detailed Documentation](#detailed-documentation)
- [Application Architecture](#application-architecture)
- [Requirements](#requirements)
- [Installation](#installation)
- [Product documentation](#product-documentation)
- [Project Structure](#project-structure)
- [Testing](#testing)
- [Development Process](#development-process)
- [Error Handling Strategy](#error-handling-strategy)
- [Technical Decision log](#technical-decision-log)


## Features

- 🛍️ Browse items in a user-friendly interface
- 💬 Built-in chat for communicating with sellers
- 🔒 Enhanced personal data protection
- 📱 Modern SwiftUI interface
- 📦 Convenient addition of new items

## Detailed Documentation

For a more in-depth analysis of specific architectural components, please refer to the following detailed reports:

*   **[NoSQL Project Report](NoSQL_Report.md):** Provides a deep dive into the Firestore database implementation, data modeling decisions, and future scalability plans.
*   **[Cyber Security Module Report](CyberSecurity_Report.md):** Details the threat model (STRIDE), security measures, and the server-authoritative architecture implemented to protect the application.

## Application Architecture

My application is built on the MVVM (Model-View-ViewModel) architecture using SwiftUI and Combine for reactive programming.

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

## Installation

1. Clone the repository:
```bash
   git clone https://github.com/vladivolgin/Market.git

```

Project Setup
Open the project file in Xcode:
bash

Copy
```
open Market2.xcodeproj
```
When working on my project, I set it up to use dependencies through Swift Package Manager. This means Xcode automatically downloads everything needed when the project is opened for the first time. To test it, you can select the target device (simulator or a real device) at the top of Xcode, then hit "Build and Run" (the triangle button) or just press Cmd+R to launch the app.
Creating Your First Item
Launch the application
Go to the "Add" tab (center button with a plus)
Fill in the item information:
Title
Description
Price
Category
Condition
Location
Add photos of the item (optional)
Click the "Add Item" button
Sending a Message to a Seller
Find the item you're interested in on the "Market" tab
Tap on the item to view detailed information
Click the "Message Seller" button
Enter your message and send it
Setting Up Your Profile
Go to the "Profile" tab
Click "Edit Profile"
Update your information and save the changes

## Conceptual Documentation
```markdown
# Market2 Conceptual Documentation

## Architecture Overview

Market2 is developed using the MVVM (Model-View-ViewModel) architecture, ensuring a clean separation of concerns and making the components easier to test. The user interface is built with SwiftUI, while Combine is used for handling reactive programming.

### Key Components

1. **Models** - Data models representing the main entities of the application:
   - `Product` - An item for sale
   - `User` - A user
   - `Chat` - A chat between users
   - `Message` - A message in a chat

2. **Views** - Views displaying the user interface:
   - `ContentView` - Main view with TabView
   - `MarketplaceView` - View for browsing items
   - `ChatsListView` - List of chats
   - `ChatDetailView` - Detailed chat view
   - `ProfileView` - User profile
   - `AddProductView` - Item addition form

3. **ViewModels** - The link between models and views:
   - `DataManager` - Manages application data and provides it to views

4. **Services** - Services for interacting with external systems:
   - Future versions will add services for working with APIs, databases, etc.

## Data Flow

The application is designed with a unidirectional data flow architecture in mind:

1. The user interacts with the view
2. The view calls methods in the DataManager
3. The DataManager updates the data and notifies views through @Published properties
4. Views are automatically updated thanks to SwiftUI and Combine

## Navigation Scheme

Navigation in the application is organized through TabView with four main tabs:

1. **Market** - Browse available items
2. **Messages** - Chats with other users
3. **Add** - Add a new item (modal window)
4. **Profile** - Manage user profile

Additional screens are opened modally or through NavigationLink.

## Security and Privacy

One of the key features of this app is increased attention to security and privacy:

- Minimal collection of user data
- Encryption of messages in chats
- Ability to hide personal information from other users
- No tracking of user activity

## Future Improvements

Future versions plan to add:

- Integration with a server API
- Authentication through Firebase
- Data storage in CloudKit
- Support for push notifications
- Advanced privacy settings
```

## Product documentation
### use cases diagram
<img width="1060" alt="Снимок экрана 2025-04-21 в 22 39 37" src="https://github.com/user-attachments/assets/6f46ad5b-0228-410b-bf7a-56428ea4206a" />

<img width="628" alt="Снимок экрана 2025-04-21 в 22 39 42" src="https://github.com/user-attachments/assets/6268024f-b226-4fc3-9d73-7af1d56dc066" />

<img width="618" alt="Снимок экрана 2025-04-21 в 22 39 53" src="https://github.com/user-attachments/assets/8c6c6042-a434-4cdf-803e-06225eb50f0a" />
#### Description:
This diagram illustrates the main actions available to the User within the application. It covers the key features of the system, grouped by module:
Marketplace: Browsing, searching, publishing, and managing items.
Communication: Interacting with other users via private messages and leaving reviews.
Community: Engaging with the community through the forum and reading news.
Authentication: Registering and signing into the system.
The diagram provides a high-level overview of the system's functionality and how the user interacts with it.

## Software Architecture Schemas
### Logical architecture
<img width="758" alt="Снимок экрана 2025-04-21 в 22 43 46" src="https://github.com/user-attachments/assets/e92fbc07-b83b-4016-b0c8-f7de0c2cd6be" />

This schema is a representation of the functionality of the application at this stage of development.
#### Description
The Logical Architecture diagram demonstrates the application's internal structure and its division into layers. It shows how components are organized to ensure clean code and separation of concerns, following the MVVM pattern.
Presentation Layer (View): Consists of SwiftUI Views, responsible solely for displaying the UI and forwarding user actions.
Business Logic Layer (ViewModel): Where ViewModels manage the state for the Views, handle user input logic, and prepare data for display.
Service/Manager Layer: A layer of services (AuthManager, DataManager) that encapsulates the logic for interacting with external systems, primarily Firebase.
Model Layer: Contains data structures (Product, User, etc.) that mirror the entities in the Firestore database.
Backend Services (Firebase): The external layer providing services like Authentication, Firestore database, and Cloud Storage.

### Physical Architecture
<img width="988" alt="Снимок экрана 2025-04-21 в 20 51 23" src="https://github.com/user-attachments/assets/a81a8b4e-d075-46ac-97b9-14cf12f24352" />

#### Description:
This diagram shows the physical deployment of the system's components. It illustrates the client-server model, where:
Client: The user's iOS device (iPhone/iPad) running the mobile application built with SwiftUI.
Backend: The Google Cloud platform, which hosts the managed Firebase services. This includes Firestore (database), Firebase Authentication, and Cloud Storage (for images).
Communication between the client and backend occurs over the secure HTTPS protocol, ensuring all data is encrypted in transit.
## Database schema
<img width="989" alt="Снимок экрана 2025-04-21 в 21 41 31" src="https://github.com/user-attachments/assets/97d8dcd5-6c1e-4a01-9f6e-9b42b742b54d" />

This schema is a representation of the functionality of the application at this stage of development.
## Sequence diagram
<img width="1005" alt="Снимок экрана 2025-04-21 в 19 21 24" src="https://github.com/user-attachments/assets/ae37ab29-b397-49e0-9145-52f916424b09" />

#### Description:
The Sequence Diagram demonstrates the dynamic interaction between system components to perform a specific scenario. The process of "Adding a New Item" is shown as an example.
It illustrates the following steps:
The user fills out the form in AddProductView and taps 'Save'.
The View calls a method on its ViewModel.
The ViewModel first uploads the image to Cloud Storage.
After receiving the image URL, the ViewModel creates a Product object.
It then calls the DataManager to save the new document to the products collection in Firestore.
Upon successful saving, the ViewModel updates the UI to inform the user of the success.
This diagram clearly shows how client-side components interact with each other and with various Firebase services to complete a single business task.

## Developer's Guide

## Getting Started

To start working on the Market2 project, follow the installation instructions in README.md.

## Project Structure
```
Market2/
├── App/
│   ├── market2App.swift       # Application entry point
│   └── ContentView.swift      # Main view with TabView
├── Models/
│   ├── Product.swift          # Product model
│   ├── User.swift             # User model
│   ├── Chat.swift             # Chat model
│   └── Message.swift          # Message model
├── Views/
│   ├── Marketplace/
│   │   ├── MarketplaceView.swift       # Marketplace view
│   │   ├── ProductCard.swift           # Product card
│   │   ├── ProductsGrid.swift          # Products grid
│   │   └── ProductDetailView.swift     # Product detail view
│   ├── Chat/
│   │   ├── ChatsListView.swift         # Chats list
│   │   ├── ChatDetailView.swift        # Chat detail view
│   │   └── MessageBubble.swift         # Message bubble
│   ├── Profile/
│   │   ├── ProfileView.swift           # User profile
│   │   └── ProductCardSmall.swift      # Small product card
│   └── AddProduct/
│       └── AddProductView.swift        # Add product form
├── DataManager.swift                   # Application data management
├── market2Tests/
│   ├── Models/
│   │    ├── ChatTests.swift            # Tests for the Chat model
│   │    ├── MessageTests.swift         # Tests for the Message model
│   │    ├── ProductTests.swift         # Tests for the Product model
│   │    └── UserTests.swift            # Tests for the User model
│   ├── Services/
│   │    └── DataManagerTests.swift     # Tests for the DataManager
│   ├── TestHelpers/
│   │   ├── TestFactories.swift         # Tests for the Descriptions
│   │   └── XCTestExtensions.swift      # Asynchronous code execution
│   ├── Utils/
│   │   └── ExtensionsTests.swift       # Tests for login through email
│   └── ScreenshotTests.swift
├── market2tests.swift
├── market2UITests/
│      ├── market2UITests.swift         # Ui Tests 
│      └── market2UITestsLaunchTests.swift
```
## Code Style

When developing the project, follow these style rules:

1. Use CamelCase for type names and PascalCase for variable and function names
2. Add comments to complex code sections
3. Group related properties and methods
4. Use extensions to separate functionality
5. Follow SOLID principles

## Development Process

1. Create a new branch for your task:
```bash
   git checkout -b feature/your-feature-name
```
2. Make the necessary changes and test them
3. Create a commit with a descriptive message:
```bash
git commit -m "Add feature: your feature description"
```
4. Push the changes to the repository:
```bash
git push origin feature/your-feature-name
```
5. Create a Pull Request on GitHub

## Testing

### Model Tests
My application includes comprehensive test coverage for core models:

#### User Model Tests
- Authentication validation
- User profile data integrity
- Privacy settings functionality
- Account permissions verification

#### Message Model Tests
- Message creation and delivery
- End-to-end encryption verification
- Message status tracking (sent, delivered, read)
- Attachment handling and validation

#### Product Model Tests
- Product listing creation and validation
- Price calculation and formatting
- Category and tag association
- Search indexing verification

#### Chat Model Tests
- Chat session creation and management
- Participant handling and permissions
- Message threading and organization
- Chat history retention policies

### UI Tests
My UI testing suite ensures consistent user experience:

- Component rendering tests for all major UI elements
- User flow validation for critical paths (listing creation, messaging, etc.)
- Responsive design verification across device sizes
- Accessibility compliance testing
- Performance benchmarking for UI interactions

## Performance Recommendations
1. Use LazyVStack and LazyHGrid for large lists
2. Cache images and other resources
3. Avoid heavy operations on the main thread
4. Use asynchronous operations for network requests
## Resources for Developers
SwiftUI Documentation
Combine Documentation
Human Interface Guidelines

## Error Handling Strategy
Network Interaction Level: All network errors are handled in API services and converted to NetworkError.
```Data Level```: Data-related errors are handled in ```DataManager``` and converted to ```DataError```.
Presentation Level: ViewModel handles errors and provides appropriate messages for display to the user.
## Error Handling Example
```swift
func fetchProducts() {
    isLoading = true
    errorMessage = nil
    
    apiService.getProducts { [weak self] result in
        guard let self = self else { return }
        
        self.isLoading = false
        
        switch result {
        case .success(let products):
            self.products = products
        case .failure(let error):
            switch error {
            case .noInternet:
                self.errorMessage = "No internet connection"
            case .unauthorized:
                self.errorMessage = "Authentication required"
                self.authManager.signOut()
            case .serverError(let code):
                self.errorMessage = "Server error: \(code)"
            default:
                self.errorMessage = "An error occurred while loading products"
            }
            
            self.logError(error)
        }
    }
}

```
## Coding Conventions
Naming
### Types (classes, structures, enums, protocols):
Use PascalCase (e.g., ProductDetailView, NetworkError)
Names should be nouns
### Variables and Functions:
Use camelCase (e.g., productList, fetchProducts())
Function names should start with a verb
### Constants:
For global constants, use the k prefix (e.g., kMaxRetryCount)
For static constants, use camelCase (e.g., static let maxRetryCount = 3)
### Abbreviations:
Common abbreviations (URL, ID) should be written in uppercase
For other abbreviations, use camelCase
```swift
## File Structure
Code Organization in a File:

   // 1. Imports
   import SwiftUI
   import Combine
   
   // 2. Protocols
   protocol ProductsViewModelProtocol { }
   
   // 3. Main Class/Structure
   class ProductsViewModel: ObservableObject, ProductsViewModelProtocol {
       // 3.1 Properties
       @Published var products: [Product] = []
       
       // 3.2 Initializers
       init() { }
       
       // 3.3 Public Methods
       func fetchProducts() { }
       
       // 3.4 Private Methods
       private func processProducts(_ products: [Product]) { }
   }
   
   // 4. Extensions
   extension ProductsViewModel {
       func additionalFunctionality() { }
   }
```
# Function Header Comments

## Purpose
Function header comments are critical for my codebase as they document exactly what each function does, what inputs it expects, and what outputs it provides. I've found that well-documented functions make it much easier for me to revisit my code months later, and they're essential when collaborating with other developers

## Format
We use a standardized format for function header comments based on Swift's documentation comments (triple slash `///`):
```swift
/// Brief description of what the function does
///
/// More detailed explanation if needed. This can span
/// multiple lines and provide additional context.
///
/// - Parameters:
///   - paramName1: Description of first parameter
///   - paramName2: Description of second parameter
/// - Returns: Description of the return value
/// - Throws: Description of potential errors that can be thrown
/// - Note: Any additional notes or warnings
/// - Example:
///   ```swift
///   let result = myFunction(param1: "value", param2: 42)
///   // result will be...
///   
func myFunction(paramName1: String, paramName2: Int) -> Result {
    // Implementation
}
```
## Grouping Files in the Project:
Group files by functionality, not by type
For example: ```/Features/ProductList/ ``` instead of ```/Views/ and /ViewModels/```

## Formatting
### Indentation:
Use 4 spaces for indentation
Do not use tabs
### Braces:
Opening brace on the same line
Closing brace on a new line
### Maximum Line Length:
100 characters
### Spaces:
Space after comma
Space before and after operators
No spaces inside parentheses
## SwiftUI Conventions
### Modifiers:
Each modifier on a new line
Group related modifiers 
## Code Example(Ai-Generated)
```swift
   Text("Hello, World!")
       .font(.headline)
       .foregroundColor(.primary)
       
       .padding()
       .background(Color.secondary.opacity(0.2))
       .cornerRadius(10)
```
### Preview:
Add a preview for each View
Use different device sizes and themes

## Technical Decision log 
### Documentation

For detailed documentation, please refer to the following resources:

- [Technical Decision Log](TechnicalDecisionLog.md) - Log of key technical decisions and their rationale



