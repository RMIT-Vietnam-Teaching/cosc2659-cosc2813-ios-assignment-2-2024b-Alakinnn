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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
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

                Text(String(format: NSLocalizedString("stage_label", comment: "Stage label with number"), vm.currentStage))
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, horizontalSizeClass == .compact ? 6 : 24)
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
            if vm.mode == .regular {
                Button(NSLocalizedString("save_and_quit", comment: "Save and Quit button text")) {
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
            }

            Button(NSLocalizedString("abandon_run", comment: "Abandon Run button text")) {
                vm.abandonRun()
                if vm.mode == .regular {
                    vm.isGameStarted = false
                } else {
                    vm.isTutorial = false
                  vm.mode = .regular
                }
                showMenuSheet = false
                vm.stageViewModel.updatePlayerScore(db: db)
                // Stop the stage music and play the main menu music
                AudioManager.shared.stopBackgroundMusic()
                AudioManager.shared.playBackgroundMusic("mainMenu")
            }
            .font(.title2)
            .padding()

            Divider()

            Button(NSLocalizedString("cancel", comment: "Cancel button text")) {
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
    StageHeaderView(vm: StageViewModel(difficulty: .medium, player: Player(hp: 44), mode: .regular), gameVm: GameViewModel(), isPaused: .constant(false), showMenuSheet: .constant(false), db: MockDataManager())
}
