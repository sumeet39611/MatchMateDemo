//
//  APIClient.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import Foundation

protocol NetworkClient {
    func fetchProfiles(page: Int, results: Int) async throws -> [Profile]
}

enum NetworkError: LocalizedError {
    case invalidResponse
    case serverError(Int)
    case decodingFailed
    case offline
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse: "The server returned an invalid response."
        case .serverError(let code): "The server returned HTTP \(code)."
        case .decodingFailed: "The server response could not be decoded."
        case .offline: "No internet connection. Cached profiles are available."
        case .unknown(let error): error.localizedDescription
        }
    }
}

final class APIClient: NetworkClient {
    private let session: URLSession
    private let baseURL = URL(string: "https://randomuser.me/api/")!

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchProfiles(page: Int, results: Int = 10) async throws -> [Profile] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "results", value: "\(results)"),
            URLQueryItem(name: "seed", value: "matchmate")
        ]

        do {
            let (data, response) = try await session.data(from: components.url!)
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            guard 200..<300 ~= http.statusCode else {
                throw NetworkError.serverError(http.statusCode)
            }

            do {
                return try JSONDecoder.randomUserDecoder.decode(
                    RandomUserResponse.self,
                    from: data
                ).results
            } catch {
                throw NetworkError.decodingFailed
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
}

extension JSONDecoder {
    static var randomUserDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
