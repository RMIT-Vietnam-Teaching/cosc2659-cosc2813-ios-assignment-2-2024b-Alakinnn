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
            .font(.kreonHeadline)
                .padding()
                .foregroundColor(.black)

            HStack(spacing: 15) {
                ForEach(rewards, id: \.name) { reward in
                    RewardBoxView(reward: reward)
                                                .background(
                            selectedReward?.name == reward.name ? Color.yellow.opacity(0.3) : Color.clear
                        )
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedReward = reward
                        }
                }
            }
            .padding(.leading, 8)
            Spacer()
            Button("Confirm", action: onConfirm)
            .font(.kreonBody)
                .disabled(selectedReward == nil)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 20)
          Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white) 
        .navigationBarHidden(true)
    }
}

#Preview {
  RewardSelectionView(
      rewards: [
          Reward(type: .heal(percentage: 35), name: "Heal", description: "Heals 35% max HP", iconName: "heart.fill"),
          Reward(type: .attackBuff(value: 2), name: "Attack Buff", description: "Increase attack by 2", iconName: "flame.fill")
      ],
      selectedReward: .constant(nil), // or you can pass a specific reward for testing selection
      onConfirm: {
          print("Reward Confirmed")
      }
  )
}

