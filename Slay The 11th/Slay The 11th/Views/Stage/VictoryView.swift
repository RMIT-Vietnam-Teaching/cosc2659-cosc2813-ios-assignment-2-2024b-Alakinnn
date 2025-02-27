/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 28/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/


import SwiftUI
import Pow
import NavigationTransitions

struct VictoryView: View {
    @State private var triggerSpray = false
    var gameVm: GameViewModel
    var db: DatabaseManager = DatabaseManager.shared
    
    var body: some View {
        ZStack {
            Image("victoryBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(NSLocalizedString("victory_title", comment: "Victory title"))
                    .font(.kreonTitle)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .padding(.vertical, 12)
                    .background(Image("textBoxBackground").resizable().scaledToFill())
                    .padding()
                
                Text("\(Int(gameVm.stageViewModel.score))")
                    .font(.kreonBody)
                    .foregroundColor(.yellow)
                    .padding()
                
                Text(NSLocalizedString("victory_subtitle", comment: "Victory subtitle"))
                    .font(.kreonBody)
                    .foregroundColor(.red)
                    .padding()
                
                Button(action: {
                    AudioManager.shared.playImmediateSFX("sfxButton")
                    gameVm.isGameStarted = false
                    gameVm.stageViewModel.allStagesCleared = false
                    gameVm.abandonRun()
                    AudioManager.shared.stopBackgroundMusic()
                    AudioManager.shared.playBackgroundMusic("mainMenu")
                }) {
                    Text(NSLocalizedString("main_menu", comment: "Button to return to the main menu"))
                        .font(.custom("Kreon", size: 22))
                        .padding()
                        .background(Image("bigBtnBackground").resizable())
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .changeEffect(
                .spray(origin: UnitPoint(x: 0.5, y: 0)) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.kreonTitle)
                }, value: triggerSpray
            )
        }
        .onAppear {
          AudioManager.shared.clearSFXQueue()
            triggerSpray.toggle()
            AudioManager.shared.queueSFX("victorySfx")
          gameVm.checkAndUnlockAchievements(db: db, action: .clearGame)
          gameVm.checkAndUnlockAchievements(db: db, action: .clearGameOnDifficulty(gameVm.difficulty))
        }
        .navigationBarHidden(true)
        .navigationTransition(.fade(.out))
    }
}

#Preview {
    VictoryView(gameVm: GameViewModel())
}
