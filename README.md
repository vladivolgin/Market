# Market2

Market2 is a mobile application for reselling used items with a focus on confidentiality and user data protection. The app is developed using SwiftUI and is designed for iOS devices.

## Features

- 🛍️ Browse items in a user-friendly interface
- 💬 Built-in chat for communicating with sellers
- 🔒 Enhanced personal data protection
- 📱 Modern SwiftUI interface
- 📦 Convenient addition of new items

## Application Architecture

The application is built on the MVVM (Model-View-ViewModel) architecture using SwiftUI and Combine for reactive programming.

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
If the project uses dependencies through Swift Package Manager, Xcode will automatically download them when the project is first opened.
Select the target device (simulator or real device) at the top of Xcode.
Click the "Build and Run" button (triangle) or use the keyboard shortcut Cmd+R to launch the application.
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

Market2 is built on the MVVM (Model-View-ViewModel) architecture, which provides a clear separation of responsibilities between components and simplifies testing. The application uses SwiftUI for creating the user interface and Combine for reactive programming.

![Application Architecture](docs/images/architecture.png)

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

The data flow in the application follows the principles of unidirectional architecture:

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

One of the key features of Market2 is increased attention to security and privacy:

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

Developer's Guide
markdown


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
   bash

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
