# NoSQL Project Report: SwiftUI Marketplace

## 1. Project Description

This project is a feature-rich mobile application for iOS, built with SwiftUI and backed by Google's NoSQL database, **Firestore**. The application serves as a multi-functional platform, integrating a product marketplace, a community forum, a news feed, and a real-time private chat system.

The choice of Firestore, a document-based NoSQL database, was a strategic decision driven by several key factors:

*   **Flexible Schema:** The ability to have documents with varying structures is ideal for an application with diverse data models like products, forum posts, and user profiles.
*   **Scalability:** Firestore is designed for massive scalability, ensuring the application can handle a growing number of users and data without significant architectural changes.
*   **Real-Time Capabilities:** Its real-time data synchronization features are crucial for delivering a modern, interactive user experience, especially for the chat and live forum updates.

## 2. Implemented Core Functionality

### 2.1 Authentication & Security
- **Firebase Authentication** with email/password and social login
- **Security Rules** implementing role-based access control
- **Client-side validation** with server-side verification

### 2.2 CRUD Operations
- **Create:** Add products, forum topics, reviews, messages
- **Read:** Real-time queries with pagination and filtering  
- **Update:** Edit products, mark messages as read, update profiles
- **Delete:** Remove products, moderate forum content

### 2.3 Real-Time Features
- **Live Chat:** `addSnapshotListener` for instant messaging
- **Forum Updates:** Real-time topic and reply synchronization
- **Notification System:** Push notifications for new messages/reviews

  ### 2.4 Advanced Queries Implemented
```swift
// Complex compound queries
db.collection("products")
    .whereField("category", isEqualTo: "Electronics")
    .whereField("price", isLessThan: 200)
    .order(by: "createdAt", descending: true)
    .limit(to: 10)

// Real-time listeners with error handling
db.collection("chats").document(chatId)
    .collection("messages")
    .order(by: "timestamp")
    .addSnapshotListener { querySnapshot, error in
        // Handle real-time updates
```

# 3. Data Model

## Database schema
<img width="989" height="682" alt="Снимок экрана 2025-11-15 в 16 06 56" src="https://github.com/user-attachments/assets/128e68c0-0d7b-406e-8da3-ee8b61b6a294" />

The database is structured around several top-level collections, each representing a core entity of the application. This model is designed for efficient querying and scalability.

## 3.1 Performance Optimizations

### Data Denormalization
- **User ratings** cached in user documents for instant access
- **Product thumbnails** stored separately from full images
- **Chat summaries** maintained for efficient list views

### Query Optimization  
- **Composite indexes** for complex filtering
- **Pagination** using cursor-based approach
- **Offline persistence** enabled for seamless user experience
  
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
### Forum Topics Collection
Stores discussion topics for the community forum.
```json
{
  "forumTopics": {
    "TOPIC_ID_XYZ": {
      "title": "Best Gaming Setup 2024",
      "content": "What's your current gaming setup?",
      "authorId": "USER_UID_123",
      "category": "Discussion",
      "createdAt": "Timestamp",
      "replies": {
        "REPLY_ID_1": {
          "authorId": "USER_UID_456",
          "content": "I love my mechanical keyboard!",
          "timestamp": "Timestamp"
        }
      }
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

