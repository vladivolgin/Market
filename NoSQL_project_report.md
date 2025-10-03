# NoSQL Project Report: SwiftUI Marketplace

## 1. Project Description

This project is a feature-rich mobile application for iOS, built with SwiftUI and backed by Google's NoSQL database, **Firestore**. The application serves as a multi-functional platform, integrating a product marketplace, a community forum, a news feed, and a real-time private chat system.

The choice of Firestore, a document-based NoSQL database, was a strategic decision driven by several key factors:

*   **Flexible Schema:** The ability to have documents with varying structures is ideal for an application with diverse data models like products, forum posts, and user profiles.
*   **Scalability:** Firestore is designed for massive scalability, ensuring the application can handle a growing number of users and data without significant architectural changes.
*   **Real-Time Capabilities:** Its real-time data synchronization features are crucial for delivering a modern, interactive user experience, especially for the chat and live forum updates.

## 2. Implemented Core Functionality

The current implementation successfully covers all fundamental requirements and demonstrates a solid understanding of interacting with a NoSQL database from a client application.

*   **User Authentication:** Secure user sign-up and login is handled via Firebase Authentication.
*   **CRUD Operations:** The application fully implements Create, Read, Update, and Delete (CRUD) operations across all primary data collections (Users, Products, Chats, Reviews, Forum Topics, News).
*   **Real-Time Data:** The chat and forum sections utilize Firestore's `addSnapshotListener` to listen for changes in real-time, providing a live and responsive experience.
*   **Database Queries:** The project uses fundamental Firestore queries to interact with the database, including fetching document collections, filtering results using `whereField`, and ordering data.

## 3. Data Model

The database is structured around several top-level collections, each representing a core entity of the application. This model is designed for efficient querying and scalability.

### Users Collection
Stores public user profiles. The document ID corresponds to the user's Firebase Authentication UID.
```json
{
  "users": {
    "USER_UID_123": {
      "username": "John Appleseed",
      "email": "john.a@example.com",
      "profileImageURL": "https://example.com/profile.jpg",
      "createdAt": "Timestamp",
      "rating": 4.8
    }
  }
}
```

### Products Collection
Contains all items listed for sale on the marketplace.
```json
{
  "products": {
    "PRODUCT_ID_ABC": {
      "title": "Vintage Camera",
      "description": "A classic 35mm film camera in great condition.",
      "price": 150,
      "category": "Electronics",
      "sellerId": "USER_UID_123",
      "imageURLs": [
        "https://example.com/image1.jpg"
      ]
    }
  }
}
```

### Chats Collection
Represents a private conversation thread. It contains a `messages` sub-collection for all messages within that thread.
```json
{
  "chats": {
    "CHAT_ID_XYZ": {
      "participantIds": ["USER_UID_123", "USER_UID_456"],
      "lastMessage": "See you then!",
      "lastMessageTimestamp": "Timestamp",
      "messages": {
        "MESSAGE_ID_1": {
          "senderId": "USER_UID_456",
          "text": "See you then!",
          "timestamp": "Timestamp"
        }
      }
    }
  }
}
```

### Reviews Collection
Stores reviews left by users for sellers.
```json
{
  "reviews": {
    "REVIEW_ID_789": {
      "comment": "Fast shipping and great product!",
      "rating": 5,
      "sellerId": "USER_UID_123",
      "reviewerId": "USER_UID_456",
      "createdAt": "Timestamp"
    }
  }
}
```

## 4. Future Work: Roadmap to Advanced Features

To further enhance the application and demonstrate advanced NoSQL concepts, the following features are planned.

### Advanced Full-Text Search
*   **Challenge:** Firestore's native queries do not support efficient, multi-field full-text search.
*   **Planned Solution:** Integrate a dedicated search service like **Algolia**. Use Cloud Functions to synchronize the Firestore `products` collection with an Algolia search index. The client application will query Algolia for searches, receive product IDs, and then fetch the full documents from Firestore.

### Automated Data Aggregation and Denormalization
*   **Challenge:** Calculating a seller's average rating by querying all their reviews on every profile view is inefficient.
*   **Planned Solution:** Implement denormalization. The `users` documents will be extended to include `averageRating` and `numberOfRatings` fields. A Cloud Function, triggered on new review creation, will automatically recalculate these values and update the seller's user document within a Firestore Transaction to ensure data consistency.

## 5. Setup Instructions

1.  **Clone the Repository:** Access the project code from the provided repository link.
2.  **Firebase Configuration:** Obtain a `GoogleService-Info.plist` file from your Firebase project and place it in the root of the Xcode project directory.
3.  **Install Dependencies:** The project uses Swift Package Manager. Dependencies should be resolved automatically by Xcode.
4.  **Build & Run:** Open the `.xcodeproj` file in Xcode and run the application on a target iOS simulator or a physical device.

## 6. Data Generation

The data currently in the database was generated manually for development and testing purposes to ensure all use cases function correctly.

## 7. Team Contribution

This project was developed solely by [Your Name], who was responsible for the application design, data model, and all client-side implementation.

