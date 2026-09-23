//
//  ActionButton.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import SwiftUI

struct ActionButton: View {
    let title: String
    let systemImage: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 56, height: 56)
                .foregroundStyle(tint)
                .background(
                    Circle()
                        .fill(Color(.systemBackground))
                )
                .overlay(
                    Circle()
                        .stroke(
                            tint,
                            lineWidth: 2
                        )
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}
