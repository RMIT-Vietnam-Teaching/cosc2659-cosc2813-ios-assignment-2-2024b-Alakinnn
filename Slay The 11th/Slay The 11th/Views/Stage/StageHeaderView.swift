//
//  StageHeaderView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 23/08/2024.
//

import SwiftUI

struct StageHeaderView: View {
    @Bindable var vm: StageViewModel
  var gameVm: GameViewModel
    @Binding var isPaused: Bool
    @Binding var showMenuSheet: Bool
  var db: DatabaseManager

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    showMenuSheet.toggle()
                }) {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
                .frame(width: 35, height: 35)

                Spacer()

                Text("Stage \(vm.currentStage)")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 6)
            .frame(height: 60)
            .background(Color.black.opacity(0.7))

            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $showMenuSheet) {
          MenuSheetView(isPaused: $isPaused, vm: gameVm, db: db, showMenuSheet: $showMenuSheet)
        }
    }
}

struct MenuSheetView: View, Observable {
  @Binding var isPaused: Bool
  var vm: GameViewModel
  var db: DatabaseManager
  @Binding var showMenuSheet: Bool

  var body: some View {
    VStack(spacing: 0) {
        Button("Save and Quit") {
            vm.saveGame()
            vm.isGameStarted = false
            showMenuSheet = false
          print(vm.stageViewModel.score)
            // Stop the stage music and play the main menu music
            AudioManager.shared.stopBackgroundMusic()
            AudioManager.shared.playBackgroundMusic("mainMenu")
        }
        .font(.title2)
        .padding()

        Divider()

        Button("Abandon Run") {
            vm.abandonRun()
            vm.isGameStarted = false
            showMenuSheet = false
          vm.stageViewModel.updatePlayerScore(db: db)
            // Stop the stage music and play the main menu music
            AudioManager.shared.stopBackgroundMusic()
            AudioManager.shared.playBackgroundMusic("mainMenu")
        }
        .font(.title2)
        .padding()

        Divider()

        Button("Cancel") {
            showMenuSheet = false
        }
        .font(.title2)
        .padding()
    }
    .padding()
    .cornerRadius(16)
    .frame(maxWidth: .infinity)
    .frame(height: 200)
    .shadow(radius: 10)
  }
}



#Preview {
  StageHeaderView(vm: StageViewModel(difficulty: .medium, player: Player(hp: 44)) ,gameVm: GameViewModel(), isPaused: .constant(false), showMenuSheet: .constant(false), db: MockDataManager())
}
