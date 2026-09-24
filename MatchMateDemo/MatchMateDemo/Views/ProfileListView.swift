//
//  ProfileListView.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import SwiftUI

struct ProfileListView: View {
    @EnvironmentObject private var store: MatchStore
    @State private var selectedProfileID: String?
    
    var body: some View {
        NavigationStack {
            Group {
                if store.isLoading {
                    ProgressView("Loading profiles…")
                } else if store.profiles.isEmpty {
                    ContentUnavailableView(
                        "No Profiles",
                        systemImage: "person.2.slash",
                        description: Text("Pull the connection back or retry when online.")
                    )
                } else {
                    List {
//                        if store.isOffline {
//                            Label("Offline — showing cached profiles. Decisions still work.", systemImage: "wifi.slash")
//                                .font(.footnote)
//                                .padding()
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .background(.yellow.opacity(0.18))
//                                .listRowInsets(EdgeInsets())
//                        }
                        
                        ForEach(store.profiles, id: \.id) { profile in
                            
                            ProfileCard(
                                profile: profile,
                                onAccept: {
                                    store.updateStatus(.accepted, for: profile)
                                },
                                onDecline: {
                                    store.updateStatus(.declined, for: profile)
                                }
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedProfileID = profile.id
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .onAppear {
                                Task {
                                    await store.loadMoreIfNeeded(current: profile)
                                }
                            }
                        }
                        if store.isLoadingMore {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemGroupedBackground))
                    .navigationTitle("Profile Matches")
                }
            }
            .navigationDestination(item: $selectedProfileID) { profileID in
                if let profile = store.profiles.first(where: {
                    $0.id == profileID
                }) {
                    ProfileDetailView(profile: profile)
                }
            }
            .task {
                await store.loadInitialPage()
            }
            .refreshable {
                await store.retry()
            }
            .alert(
                "Something went wrong",
                isPresented: Binding(
                    get: { store.errorMessage != nil },
                    set: { if !$0 { store.errorMessage = nil } }
                )
            ) {
                Button("OK") { store.errorMessage = nil }
            } message: {
                Text(store.errorMessage ?? "")
            }
        }
    }
}
