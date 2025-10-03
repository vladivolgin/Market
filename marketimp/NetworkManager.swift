import Foundation
import CommonCrypto

struct LoginRequestBody: Encodable {
    let username: String
    let password: String
}

enum NetworkError: Error {
    case invalidURL, unsupportedURL, requestFailed(Error), sslPinningFailed, noData, decodingFailed
}

class NetworkManager: NSObject, URLSessionDelegate {

    static let shared = NetworkManager()
    private var session: URLSession!
    private let pinnedPublicKeyHash = "YOUR_SERVER_PUBLIC_KEY_HASH_BASE64"

    private override init() {
        super.init()
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        // --- ИСПРАВЛЕНИЕ: Используем новую функцию ---
        guard let serverCertificate = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate], !serverCertificate.isEmpty else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        guard let serverPublicKey = SecCertificateCopyKey(serverCertificate[0]) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        guard let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil) as Data? else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        let serverPublicKeyHash = sha256(data: serverPublicKeyData).base64EncodedString()

        if serverPublicKeyHash == pinnedPublicKeyHash {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            print("SSL Pinning Failed: Hashes do not match.")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    private func sha256(data: Data) -> Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
    // ... (остальные функции login и request остаются без изменений)
    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.yourapp.com/login") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequestBody(username: username, password: password)
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error { completion(.failure(NetworkError.requestFailed(error))); return }
            guard let data = data else { completion(.failure(NetworkError.noData)); return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["token"] as? String {
                    completion(.success(token))
                } else {
                    completion(.failure(NetworkError.decodingFailed))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func request(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL)); return
        }
        guard url.scheme == "https" else {
            completion(.failure(.unsupportedURL)); return
        }
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error { completion(.failure(NetworkError.requestFailed(error))); return }
            guard let data = data else { completion(.failure(.noData)); return }
            completion(.success(data))
        }
        task.resume()
    }
}
