//
//  MainGameView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct MainGameView: View {
    private var viewModel = StageViewModel()

    var body: some View {
        VStack(spacing: 0) {
            EnemyZoneView(viewModel: viewModel)
                .frame(height: UIScreen.main.bounds.height * 0.55)
            
            Spacer(minLength: 10)
            
            PlayerHandView(viewModel: viewModel)
                .frame(height: UIScreen.main.bounds.height * 0.35)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    MainGameView()
}

