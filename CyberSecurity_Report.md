Cyber Security Module: Project Defense Report

Project: GamerMarket iOS Application Student: Ivolgin Vladislav
1. Introduction & Security Posture

This report details the security architecture implemented within the "GamerMarket" iOS application. The primary objective was to transition the application from a baseline functional state to a comprehensively secured platform, adhering to the principles of defense-in-depth. A multi-layered security strategy was adopted, ensuring that the confidentiality, integrity, and availability of user data are protected across the entire application stack—from the client-side user interface to server-side data storage and the transport layer in between. The following sections outline the threat model, the specific security controls implemented, and how these measures satisfy the module's qualification objectives.

2. Threat Model Analysis

A formal threat model was established at the project's outset to proactively identify, evaluate, and define mitigation strategies for potential security risks. Using the STRIDE methodology, a detailed analysis was conducted (see THREAT_MODEL.md) to map potential attack scenarios to specific components of the application. The primary threats identified and the corresponding architectural decisions made to mitigate them are summarized below:

Spoofing
Scenario: The attacker attempts to impersonate another user by using stolen credentials.
Implemented Risk Reduction Measure: Firebase Authentication: A standard, reliable authentication mechanism has been implemented.
Tampering
Scenario: User A attempts to change the price of a product belonging to user B by sending a fake request to the server.
Implemented Risk Reduction Measure: Firebase Security Rules: A rule has been implemented on the server that allows changing a product only if request.auth.uid matches the sellerId of the product.
Repudiation
Scenario: The user denies having sent a specific message in the chat.
Implemented Risk Reduction Measure: Association of messages with sender ID: Each message in Firestore is linked to a senderId, which serves as proof of authorship.
Information Disclosure
Scenario 1: An attacker gains physical access to the device and attempts to steal the session token.
Implemented Risk Reduction Measure 1: iOS Keychain: The authentication token is stored in encrypted form in Keychain, not in UserDefaults.
Scenario 2: User A attempts to read the private chat between users B and C.
Implemented Risk Reduction Measure 2: Firebase Security Rules: The rule on the server allows access to the chat only to users whose IDs are in the participantIds array of this chat.
Denial of Service
Scenario: The attacker sends excessively long or malicious strings to input fields (search, messages) to cause the application or server to crash.
Implemented Risk Reduction Measure: Input Validation: InputValidator.swift is implemented on the client, which checks the length of the input and the presence of invalid characters in GamerMarketView.swift and ChatView.swift.
Elevation of Privilege
Scenario: A regular user attempts to obtain rights to delete or edit someone else's product.
Implemented Risk Reduction Measure: Two-level protections: 1. On the client: The ‘Edit’ and ‘Delete’ buttons in ProductDetailView.swift are hidden if the user ID does not match the sellerId. 2. On the server: Firebase Rules enforce blocking any write attempts that violate this rule.
3. Implemented Security Measures & Controls

3.1. Application & Data Layer Security

Authentication:
Implementation: User authentication is managed via Firebase Authentication, a robust and industry-standard service. The AuthManager.swift class was implemented to handle the entire authentication lifecycle, including login and logout flows.
Threat Mitigated: Spoofing. Only users with valid credentials can access the application's core features.
Authorization (Access Control):
Implementation: Critical authorization checks have been implemented on both the client and server. For instance, in ProductDetailView.swift, the "Edit" and "Delete" buttons are only rendered if the logged-in user's ID matches the product's sellerId. This prevents regular users from even seeing options to modify content that isn't theirs.
// --- CORRECTED AUTHORIZATION BLOCK ---
if dataManager.userProfile?.id == product.sellerId {
    // Show Edit and Delete buttons
}

More importantly, Firebase Security Rules have been configured to enforce this logic on the server, making it impossible for a compromised client to bypass these checks.
Threat Mitigated: Elevation of Privilege, Tampering.
Input Validation:
Implementation: A dedicated InputValidator.swift utility was created to perform security checks on user input. It includes functions like isSafe() to block dangerous characters and isLengthValid() to mitigate DoS vectors.
// InputValidator.swift
struct InputValidator {
    private static let disallowedCharacters = CharacterSet(charactersIn: "<>\\\"';&")
    static func isSafe(_ input: String) -> Bool {
        return input.rangeOfCharacter(from: disallowedCharacters) == nil
    }
}

