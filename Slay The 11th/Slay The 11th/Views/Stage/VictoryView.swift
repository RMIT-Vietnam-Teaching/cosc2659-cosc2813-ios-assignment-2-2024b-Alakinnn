//
//  VictoryView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 28/08/2024.
//

import SwiftUI
import Pow
import NavigationTransitions

struct VictoryView: View {
    @State private var triggerSpray = false
    var gameVm: GameViewModel
    
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
            triggerSpray.toggle()
            AudioManager.shared.queueSFX("victorySfx")
        }
        .navigationBarHidden(true)
        .navigationTransition(.fade(.out))
    }
}

#Preview {
    VictoryView(gameVm: GameViewModel())
}
