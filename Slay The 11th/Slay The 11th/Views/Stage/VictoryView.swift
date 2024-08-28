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
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Victory?")
                .font(.custom("Kreon", size: 42))
                    .foregroundColor(.white)
                    .padding()
              
              Text("\(Int(gameVm.stageViewModel.score))")
              .font(.custom("Kreon", size: 20))
                  .foregroundColor(.white)
                  .padding()
              
                Text("The Spire is to no escape...")
                .font(.custom("Kreon", size: 32))
                    .foregroundColor(.white)
                    .padding()

                Button(action: {
                  gameVm.isGameStarted = false
                   gameVm.stageViewModel.allStagesCleared = false
                   gameVm.abandonRun()
                }) {
                    Text("Main Menu")
                    .font(.custom("Kreon", size: 22))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .changeEffect(
                .spray(origin: UnitPoint(x: 0.5, y: 0.5)) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.largeTitle)
                }, value: triggerSpray
            )
        }
        .onAppear {
            triggerSpray.toggle()
        }
        .navigationBarHidden(true)
        .navigationTransition(.fade(.out))
    }
}

#Preview {
  VictoryView(gameVm: GameViewModel())
}
