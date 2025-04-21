# Market2
This app is designed to allow anyone to sell unwanted items safely and without having to worry about revealing any information.
## Features

- 🛍️ Browse items in a user-friendly interface
- 💬 Built-in chat for communicating with sellers
- 🔒 Enhanced personal data protection
- 📱 Modern SwiftUI interface
- 📦 Convenient addition of new items

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



# Developer's Guide

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
└── ViewModels/
└── DataManager.swift       # Application data management
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
For testing, use:
Unit tests for logic and data models
UI tests for the user interface
Manual testing on various devices
## Performance Recommendations
1. Use LazyVStack and LazyHGrid for large lists
2. Cache images and other resources
3. Avoid heavy operations on the main thread
4. Use asynchronous operations for network requests
## Resources for Developers
SwiftUI Documentation
Combine Documentation
Human Interface Guidelines

## API Documentation
```markdown
# API Documentation

## DataManager

`DataManager` is the main class for managing application data. It provides methods for working with products, chats, and users.

### Properties

| Property | Type | Description |
|----------|-----|-------------|
| products | `[Product]` | List of products |
| chats | `[Chat]` | List of chats |
| userProfile | `User?` | Current user profile |

### Methods

#### `fetchProducts()`

Loads the list of products.

**Returns:** Void

**Usage Example:**
```swift
dataManager.fetchProducts()
addProduct(_ product: Product)
```
Adds a new product to the list.

```product```: Product to add
```Returns```: Void


## Usage Example (AI-generated):
```swift
let newProduct = Product(
    id: UUID().uuidString,
    sellerId: currentUser.id,
    title: "iPhone 13",
    description: "Excellent condition",
    price: 50000,
    category: "Electronics",
    condition: "Excellent",
    location: "Moscow",
    imageURLs: [],
    status: .active,
    createdAt: Date()
)
dataManager.addProduct(newProduct)
```
```
createChat(with otherUser: User) -> Chat?
```
Creates a new chat with the specified user or returns an existing one.

## Parameters:

```otherUser:``` User to create a chat with
Returns: Created or existing chat, or nil in case of an error

## Usage Example (AI-generated):
```swift

if let chat = dataManager.createChat(with: seller) {
    // Use the chat
}
```

```sendMessage(content: String, to receiverId: String)```
Sends a message to the specified user.

## Parameters:
```content```: Message text
```receiverId```: Recipient ID

Returns: Void

## Usage Example (AI-generated):
```swift
dataManager.sendMessage(content: "Hello! Is the item still available?", to: "user123")
getMessages(for chatId: String) -> [Message]
```
Gets the list of messages for the specified chat.

```
I've added "(AI-generated)" to each usage example to clearly indicate that these examples were created by AI and may need to be adjusted for your specific implementation.
```
