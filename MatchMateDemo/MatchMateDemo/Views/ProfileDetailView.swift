//
//  ProfileDetailView.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import SwiftUI

struct ProfileDetailView: View {
    
    let profile: Profile
    
    var body: some View {
        Group {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    
                    // MARK: - Profile Header
                    
                    AsyncImage(url: profile.picture.large) { phase in
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
                        
                        Text(profile.name.first)
                            .font(.title.bold())
                            .foregroundStyle(.teal.opacity(0.9))
                        
                        Text(
                            "\(profile.gender.capitalized)"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        
                        Label(
                            "\(profile.location.city), \(profile.location.state), \(profile.location.country)",
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
                                value: formattedDate(profile.dob.date),
                                systemImage: "calendar"
                            )
                            
                            InformationCard(
                                title: "Nationality",
                                value: profile.nat,
                                systemImage: "globe"
                            )
                        }
                    }
                    
                    // MARK: - Account
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        sectionTitle("Account")
                        
                        InformationCard(
                            title: "Registered",
                            value: formattedDate(profile.registered.date),
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
    private func actionSection(for profile: Profile) -> some View {
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
                    print("Declined")
                }
                
                DecisionButton(
                    title: "Accept",
                    systemImage: "checkmark",
                    tint: .teal.opacity(0.9)
                ) {
                    print("Accepted")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
        )
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
