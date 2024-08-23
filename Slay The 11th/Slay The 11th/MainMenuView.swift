//
//  MainMenuView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 14/08/2024.
//

import SwiftUI
import NavigationTransitions

struct MainMenuView: View {
  @State private var selectedDifficulty: Difficulty = .medium
  @State private var blackoutOpacity: Double = 0.0
  @Bindable var gameVm = GameViewModel()

  var body: some View {
      NavigationStack {
          ZStack {
              VStack {
                  Spacer()

                  if gameVm.hasSavedRun {
                      Button("Continue Run") {
                          withAnimation(.easeInOut(duration: 1.0)) {
                              blackoutOpacity = 1.0
                          }
                          
                          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                              gameVm.isGameStarted = true
                              withAnimation(.easeInOut(duration: 1.0)) {
                                  blackoutOpacity = 0.0
                              }
                          }
                      }
                      .font(.largeTitle)
                      .padding()

                      Button("Abandon Run") {
                          gameVm.abandonRun()
                      }
                      .font(.title2)
                      .padding()
                  } else {
                      Button("Start New Run") {
                          gameVm.difficulty = selectedDifficulty
                          gameVm.stageViewModel = StageViewModel(difficulty: selectedDifficulty, player: Player(hp: 44))

                          withAnimation(.easeInOut(duration: 1.0)) {
                              blackoutOpacity = 1.0
                          }

                          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                              gameVm.isGameStarted = true
                              withAnimation(.easeInOut(duration: 1.0)) {
                                  blackoutOpacity = 0.0
                              }
                          }
                      }
                      .font(.largeTitle)
                      .padding()

                      HStack {
                          DifficultyOptionButton(title: "Easy", difficulty: .easy, selectedDifficulty: $selectedDifficulty)
                          DifficultyOptionButton(title: "Medium", difficulty: .medium, selectedDifficulty: $selectedDifficulty)
                          DifficultyOptionButton(title: "Hard", difficulty: .hard, selectedDifficulty: $selectedDifficulty)
                      }
                      .padding()
                  }

                  Spacer()
              }

              // Blackout overlay
              Color.black
                  .opacity(blackoutOpacity)
                  .edgesIgnoringSafeArea(.all)
          }
          .navigationDestination(isPresented: $gameVm.isGameStarted) {
              StageView(vm: gameVm)
          }
          .navigationTransition(.fade(.in))
      }
      .navigationBarHidden(true)
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


