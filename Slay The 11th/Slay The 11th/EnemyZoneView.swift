//
//  EnemyZoneView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct EnemyZoneView: View {
    var body: some View {
        GeometryReader { geometry in
            let offsetValue = geometry.size.width * 0.02 // Adjust offset relative to screen width
            let enemyWidth = geometry.size.width * 0.3
          let enemyHeight = geometry.size.width * 0.5
            
            VStack {
                HStack(spacing: 12) {
                  EnemyBody2D(offsetValue: -offsetValue, width: enemyWidth, height: enemyHeight)
                  EnemyBody2D(offsetValue: offsetValue, width: enemyWidth, height: enemyHeight) 
                  EnemyBody2D(offsetValue: -offsetValue, width: enemyWidth, height: enemyHeight)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 0.55) // Adjust height as needed
            .background(Color.blue)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5) // Shadow at the bottom
        }
    }
}

#Preview {
    EnemyZoneView()
}
