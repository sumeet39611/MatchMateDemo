//
//  MatchMateDemoTests.swift
//  MatchMateDemoTests
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import XCTest
import SwiftData
@testable import MatchMateDemo

final class MatchMateDemoTests: XCTestCase {
    
    @MainActor
    func testUpdateStatusPersists() async throws {
        let schema = Schema([ProfileEntity.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])

        let profile = Profile(
            gender: "male",
            name: APIName(title: "Mr", first: "Test", last: "User"),
            location: APILocation(city: "Pune", state: "Maharashtra", country: "India"),
            email: "test@example.com",
            login: APILogin(uuid: "stable-id"),
            dob: APIDateOfBirth(date: Date()),
            registered: APIDateOfBirth(date: Date()),
            phone: "123",
            cell: "456",
            picture: APIPicture(
                large: URL(string: "https://example.com/large.jpg")!,
                medium: URL(string: "https://example.com/medium.jpg")!
            ),
            nat: "IN"
        )

        let network = MockNetworkClient(pages: [[profile]])
        let repository = ProfileRepository(
            container: container,
            network: network
        )

        _ = try await repository.fetchNextPage()
        try repository.updateStatus(profileID: "stable-id", status: MatchStatus.accepted)

        let cached = try repository.cachedProfiles()
        XCTAssertEqual(cached.first?.status, .accepted)
    }

    @MainActor
    func testPaginationAdvancesPage() async throws {
        let schema = Schema([ProfileEntity.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])

        let first = makeProfile(id: "1", first: "First")
        let second = makeProfile(id: "2", first: "Second")
        let network = MockNetworkClient(pages: [[first], [second]])

        let repository = ProfileRepository(
            container: container,
            network: network
        )

        _ = try await repository.fetchNextPage()
        _ = try await repository.fetchNextPage()

        let cached = try repository.cachedProfiles()
        XCTAssertEqual(cached.count, 2)
        XCTAssertEqual(cached.map(\.page), [1, 2])
        XCTAssertEqual(network.requestedPages, [1, 2])
    }

    private func makeProfile(id: String, first: String) -> Profile {
        Profile(
            gender: "male",
            name: APIName(title: "Mr", first: first, last: "User"),
            location: APILocation(city: "Pune", state: "Maharashtra", country: "India"),
            email: "\(id)@example.com",
            login: APILogin(uuid: id),
            dob: APIDateOfBirth(date: Date()),
            registered: APIDateOfBirth(date: Date()),
            phone: "123",
            cell: "456",
            picture: APIPicture(
                large: URL(string: "https://example.com/large.jpg")!,
                medium: URL(string: "https://example.com/medium.jpg")!
            ),
            nat: "IN"
        )
    }
}

final class MockNetworkClient: NetworkClient {
    let pages: [[Profile]]
    private(set) var requestedPages: [Int] = []

    init(pages: [[Profile]]) {
        self.pages = pages
    }

    func fetchProfiles(page: Int, results: Int) async throws -> [Profile] {
        requestedPages.append(page)
        return pages[page - 1]
    }
}
