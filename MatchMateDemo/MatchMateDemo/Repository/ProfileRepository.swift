//
//  ProfileRepository.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import Foundation
import SwiftData

protocol ProfileRepositoryProtocol {
    func cachedProfiles() throws -> [ProfileEntity]
    func fetchNextPage() async throws -> [ProfileEntity]
    func updateStatus(profileID: String, status: MatchStatus) throws
}

@MainActor
final class ProfileRepository: ProfileRepositoryProtocol {
    private let context: ModelContext
    private let network: NetworkClient
    private(set) var nextPage: Int

    init(
        container: ModelContainer,
        network: NetworkClient,
        nextPage: Int = 1
    ) {
        self.context = ModelContext(container)
        self.network = network
        self.nextPage = nextPage
    }

    func cachedProfiles() throws -> [ProfileEntity] {
        let descriptor = FetchDescriptor<ProfileEntity>(
            sortBy: [SortDescriptor(\.page), SortDescriptor(\.firstName)]
        )
        return try context.fetch(descriptor)
    }

    func fetchNextPage() async throws -> [ProfileEntity] {
        let page = nextPage
        let apiProfiles = try await network.fetchProfiles(page: page, results: 10)

        var entities: [ProfileEntity] = []
        for profile in apiProfiles {
            if let existing = try find(id: profile.id) {
                existing.gender = profile.gender
                existing.title = profile.name.title
                existing.firstName = profile.name.first
                existing.lastName = profile.name.last
                existing.city = profile.location.city
                existing.state = profile.location.state
                existing.country = profile.location.country
                existing.email = profile.email
                existing.phone = profile.phone
                existing.cell = profile.cell
                existing.nationality = profile.nat
                existing.dob = profile.dob.date
                existing.registered = profile.registered.date
                existing.largeImageURL = profile.picture.large.absoluteString
                existing.mediumImageURL = profile.picture.medium.absoluteString
                existing.page = page
                entities.append(existing)
            } else {
                let entity = ProfileEntity(profile: profile, page: page)
                context.insert(entity)
                entities.append(entity)
            }
        }

        try context.save()
        nextPage += 1
        return entities
    }

    func updateStatus(profileID: String, status: MatchStatus) throws {
        guard let profile = try find(id: profileID) else {
            throw RepositoryError.profileNotFound
        }
        profile.status = status
        try context.save()
    }

    private func find(id: String) throws -> ProfileEntity? {
        var descriptor = FetchDescriptor<ProfileEntity>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }
}

enum RepositoryError: LocalizedError {
    case profileNotFound
    var errorDescription: String? {
        switch self {
        case .profileNotFound: "The profile could not be found."
        }
    }
}
