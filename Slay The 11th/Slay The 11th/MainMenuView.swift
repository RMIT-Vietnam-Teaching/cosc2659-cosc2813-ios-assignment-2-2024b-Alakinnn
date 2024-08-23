//
//  MainMenuView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 14/08/2024.
//

import SwiftUI

struct MainMenuView: View {
    @State private var selectedDifficulty: Difficulty = .medium
    @State private var isGameStarted = false
    var gameVm = GameViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                
              Spacer()

                Button("Play") {
                    gameVm.difficulty = selectedDifficulty
                    gameVm.stageViewModel = StageViewModel(difficulty: selectedDifficulty, player: Player(hp: 44))
                    isGameStarted = true
                }
                .font(.largeTitle)
                .padding()

              HStack {
                  DifficultyOptionButton(title: "Easy", difficulty: .easy, selectedDifficulty: $selectedDifficulty)
                  DifficultyOptionButton(title: "Medium", difficulty: .medium, selectedDifficulty: $selectedDifficulty)
                  DifficultyOptionButton(title: "Hard", difficulty: .hard, selectedDifficulty: $selectedDifficulty)
              }
              .padding()

                Spacer()
            }
            .navigationDestination(isPresented: $isGameStarted) {
                StageView(vm: gameVm, isGameStarted: $isGameStarted)
            }
        }
    }
}

struct DifficultyOptionButton: View {
    let title: String
    let difficulty: Difficulty
    @Binding var selectedDifficulty: Difficulty

    var body: some View {
        HStack {
            Circle()
                .fill(selectedDifficulty == difficulty ? Color.blue : Color.clear)
                .frame(width: 12, height: 24)
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 2)
                )

            Text(title)
                .font(.title2)
                .foregroundColor(.black)
        }
        .padding()
        .onTapGesture {
            selectedDifficulty = difficulty
        }
    }
}

#Preview {
    MainMenuView(gameVm: GameViewModel())
}


