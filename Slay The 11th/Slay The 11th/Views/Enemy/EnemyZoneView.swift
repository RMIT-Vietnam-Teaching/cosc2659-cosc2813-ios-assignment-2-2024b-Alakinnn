/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 10/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

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


