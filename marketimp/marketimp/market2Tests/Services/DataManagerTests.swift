import XCTest
import Combine
@testable import market2

class DataManagerTests: XCTestCase {
    
    var dataManager: DataManager!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        dataManager = DataManager()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        dataManager = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        // Assert
        XCTAssertFalse(dataManager.products.isEmpty)
        XCTAssertEqual(dataManager.products.count, Product.examples.count)
        XCTAssertNotNil(dataManager.userProfile)
        XCTAssertEqual(dataManager.userProfile?.id, User.example.id)
        XCTAssertFalse(dataManager.chats.isEmpty)
    }
    
    // MARK: - Product Tests
    
    func testFetchProducts() {
        // Arrange
        dataManager.products = []
        XCTAssertTrue(dataManager.products.isEmpty)
        
        // Act
        dataManager.fetchProducts()
        
        // Assert
        XCTAssertFalse(dataManager.products.isEmpty)
        XCTAssertEqual(dataManager.products.count, Product.examples.count)
    }
    
    func testAddProduct() {
        // Arrange
        let initialCount = dataManager.products.count
        let newProduct = Product(
            id: "new-product",
            sellerId: "user1",
            title: "New Test Product",
            description: "Test Description",
            price: 1000,
            category: "Test",
            condition: "New",
            location: "Test",
            imageURLs: [],
            status: .active,
            createdAt: Date()
        )
        
        // Act
        dataManager.addProduct(newProduct)
        
        // Assert
        XCTAssertEqual(dataManager.products.count, initialCount + 1)
        
        // Check that the product was added
        let addedProduct = dataManager.products.first { $0.id == "new-product" }
        XCTAssertNotNil(addedProduct)
        XCTAssertEqual(addedProduct?.title, "New Test Product")
    }
    
    // MARK: - Chat Tests
    
    func testCreateChat() {
        // Arrange
        let initialChatCount = dataManager.chats.count
        let otherUser = User(
            id: "new-user",
            username: "New User",
            email: "new@example.com",
            profileImageURL: nil,
            rating: 4.0,
            createdAt: Date()
        )
        
        // Act
        let chat = dataManager.createChat(with: otherUser)
        
        // Assert
        XCTAssertNotNil(chat)
        XCTAssertEqual(dataManager.chats.count, initialChatCount + 1)
        
        // Check chat ID (should be created from sorted user IDs)
        let expectedChatId = [dataManager.userProfile!.id, otherUser.id].sorted().joined(separator: "_")
        XCTAssertEqual(chat?.id, expectedChatId)
        
        // Check chat participants
        XCTAssertEqual(chat?.participants.count, 2)
        XCTAssertTrue(chat?.participants.contains(dataManager.userProfile!.id) ?? false)
        XCTAssertTrue(chat?.participants.contains(otherUser.id) ?? false)
    }
    
    func testCreateExistingChat() {
        // Arrange - create a chat
        let otherUser = User(
            id: "new-user",
            username: "New User",
            email: "new@example.com",
            profileImageURL: nil,
            rating: 4.0,
            createdAt: Date()
        )
        let initialChat = dataManager.createChat(with: otherUser)
        let initialChatCount = dataManager.chats.count
        
        // Act - try to create the same chat again
        let chat = dataManager.createChat(with: otherUser)
        
        // Assert
        XCTAssertNotNil(chat)
        XCTAssertEqual(dataManager.chats.count, initialChatCount) // Number of chats should not change
        XCTAssertEqual(chat?.id, initialChat?.id) // Should return the same chat
    }
    
    func testSendMessage() {
        // Arrange
        let receiverId = "user2"
        let content = "Test message"
        let initialChatsCount = dataManager.chats.count
        
        // Act
        dataManager.sendMessage(content: content, to: receiverId)
        
        // Assert
        // Check that the chat was created or updated
        let chatId = [dataManager.userProfile!.id, receiverId].sorted().joined(separator: "_")
        let chat = dataManager.chats.first { $0.id == chatId }
        
        XCTAssertNotNil(chat)
        XCTAssertNotNil(chat?.lastMessage)
        XCTAssertEqual(chat?.lastMessage?.content, content)
        XCTAssertEqual(chat?.lastMessage?.senderId, dataManager.userProfile!.id)
        XCTAssertEqual(chat?.lastMessage?.receiverId, receiverId)
        XCTAssertFalse(chat?.lastMessage?.isRead ?? true)
    }
    
    func testGetMessages() {
        // Arrange
        let chatId = [dataManager.userProfile!.id, "user2"].sorted().joined(separator: "_")
        
        // Act
        let messages = dataManager.getMessages(for: chatId)
        
        // Assert
        // Check that all messages belong to the correct chat
        for message in messages {
            let participants = [message.senderId, message.receiverId].sorted()
            let messageChatId = participants.joined(separator: "_")
            XCTAssertEqual(messageChatId, chatId)
        }
        
        // Check that messages are sorted by time (oldest to newest)
        for i in 0..<messages.count-1 {
            XCTAssertLessThanOrEqual(messages[i].timestamp, messages[i+1].timestamp)
        }
    }
    
    // MARK: - User Tests
    
    func testGetUser() {
        // Act
        let user = dataManager.getUser(id: dataManager.userProfile!.id)
        
        // Assert
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.id, dataManager.userProfile!.id)
    }
    
    func testGetOtherParticipant() {
        // Arrange
        guard let currentUserId = dataManager.userProfile?.id else {
            XCTFail("Current user profile is nil")
            return
        }
        
        // Create a test chat
        let otherUserId = "test-user"
        let chat = Chat(
            id: [currentUserId, otherUserId].sorted().joined(separator: "_"),
            participants: [currentUserId, otherUserId],
            lastMessage: nil
        )
        
        // Act
        let otherUser = dataManager.getOtherParticipant(in: chat)
        
        // Assert
        XCTAssertNotNil(otherUser)
        // In the current implementation, it always returns User.example
        XCTAssertEqual(otherUser?.id, User.example.id)
    }
    
    func testGetSeller() {
        // Arrange
        let product = Product.examples[0]
        
        // Act
        let seller = dataManager.getSeller(for: product)
        
        // Assert
        XCTAssertNotNil(seller)
        // In the current implementation, it always returns User.example
        XCTAssertEqual(seller?.id, User.example.id)
    }
}
