//
//  StatusView.swift
//  MatchMateDemo
//
//  Created by Sumeet Jagtap on 23/09/26.
//

import SwiftUI

struct StatusView: View {
    
    let title: String
    let background: Color
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                background
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 10)
            )
    }
}
