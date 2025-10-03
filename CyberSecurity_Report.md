# Cyber Security Module: Project Defense Report

> **Project:** GamerMarket iOS Application
> **Student:** Ivolgin Vladislav

## 1. Introduction & Security Posture

This report details the security architecture implemented within the "GamerMarket" iOS application. The primary objective was to transition the application from a baseline functional state to a comprehensively secured platform, adhering to the principles of defense-in-depth. A multi-layered security strategy was adopted, ensuring that the confidentiality, integrity, and availability of user data are protected across the entire application stack—from the client-side user interface to server-side data storage and the transport layer in between.

## 2. Threat Model Analysis

A formal threat model was established using the STRIDE methodology to proactively identify, evaluate, and define mitigation strategies for potential security risks.

### STRIDE Summary

| Threat Category | Attack Scenario | Implemented Risk Reduction Measure |
| :--- | :--- | :--- |
| **Spoofing** | An attacker attempts to impersonate another user by using stolen credentials. | **Firebase Authentication:** A standard, reliable authentication mechanism has been implemented. |
| **Tampering** | User A attempts to change the price of a product belonging to user B by sending a fake request to the server. | **Firebase Security Rules:** A server-side rule allows product modification only if `request.auth.uid` matches the `sellerId`. |
| **Repudiation** | A user denies having sent a specific message in the chat. | **Message-Sender Association:** Each message in Firestore is linked to a `senderId`, serving as proof of authorship. |
| **Information Disclosure** | 1. An attacker gains physical access to the device to steal the session token. <br> 2. User A attempts to read the private chat between users B and C. | 1. **iOS Keychain:** The auth token is stored in the encrypted Keychain, not `UserDefaults`. <br> 2. **Firebase Security Rules:** Access to a chat is restricted to users listed in the `participantIds` array. |
| **Denial of Service** | An attacker sends excessively long or malicious strings to input fields to crash the application or server. | **Client-Side Input Validation:** `InputValidator.swift` checks input length and for invalid characters in views like `GamerMarketView.swift` and `ChatView.swift`. |
| **Elevation of Privilege** | A regular user attempts to delete or edit someone else's product. | **Two-Level Protection:** 1. **Client-Side:** 'Edit'/'Delete' buttons are hidden if the user is not the seller. 2. **Server-Side:** Firebase Rules block any unauthorized write attempts. |

## 3. Implemented Security Measures & Controls

### 3.1. Application & Data Layer Security

*   **Authentication:**
    *   **Implementation:** User authentication is managed via Firebase Authentication. The `AuthManager.swift` class handles the entire authentication lifecycle.
    *   **Threat Mitigated:** Spoofing.

*   **Authorization (Access Control):**
    *   **Implementation:** Critical authorization checks are on both the client and server. On the client, UI elements for editing are conditionally rendered.
```swift
        // ProductDetailView.swift - Conditional UI Rendering
        if dataManager.userProfile?.id == product.sellerId {
            // Show Edit and Delete buttons
        }
```
    *   Server-side enforcement via Firebase Security Rules is the ultimate authority.
    *   **Threat Mitigated:** Elevation of Privilege, Tampering.

*   **Input Validation:**
    *   **Implementation:** A dedicated `InputValidator.swift` utility was created to sanitize user input.
```swift
        // InputValidator.swift
        struct InputValidator {
            private static let disallowedCharacters = CharacterSet(charactersIn: "<>\\\"';&")
            
            static func isSafe(_ input: String) -> Bool {
                return input.rangeOfCharacter(from: disallowedCharacters) == nil
            }
        }
```
    *   **Threat Mitigated:** Tampering, Information Disclosure, Denial of Service.

### 3.2. Transport Layer Security

*   **HTTPS Enforcement & SSL Pinning:**
    *   **Implementation:** A centralized `NetworkManager.swift` strictly enforces HTTPS and implements SSL Pinning to trust only a specific server certificate.
    *   **Threat Mitigated:** Information Disclosure, Tampering (protects against eavesdropping and Man-in-the-Middle attacks).

### 3.3. Data-at-Rest & Client-Side Security

*   **Secure Credential Storage:**
    *   **Implementation:** `AuthManager.swift` uses a `KeychainHelper` utility to store the user's authentication token securely in the iOS Keychain.
    *   **Threat Mitigated:** Information Disclosure.

### 3.4. Server-Side Security (Firebase Rules)

A comprehensive set of security rules has been deployed to Firestore.

*   **User Profile Protection:** Users can only modify their own data.
```
    match /Users/{userId} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
    }
```
*   **Product Integrity:** Any authenticated user can create a product, but only the original seller can update or delete it.
```
    match /Products/{productId} {
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.sellerId;
    }
```
*   **Chat & Message Confidentiality:** Access to a chat is restricted to its participants.
```
    match /Chats/{chatId} {
      allow read, write: if request.auth.uid in resource.data.participantIds;
    }
```

### 3.5. Development Lifecycle Security (DevSecOps)

*   **Secret Management:** Sensitive information (e.g., API keys) is stored in `.xcconfig` files, not hardcoded in source code.
*   **Preventing Secret Leakage:** The `.gitignore` file is configured to ignore all `.xcconfig` files, preventing accidental commits of sensitive credentials to version control.
```
    # Ignore sensitive configuration files
    *.xcconfig
```
*   **Threat Mitigated:** Information Disclosure.

## 4. Live Application Security Architecture

The project uses a **server-authoritative security model**. The ultimate authority for any data access or modification is the server (Firebase), not the client. This is fundamental for securing a multi-user system, as the client is assumed to be untrustworthy. Firebase Security Rules are the cornerstone of this strategy, as they are enforced on Google's servers and cannot be bypassed by a compromised client.

## 5. Conclusion

The GamerMarket application has been systematically hardened against a wide range of common cyber threats. By implementing a defense-in-depth strategy that spans the client, server, and transport layers, the project successfully fulfills the security requirements for a modern, live application.
