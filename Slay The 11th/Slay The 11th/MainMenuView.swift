//
//  MainMenuView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 14/08/2024.
//

import SwiftUI

struct MainMenuView: View {
    @State private var isSelectingDifficulty = false
    @State private var selectedDifficulty: Difficulty = .medium
    @State private var isGameStarted = false
    var gameVm = GameViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Button("Play") {
                    isSelectingDifficulty = true
                }
                .font(.largeTitle)
                .padding()

                Spacer()

                NavigationLink("", value: isGameStarted)
                    .hidden()
            }
            .sheet(isPresented: $isSelectingDifficulty) {
                DifficultySelectionView(
                    selectedDifficulty: $selectedDifficulty,
                    isGameStarted: $isGameStarted
                )
                .onDisappear {
                    gameVm.difficulty = selectedDifficulty
                    gameVm.stageViewModel = StageViewModel(difficulty: selectedDifficulty, player: gameVm.player)
                }
            }
            .navigationDestination(isPresented: $isGameStarted) {
                StageView(vm: gameVm)
            }
        }
    }
}

#Preview {
  MainMenuView(gameVm: GameViewModel())
}


struct DifficultySelectionView: View {
    @Binding var selectedDifficulty: Difficulty
    @Binding var isGameStarted: Bool

    var body: some View {
        VStack {
            Text("Select Difficulty")
                .font(.largeTitle)
                .padding()

            Picker("Difficulty", selection: $selectedDifficulty) {
                Text("Easy").tag(Difficulty.easy)
                Text("Medium").tag(Difficulty.medium)
                Text("Hard").tag(Difficulty.hard)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button("Confirm") {
                isGameStarted = true
            }
            .font(.title)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}


