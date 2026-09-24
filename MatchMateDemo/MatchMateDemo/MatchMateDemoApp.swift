//
//  MatchMateDemoApp.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import SwiftUI
import SwiftData

@main
struct MatchMateDemoApp: App {
    
    private let container: ModelContainer
    @StateObject private var store: MatchStore
    
    init() {
        do {
            let schema = Schema([ProfileEntity.self])
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [configuration])
            self.container = container
            _store = StateObject(wrappedValue: MatchStore(container: container))
        } catch {
            fatalError("Unable to create SwiftData container: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ProfileListView()
                .environmentObject(store)
        }
        .modelContainer(container)
    }
}
