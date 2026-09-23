//
//  ProfileCard.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import SwiftUI

struct ProfileCard: View {
    let profile: Profile
    let onAccept: () -> Void
    let onDecline: () -> Void
    
    var body: some View {
        VStack {
            AsyncImage(url: profile.picture.large) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Image(systemName: "person.circle")
                        .resizable().scaledToFit().padding(30)
                default:
                    ProgressView()
                }
            }
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text(profile.name.first)
                .font(.title2.bold())
                .foregroundStyle(.teal.opacity(0.9))
            
            Text("\(profile.location.city), \(profile.location.state), \(profile.location.country)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                Spacer()
                
                ActionButton(
                    title: "Decline",
                    systemImage: "xmark",
                    tint: .red.opacity(0.6),
                    action: onDecline
                )
                
                Spacer()
                
                ActionButton(
                    title: "Accept",
                    systemImage: "checkmark",
                    tint: .teal.opacity(0.9),
                    action: onAccept
                )
                
                Spacer()
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .shadow(
            color: Color.black.opacity(0.10),
            radius: 10,
            x: 0,
            y: 5
        )
        .padding(.horizontal, 8)
    }
}
