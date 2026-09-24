//
//  MatchStore.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import Foundation
import Combine
import Network
import SwiftData

@MainActor
final class MatchStore: ObservableObject {
    @Published private(set) var profiles: [ProfileEntity] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var hasLoadedInitialPage = false
    @Published var errorMessage: String?
    @Published private(set) var isOffline = false

    private let repository: ProfileRepository
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "MatchMate.NetworkMonitor")

    init(container: ModelContainer, network: NetworkClient = APIClient()) {
        repository = ProfileRepository(container: container, network: network)

        monitor.pathUpdateHandler = { [weak self] path in
            let offline = path.status != .satisfied
            Task { @MainActor [weak self] in
                self?.isOffline = offline
            }
        }
        monitor.start(queue: monitorQueue)

        loadCache()
    }

    deinit {
        monitor.cancel()
    }

    func loadCache() {
        do {
            profiles = try repository.cachedProfiles()
        } catch {
            errorMessage = "Could not load cached profiles: \(error.localizedDescription)"
        }
    }

    func loadInitialPage() async {
        guard !hasLoadedInitialPage else { return }
        isLoading = profiles.isEmpty

        do {
            _ = try await repository.fetchNextPage()
            loadCache()
            hasLoadedInitialPage = true
        } catch {
            errorMessage = error.localizedDescription
            hasLoadedInitialPage = true
        }

        isLoading = false
    }

    func loadMoreIfNeeded(current profile: ProfileEntity) async {
        guard profile.id == profiles.last?.id,
              !isLoadingMore,
              !isOffline else { return }

        isLoadingMore = true
        do {
            _ = try await repository.fetchNextPage()
            loadCache()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoadingMore = false
    }

    func updateStatus(_ status: MatchStatus, for profile: ProfileEntity) {
        do {
            try repository.updateStatus(profileID: profile.id, status: status)
            loadCache()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func retry() async {
        errorMessage = nil
        if profiles.isEmpty {
            hasLoadedInitialPage = false
        }
        await loadInitialPage()
    }
}
