//
//  EnemyZoneView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct EnemyZoneView: View {
    var vm: StageViewModel

    var body: some View {
        GeometryReader { geometry in
            let offsetValue = geometry.size.width * 0.02
            let enemyWidth = geometry.size.width * 0.3
            let enemyHeight = geometry.size.height * 0.35
            
            VStack {
                HStack(spacing: 12) {
                    ForEach(vm.enemies.indices, id: \.self) { index in
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
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
}

#Preview {
    EnemyZoneView(vm: StageViewModel(difficulty: .medium, player: Player(hp: 44), mode: .regular))
}


