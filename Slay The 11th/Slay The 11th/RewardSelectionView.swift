//
//  RewardSelectionView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 20/08/2024.
//

import SwiftUI

struct RewardSelectionView: View {
    let rewards: [Reward]
    @Binding var selectedReward: Reward?
    var onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 5) {
          Spacer(minLength: 20)
          
            Text("Choose Your Reward")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.black)

            Spacer()

            HStack(spacing: 5) {
                ForEach(rewards, id: \.name) { reward in
                    RewardBoxView(reward: reward)
                        .padding()
                        .background(
                            selectedReward?.name == reward.name ? Color.yellow.opacity(0.3) : Color.clear
                        )
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedReward = reward
                        }
                }
            }
            .padding()

            Spacer()

            Button("Confirm", action: onConfirm)
                .disabled(selectedReward == nil)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white) 
    }
}