This validator is used in all critical user-facing text fields.
Threat Mitigated: Tampering, Information Disclosure, Denial of Service.
3.2. Transport Layer Security

HTTPS Enforcement & SSL Pinning:
Implementation: A centralized NetworkManager.swift was created to handle all generic network requests. It is configured to strictly enforce HTTPS, ensuring all data is encrypted in transit. Furthermore, it implements SSL Pinning, a technique where the application is hardcoded to trust only a specific server certificate.
Threat Mitigated: Information Disclosure, Tampering. Protects against eavesdropping and sophisticated Man-in-the-Middle (MitM) attacks.
3.3. Data-at-Rest & Client-Side Security

Secure Credential Storage:
Implementation: The AuthManager.swift utilizes a KeychainHelper utility. After a successful login, the user's authentication token is stored securely in the iOS Keychain, not in UserDefaults.
Threat Mitigated: Information Disclosure. Protects the user's session token from being easily extracted from the device's file system.
3.4. Server-Side Security (Firebase)

Implementation: A comprehensive set of security rules has been deployed to the Firestore database. These server-side rules are the ultimate authority on data access and cannot be bypassed by a compromised client.
User Profile Protection: Users can read public profile information, but can only modify their own data.
match /Users/{userId} {
  allow read: if true;
  allow write: if request.auth.uid == userId;
}

Product Integrity: Any authenticated user can create a product. However, editing or deleting a product is strictly limited to the user who originally listed it (sellerId).
match /Products/{productId} {
  allow create: if request.auth != null;
  allow update, delete: if request.auth.uid == resource.data.sellerId;
}

Chat & Message Confidentiality: Access to a chat document is restricted to users who are listed as participants in that chat's participantIds array.
match /Chats/{chatId} {
  allow read, write: if request.auth.uid in resource.data.participantIds;
}

3.5. Development Lifecycle Security (DevSecOps)

Secret Management with .xcconfig Files: Sensitive information, such as API keys, is never hardcoded. Instead, secrets are stored in environment-specific configuration files (.xcconfig).
Preventing Secret Leakage with .gitignore: The project's .gitignore file is explicitly configured to ignore these configuration files, preventing accidental leakage of secrets into version control.
# Ignore sensitive configuration files
*.xcconfig

Threat Mitigated: Information Disclosure.
4. Live Application Security Architecture: A Server-Authoritative Approach

The GamerMarket project was designed using a server-authoritative security model. This architectural principle dictates that the ultimate authority for any data access or modification request is the server, not the client application. This approach is fundamental to securing a system with multiple users, as it assumes the client can be untrustworthy or even malicious. The cornerstone of this strategy is the set of Firebase Security Rules.

Scenario 1: Compromised Client Application. An attacker modifies the app to always display the "Delete" button. When the attacker taps this button, the app sends a delete request to Firestore. However, the server independently evaluates the request against the rule allow delete: if request.auth.uid == resource.data.sellerId;. Since the attacker's UID does not match the product's sellerId, the operation fails. The client-side modification is rendered completely ineffective.
Scenario 2: Direct API Manipulation. A sophisticated attacker uses network tools to construct a raw API request to read a private chat. The request is authenticated with their own valid token, but when it reaches the server, the Firebase Security Rule allow read: if request.auth.uid in resource.data.participantIds; is triggered. The server checks if the attacker's UID is in the chat's participant list, finds that it is not, and returns a "Permission Denied" error.
This server-authoritative trust model is the definitive method for securing a 'live' application. It ensures that data integrity and confidentiality are maintained at the data source.

5. Conclusion

The GamerMarket application has been systematically hardened against a wide range of common cyber threats. By implementing a defense-in-depth strategy that spans the client, server, and transport layers, the project successfully fulfills the requirements for a comprehensively secured application.
