//
//  ProfileDetailView.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import SwiftUI

struct ProfileDetailView: View {
    
    @EnvironmentObject private var store: MatchStore
    let profile: ProfileEntity
    
    var body: some View {
        Group {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    
                    // MARK: - Profile Header
                    
                    AsyncImage(url: profile.imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                            
                        case .failure:
                            Image(
                                systemName: "person.circle"
                            )
                            .resizable()
                            .scaledToFit()
                            .padding(50)
                            
                        case .empty:
                            ProgressView()
                            
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 240)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 22)
                    )
                    
                    // MARK: - Basic Information
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text(profile.displayName)
                            .font(.title.bold())
                            .foregroundStyle(.teal.opacity(0.9))
                        
                        Text(
                            "\(profile.gender.capitalized)"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        
                        Label(
                            "\(profile.city), \(profile.state), \(profile.country)",
                            systemImage: "location"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    
                    // MARK: - Personal
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        sectionTitle("Personal")
                        
                        HStack(spacing: 12) {
                            
                            InformationCard(
                                title: "Date of Birth",
                                value: formattedDate(profile.dob),
                                systemImage: "calendar"
                            )
                            
                            InformationCard(
                                title: "Nationality",
                                value: profile.nationality,
                                systemImage: "globe"
                            )
                        }
                    }
                    
                    // MARK: - Account
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        sectionTitle("Account")
                        
                        InformationCard(
                            title: "Registered",
                            value: formattedDate(profile.registered),
                            systemImage: "person.badge.clock"
                        )
                    }
                    
                    // MARK: - Contact
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        sectionTitle("Contact")
                        
                        InformationCard(
                            title: "Email",
                            value: profile.email,
                            systemImage: "envelope"
                        )
                        
                        InformationCard(
                            title: "Phone",
                            value: profile.phone,
                            systemImage: "phone"
                        )
                    }
                    
                    // MARK: - Action / Status
                    
                    actionSection(for: profile)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Section Title
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.title3.bold())
            .foregroundStyle(.primary)
    }
    
    // MARK: - Action Section
    
    @ViewBuilder
    private func actionSection(for profile: ProfileEntity) -> some View {
        
        if profile.status == .pending {
            VStack(spacing: 16) {
                
                Text("What would you like to do with this profile?")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 12) {
                    
                    DecisionButton(
                        title: "Decline",
                        systemImage: "xmark",
                        tint: .red.opacity(0.6)
                    ) {
                        store.updateStatus(.declined, for: profile)
                    }
                    
                    DecisionButton(
                        title: "Accept",
                        systemImage: "checkmark",
                        tint: .teal.opacity(0.9)
                    ) {
                        store.updateStatus(.accepted, for: profile)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.secondarySystemBackground))
            )
        } else if profile.status == .accepted {
            
            StatusView(title: profile.status.title, background: .teal.opacity(0.9))
        } else {
            StatusView(title: profile.status.title, background: .red.opacity(0.6))
        }
    }
    
    // MARK: - Date Formatting
    
    private func formattedDate(_ date: Date) -> String {
        date.formatted(
            .dateTime
                .day()
                .month(.abbreviated)
                .year()
        )
    }
}
