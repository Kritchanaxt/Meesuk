//
//  NetworkManager.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Alamofire
import Combine
import Foundation

/// Network Manager - จัดการ API Requests ด้วย Alamofire
final class NetworkManager: ObservableObject {

    // MARK: - Singleton
    static let shared = NetworkManager()

    // MARK: - Properties
    private let session: Session
    private let baseURL: String

    @Published var isConnected: Bool = true

    // MARK: - Initialization

    private init() {
        self.baseURL = AppEnvironment.current.baseURL

        // Configure Session
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = AppConstants.requestTimeout
        configuration.timeoutIntervalForResource = AppConstants.resourceTimeout
        configuration.waitsForConnectivity = true

        // Interceptor for Auth
        let interceptor = AuthInterceptor()

        // Create Session
        self.session = Session(
            configuration: configuration,
            interceptor: interceptor,
            eventMonitors: [NetworkLogger()]
        )

        // Monitor Network
        setupNetworkMonitor()
    }

    // MARK: - Network Monitor

    private func setupNetworkMonitor() {
        let monitor = NetworkReachabilityManager()
        monitor?.startListening { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .reachable:
                    self?.isConnected = true
                case .notReachable, .unknown:
                    self?.isConnected = false
                }
            }
        }
    }

    // MARK: - Generic Request Methods

    /// GET Request
    func get<T: Decodable>(
        _ endpoint: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        try await request(
            endpoint,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
    }

    /// POST Request
    func post<T: Decodable>(
        _ endpoint: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        try await request(
            endpoint,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
    }

    /// POST with Encodable Body
    func post<T: Decodable, B: Encodable>(
        _ endpoint: String,
        body: B,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        try await requestWithBody(
            endpoint,
            method: .post,
            body: body,
            headers: headers
        )
    }

    /// PUT Request
    func put<T: Decodable, B: Encodable>(
        _ endpoint: String,
        body: B,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        try await requestWithBody(
            endpoint,
            method: .put,
            body: body,
            headers: headers
        )
    }

    /// PATCH Request
    func patch<T: Decodable, B: Encodable>(
        _ endpoint: String,
        body: B,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        try await requestWithBody(
            endpoint,
            method: .patch,
            body: body,
            headers: headers
        )
    }

    /// DELETE Request
    func delete<T: Decodable>(
        _ endpoint: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        try await request(
            endpoint,
            method: .delete,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
    }

    /// DELETE with no response body
    func delete(
        _ endpoint: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) async throws {
        let url = endpoint.contains("://") ? endpoint : baseURL + endpoint

        _ = try await session.request(
            url,
            method: .delete,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate()
        .serializingData()
        .value
    }

    // MARK: - Private Request Methods

    private func request<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?
    ) async throws -> T {
        let url = endpoint.contains("://") ? endpoint : baseURL + endpoint

        let response = try await session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .validate()
        .serializingDecodable(T.self, decoder: JSONDecoder.apiDecoder)
        .value

        return response
    }

    private func requestWithBody<T: Decodable, B: Encodable>(
        _ endpoint: String,
        method: HTTPMethod,
        body: B,
        headers: HTTPHeaders?
    ) async throws -> T {
        let url = endpoint.contains("://") ? endpoint : baseURL + endpoint

        let response = try await session.request(
            url,
            method: method,
            parameters: body,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
        .validate()
        .serializingDecodable(T.self, decoder: JSONDecoder.apiDecoder)
        .value

        return response
    }

    // MARK: - Upload

    /// Upload File
    func upload<T: Decodable>(
        _ endpoint: String,
        fileURL: URL,
        fileName: String,
        mimeType: String,
        parameters: [String: String]? = nil
    ) async throws -> T {
        let url = endpoint.contains("://") ? endpoint : baseURL + endpoint

        let response = try await session.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(
                    fileURL, withName: "file", fileName: fileName, mimeType: mimeType)

                parameters?.forEach { key, value in
                    if let data = value.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            },
            to: url
        )
        .validate()
        .serializingDecodable(T.self, decoder: JSONDecoder.apiDecoder)
        .value

        return response
    }

    /// Upload Data
    func upload<T: Decodable>(
        _ endpoint: String,
        data: Data,
        fileName: String,
        mimeType: String,
        fieldName: String = "file"
    ) async throws -> T {
        let url = endpoint.contains("://") ? endpoint : baseURL + endpoint

        let response = try await session.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(
                    data, withName: fieldName, fileName: fileName, mimeType: mimeType)
            },
            to: url
        )
        .validate()
        .serializingDecodable(T.self, decoder: JSONDecoder.apiDecoder)
        .value

        return response
    }

    // MARK: - Download

    /// Download File
    func download(
        _ endpoint: String,
        to destination: URL? = nil,
        progress: ((Double) -> Void)? = nil
    ) async throws -> URL {
        let url = endpoint.contains("://") ? endpoint : baseURL + endpoint

        let downloadDestination: DownloadRequest.Destination = { temporaryURL, response in
            let destinationURL =
                destination
                ?? FileManager.default.temporaryDirectory.appendingPathComponent(
                    response.suggestedFilename ?? "download")
            return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        let request = session.download(url, to: downloadDestination)

        if let progress = progress {
            request.downloadProgress { prog in
                progress(prog.fractionCompleted)
            }
        }

        let response = await request.serializingDownloadedFileURL().response

        guard let fileURL = response.value else {
            throw NetworkError.downloadFailed
        }

        return fileURL
    }
}

// MARK: - Auth Interceptor

class AuthInterceptor: RequestInterceptor {

    func adapt(
        _ urlRequest: URLRequest, for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest

        // Add Auth Token
        if let token = KeychainManager.shared.get(key: AppConstants.Keychain.accessToken) {
            request.headers.add(.authorization(bearerToken: token))
        }

        // Add Common Headers
        request.headers.add(.contentType("application/json"))
        request.headers.add(.accept("application/json"))

        completion(.success(request))
    }

    func retry(
        _ request: Request, for session: Session, dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetry)
            return
        }

        // Retry on 401 with token refresh
        if response.statusCode == 401 {
            Task {
                do {
                    try await AuthService.shared.refreshToken()
                    completion(.retry)
                } catch {
                    completion(.doNotRetry)
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }
}

// MARK: - Network Logger

class NetworkLogger: EventMonitor {

    func requestDidResume(_ request: Request) {
        #if DEBUG
            print("🌐 Request: \(request.description)")
        #endif
    }

    func request<Value>(
        _ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>
    ) {
        #if DEBUG
            if let statusCode = response.response?.statusCode {
                let emoji = (200...299).contains(statusCode) ? "✅" : "❌"
                print("\(emoji) Response [\(statusCode)]: \(request.description)")
            }

            if let error = response.error {
                print("❌ Error: \(error.localizedDescription)")
            }
        #endif
    }
}

// MARK: - Network Errors

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case unauthorized
    case serverError(Int)
    case downloadFailed
    case uploadFailed
    case noConnection
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .downloadFailed:
            return "Download failed"
        case .uploadFailed:
            return "Upload failed"
        case .noConnection:
            return "No internet connection"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

// MARK: - JSON Decoder Extension

extension JSONDecoder {
    static var apiDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            // Try ISO8601 with fractional seconds
            let iso8601Formatter = ISO8601DateFormatter()
            iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            if let date = iso8601Formatter.date(from: dateString) {
                return date
            }

            // Try ISO8601 without fractional seconds
            iso8601Formatter.formatOptions = [.withInternetDateTime]
            if let date = iso8601Formatter.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(dateString)"
            )
        }
        return decoder
    }
}
