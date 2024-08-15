//
//  MainGameView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct StageView: View {
    private var vm = GameViewModel()

    var body: some View {
        VStack(spacing: 0) {
          EnemyZoneView(vm: vm)
            .frame(height: UIScreen.main.bounds.height * 0.45)
            
            Spacer(minLength: 10)
            
          PlayerHandView(vm: vm)
                .frame(height: UIScreen.main.bounds.height * 0.35)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
  StageView()
}

