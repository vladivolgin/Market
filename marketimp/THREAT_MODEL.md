# Threat Model for the "Gamer's Marketplace" Application


## For detailed security analysis, see:
[📁 Cyber Security - Google Drive](https://drive.google.com/drive/folders/1Dq6IPFaSAm9WPltazCQnLp2GgLApU44l?usp=sharing)

## 1. Introduction

This document outlines the threat model for the "Gamer's Marketplace" mobile application. The goal of this threat modeling exercise is to proactively identify, evaluate, and define mitigation strategies for potential security threats. This analysis is conducted using the **STRIDE** methodology.

## 2. Key Assets

The following assets are considered most valuable and require protection:

*   **User Personal Data:** Usernames, emails, passwords, message history, ratings.
*   **Authentication Data:** Session tokens stored on the device.
*   **Private Messages:** The content of conversations between users.
*   **Item Data:** Information about items listed for sale, their prices, and their owners.
*   **System Reputation:** User trust in the platform's integrity and security.

## 3. Potential Attackers

*   **Unauthenticated Attacker:** An external party without a user account.
*   **Authenticated Attacker:** A registered user who attempts to gain unauthorized access to other users' data or disrupt the system.

## 4. Threat Analysis by Component

### Component: Authentication and Session Management

| Threat (STRIDE) | Attack Scenario | Mitigation | Status |
| :--- | :--- | :--- | :--- |
| **S**poofing | An attacker brute-forces a user's password or uses stolen credentials. | 1. Enforce a strong password policy (complexity requirements). <br> 2. Implement an account lockout mechanism after several failed login attempts. | Partially Implemented |
| **I**nformation Disclosure | 1. An attacker intercepts the login/password credentials during transit. <br> 2. An attacker with physical access to the device steals the session token. | 1. **Enforce TLS (HTTPS)** for all network requests. <br> 2. **Store the session token in secure storage (Keychain)**, not in `UserDefaults`. | **Implemented** |
| **D**enial of Service | An attacker sends a massive number of requests to the `/login` endpoint, overwhelming the server. | Implement rate limiting on the server-side. | *Server-Side Task* |

### Component: User Profile

| Threat (STRIDE) | Attack Scenario | Mitigation | Status |
| :--- | :--- | :--- | :--- |
| **T**ampering | User A attempts to modify the profile data (e.g., name, avatar) of User B by sending a request with User B's ID. | The server must **always** verify that the user ID from the authentication token matches the ID of the profile being modified. Requests like `PUT /users/{id}` must ignore the `{id}` from the URL path in favor of the ID from the token. | *Server-Side Task* |
| **I**nformation Disclosure | User A views private information (e.g., email address) on User B's profile. | The server must clearly define which profile fields are public and which are private. The API must not return private fields when another user's profile is requested. | *Server-Side Task* |

### Component: Marketplace and Chats

| Threat (STRIDE) | Attack Scenario | Mitigation | Status |
| :--- | :--- | :--- | :--- |
| **E**levation of Privilege | User A attempts to list an item for sale on behalf of User B. | The server must use the user ID from the session token to identify the seller, rather than trusting an ID sent in the request body. | *Server-Side Task* |
| **T**ampering | User A changes the price of an item listed by User B. | Similar to the point above. All modification/deletion operations must be authorized on the server by verifying that the token's user ID matches the item's seller ID. | *Server-Side Task* |
| **I**nformation Disclosure | **(Critical Threat)** User A gains access to a private conversation between User B and User C. | For endpoints like `GET /chats/{chat_id}/messages`, the server **must** verify that the user ID from the token is a participant in the specified `{chat_id}`. Otherwise, it should return a 403 Forbidden or 404 Not Found error. | *Server-Side Task* |
| **T**ampering | User A injects malicious code (e.g., Cross-Site Scripting - XSS) into an item description or a chat message. | **Input validation and sanitization** of all user-provided content, both on the client-side (for immediate feedback) and **mandatorily on the server-side** before saving to the database. | Requires Implementation |

## 5. Conclusions and Recommendations

The application currently has key client-side security measures in place:
*   **Secure Authentication:** Login requests are transmitted over HTTPS.
*   **Secure Session Storage:** The authentication token is stored encrypted in the Keychain.

To fully secure the application, the remaining measures must be implemented, primarily focusing on **server-side authorization** for all data operations and comprehensive **user input validation**.

