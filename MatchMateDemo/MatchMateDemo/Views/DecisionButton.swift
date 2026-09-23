//
//  DecisionButton.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import SwiftUI

struct DecisionButton: View {
    
    let title: String
    let systemImage: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {

                Image(systemName: systemImage)
                    .font(.system(size: 24, weight: .semibold))
                    .frame(width: 42, height: 42)
                    .foregroundStyle(tint)
                    .background(
                        Circle()
                            .fill(tint.opacity(0.10))
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                tint.opacity(0.7),
                                lineWidth: 2
                            )
                    )

                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(tint.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        tint.opacity(0.15),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
