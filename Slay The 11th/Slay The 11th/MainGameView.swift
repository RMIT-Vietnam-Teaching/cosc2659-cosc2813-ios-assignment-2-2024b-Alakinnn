//
//  MainGameView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct MainGameView: View {
    var body: some View {
        VStack(spacing: 0) {
            EnemyZoneView()
                .frame(height: UIScreen.main.bounds.height * 0.55)
            
            Spacer(minLength: 10)
            
            PlayerHandView()
                .frame(height: UIScreen.main.bounds.height * 0.35)
        }
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    MainGameView()
}
