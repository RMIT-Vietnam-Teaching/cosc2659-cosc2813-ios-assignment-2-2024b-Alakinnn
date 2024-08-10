//
//  MainGameView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct MainGameView: View {
    var body: some View {
        VStack(spacing: 0) { // No spacing to avoid gaps between the views
            EnemyZoneView()
                .frame(height: UIScreen.main.bounds.height * 0.55) // Fixed height proportion for EnemyZoneView
            
            Spacer(minLength: 10) // Space between the two views
            
            PlayerHandView()
                .frame(height: UIScreen.main.bounds.height * 0.35) // Fixed height proportion for PlayerHandView
        }
        .edgesIgnoringSafeArea(.all) // Make sure views can extend to the edges of the screen
    }
}


#Preview {
    MainGameView()
}
