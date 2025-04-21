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
```
market2/
├── market2/
│   ├── Models/
│   │   ├── AddProductViewModel.swift
│   │   ├── Chat.swift
│   │   ├── Message.swift
│   │   ├── Product.swift
│   │   ├── User.swift
│   │   └── ViewModel.swift
│   ├── Preview Content/
│   │   ├── Preview Assets/
│   │   └── ProductDetailView.swift
│   ├── Profile/
│   │   ├── EditProfileView.swift
│   │   ├── ProfileView.swift
│   │   ├── ProfileViewModel.swift
│   │   ├── SettingsRow.swift
│   │   ├── SettingsView.swift
│   │   └── UserProductCard.swift
│   ├── Utilities/
│   │   └── ImagePicker.swift
│   ├── Views/
│   │   ├── Messenger/
│   │   │   ├── ChatDetailView.swift
│   │   │   ├── ChatListView.swift
│   │   │   ├── ChatView.swift
│   │   │   └── MessengerViewModel.swift
│   │   ├── AddProductView.swift
│   │   └── MarketPlaceView.swift
│   ├── Assets/
│   ├── ContentView.swift
│   ├── DataManager.swift
│   ├── info/
│   ├── market2/
│   ├── market2App.swift
│   └── Persistence.swift
├── market2Tests/
│   └── market2Tests.swift
└── market2UITests/
├── market2UITests.swift
└── market2UITestsLaunchTests.swift
```
## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

## Installation

1. Clone the repository:
```bash
   git clone https://github.com/vladivolgin/Market.git
