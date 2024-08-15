//
//  EnemyZoneView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct EnemyZoneView: View {
    var vm: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            let offsetValue = geometry.size.width * 0.02
            let enemyWidth = geometry.size.width * 0.3
            let enemyHeight = geometry.size.height * 0.5
            
            VStack {
                HStack(spacing: 12) {
                    ForEach(vm.stageViewModel.enemies.indices, id: \.self) { index in
                        CharacterBody2D(
                            offsetValue: offsetValue,
                            width: enemyWidth,
                            height: enemyHeight,
                            vm: vm,
                            index: index // Pass the index here
                        )
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.blue)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
}

#Preview {
    EnemyZoneView(vm: GameViewModel())
}


