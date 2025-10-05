# GamerMarketplace App

This application is a mobile marketplace designed for users to browse, search, sell items, and interact within a community. It is built using modern iOS development practices with SwiftUI and a Firebase backend.

## Table of Contents
- [Detailed Documentation](#detailed-documentation)
- [Features](#features)
- [Architecture Overview](#architecture-overview)
- [Software Architecture Schemas](#software-architecture-schemas)
- [Database Schema](#database-schema)
- [Requirements](#requirements)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Development Process](#development-process)

## Detailed Documentation

For a more in-depth analysis of specific architectural components, please refer to the following detailed reports:

*   **[NoSQL Project Report](NoSQL_Report.md):** Provides a deep dive into the Firestore database implementation, data modeling decisions, and future scalability plans.
*   **[Cyber Security Module Report](CyberSecurity_Report.md):** Details the threat model (STRIDE), security measures, and the server-authoritative architecture implemented to protect the application.

## Features

- 🛍️ **Marketplace:** Browse, search, and list items for sale.
- 💬 **Real-Time Chat:** Communicate securely with other users in real-time.
- 📝 **Community Forum:** Participate in discussions on various topics.
- 📰 **News Feed:** Stay updated with the latest news and articles.
- ⭐ **User Reviews:** View and leave ratings for sellers.
- 🔒 **Secure Authentication:** Managed by Firebase Authentication.
- 📱 **Modern UI:** A responsive and modern interface built with SwiftUI.


## Architecture Overview

The Marketplace App is developed using the MVVM (Model-View-ViewModel) architecture, ensuring a clean separation of concerns and making the components easier to test. The user interface is built with SwiftUI, and asynchronous operations are handled using Swift's modern concurrency features (`async/await`).

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
### Key Components

1.  **Models** - Swift structures that represent the main entities of the application, directly mapping to the collections in the Firestore database.
    - `User` - Represents a user's public profile.
    - `Product` - An item listed for sale.
    - `Chat` & `Message` - Represent a conversation and its individual messages.
    - `ForumTopic` & `Reply` - Represent a forum post and its replies.
    - `News` - An article in the news feed.
    - `Review` - A rating and comment for a seller.

2.  **Views** - A hierarchy of SwiftUI views responsible for displaying the user interface.
    - `MarketplaceView` - Main screen for browsing and searching items.
    - `ProductDetailView` - Shows detailed information about a single product.
    - `ChatListView` & `ChatDetailView` - For managing and participating in conversations.
    - `ForumView` - Displays a list of community topics.
    - `NewsView` - The application's news feed.
    - `ProfileView` - Displays user information and their listed items.
    - `AddProductView` - The form for adding a new item.

3.  **ViewModels** - Classes that hold the state and business logic for the Views, processing user input and preparing data for display.
    - `ProfileViewModel` - Manages the logic for the user profile screen.
    - `MessengerViewModel` - Handles the state for the chat interface.
    - `AddProductViewModel` - Manages the logic for adding a new product.

4.  **Services** - Singleton or shared instances that encapsulate major functionalities and interactions with the backend.
    - `DataManager` - Acts as a repository, handling all CRUD operations with the Firestore database.
    - `AuthManager` - Manages the user authentication lifecycle with Firebase Authentication.
    - `StorageManager` - Handles uploading and downloading images from Firebase Cloud Storage.
    ### Data Flow

The application follows a modern, reactive data flow:

1.  The user interacts with a **View**.
2.  The View calls a method on its **ViewModel**.
3.  The ViewModel processes the request, calling one or more **Services**.
4.  The Service interacts with the **Firebase Backend** and returns the result.
5.  The ViewModel updates its state using `@Published` properties.
6.  The View automatically re-renders to reflect the new state.

### Navigation Scheme

Navigation in the application is organized through a `TabView` with five main tabs:

1.  **Market** - Browse available items.
2.  **Forum** - Participate in community discussions.
3.  **Add** - Add a new item (presented modally).
4.  **Messages** - View and manage private chats.
5.  **Profile** - Manage user profile and settings.

Drill-down navigation within each tab is handled by `NavigationStack`.

### Security and Privacy

Security is a core principle, addressed with a multi-layered strategy:

-   **Secure Authentication** via Firebase Authentication.
-   **Server-Side Authorization** using Firestore Security Rules.
-   **Secure Data Transport** over HTTPS for all Firebase communication.
-   **Client-Side Input Validation** to prevent malformed data.
-   **Secret Management** using `.xcconfig` files, excluded from version control.

### Future Improvements

Future versions plan to add:

-   Integration with a dedicated search service like **Algolia**.
-   **Push Notifications** using Firebase Cloud Messaging.
-   **Payment Gateway Integration** (e.g., Stripe).
-   **Data Analytics** using Firebase Analytics to guide development.
```

## Product documentation
### use cases diagram
<img width="1060" alt="Снимок экрана 2025-04-21 в 22 39 37" src="https://github.com/user-attachments/assets/6f46ad5b-0228-410b-bf7a-56428ea4206a" />

<img width="628" alt="Снимок экрана 2025-04-21 в 22 39 42" src="https://github.com/user-attachments/assets/6268024f-b226-4fc3-9d73-7af1d56dc066" />

<img width="618" alt="Снимок экрана 2025-04-21 в 22 39 53" src="https://github.com/user-attachments/assets/8c6c6042-a434-4cdf-803e-06225eb50f0a" />

### Description:

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

### Description

The Logical Architecture diagram demonstrates the application's internal structure and its division into layers. It shows how components are organized to ensure clean code and separation of concerns, following the MVVM pattern.
Presentation Layer (View): Consists of SwiftUI Views, responsible solely for displaying the UI and forwarding user actions.
Business Logic Layer (ViewModel): Where ViewModels manage the state for the Views, handle user input logic, and prepare data for display.
Service/Manager Layer: A layer of services (AuthManager, DataManager) that encapsulates the logic for interacting with external systems, primarily Firebase.
Model Layer: Contains data structures (Product, User, etc.) that mirror the entities in the Firestore database.
Backend Services (Firebase): The external layer providing services like Authentication, Firestore database, and Cloud Storage.

### Physical Architecture
<img width="988" alt="Снимок экрана 2025-04-21 в 20 51 23" src="https://github.com/user-attachments/assets/a81a8b4e-d075-46ac-97b9-14cf12f24352" />

### Description:

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

The project is organized by feature, promoting modularity, scalability, and ease of navigation. This structure separates concerns logically, making it easier to develop and maintain the codebase.

```
market2/
├── App/                                # Core application setup and global services.
│   ├── market2App.swift              # The main entry point of the application (@main). Initializes services and sets the root view.
│   ├── ContentView.swift             # The root view, typically containing the TabView for main navigation.
│   ├── DataManager.swift             # A repository handling all CRUD (Create, Read, Update, Delete) operations with the Firestore database.
│   ├── AuthManager.swift             # Manages the user authentication lifecycle (login, logout, session state) with Firebase Authentication.
│   └── NetworkManager.swift          # A utility for handling generic network requests, potentially configured with security features like SSL Pinning.
│
├── Models/                             # Data structures (Codable structs) that mirror the Firestore collections.
│   ├── Product.swift                 # Represents a single item listed for sale in the marketplace.
│   ├── User.swift                    # Represents a user's public profile, including username, rating, etc.
│   ├── Chat.swift                    # Represents a conversation thread between two or more users.
│   ├── Message.swift                 # Represents a single message within a Chat.
│   ├── ForumTopic.swift              # Represents a main post in the community forum.
│   └── ... (other models)            # Includes Review.swift, News.swift, and Reply.swift.
│
├── ViewModels/                         # Contains the business logic and state for the views (MVVM).
│   ├── ProfileViewModel.swift        # Manages state for the ProfileView (e.g., fetching user data and their listings).
│   ├── MessengerViewModel.swift      # Handles logic for the chat interface (e.g., fetching conversations, sending messages).
│   ├── AddProductViewModel.swift     # Manages the logic for creating a new product, including data validation and image uploads.
│   └── ... (other view models)       # Includes ViewModels for Forum, News, and individual product pages.
│
├── Views/                              # Contains all SwiftUI views, organized by feature.
│   ├── Marketplace/                  # UI for the main marketplace feature.
│   │   ├── GamerMarketView.swift     # The main screen for browsing and searching all available products.
│   │   └── ProductDetailView.swift   # The detail screen shown when a user taps on a product.
│   ├── Messenger/                    # UI for the real-time chat feature.
│   │   ├── ChatListView.swift        # Displays a list of the user's active conversations.
│   │   └── ChatDetailView.swift      # The screen for an individual chat, displaying all messages.
│   ├── Profile/                      # UI for user profiles and settings.
│   │   ├── ProfileView.swift         # Displays a user's profile information, rating, and their listed items.
│   │   └── EditProfileView.swift     # A form for the user to edit their own profile details.
│   ├── Forum/                        # UI for the community forum.
│   │   └── ForumView.swift           # Displays a list of topics and allows users to participate in discussions.
│   ├── News/                         # UI for the news feed.
│   │   └── NewsView.swift            # Displays a list of articles.
│   └── ... (other views)             # Can include shared/reusable components like LoadingView.swift, ProductCard.swift, etc.
│
├── Utilities/                          # Helper classes and extensions used across the application.
│   ├── ImagePicker.swift             # A helper to integrate with UIKit's UIImagePickerController for photo selection.
│   └── InputValidator.swift          # A utility for validating user input to enhance security and data integrity.
│
└── Tests/                              # Contains all unit and UI test targets.
    ├── market2Tests/                 # The Unit Test target. Tests logic in isolation from the UI.
    │   ├── Models/                   # Tests for data models (e.g., encoding/decoding).
    │   ├── Services/                 # Tests for managers (e.g., AuthManager, DataManager) using mock data.
    │   └── ViewModels/               # Tests for business logic within the ViewModels.
    └── market2UITests/               # The UI Test target. Automates user interaction to verify user flows work as expected.
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



