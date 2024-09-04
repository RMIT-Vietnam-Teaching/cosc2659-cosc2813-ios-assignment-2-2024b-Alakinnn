/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 20/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

import SwiftUI
import Pow

struct RewardSelectionView: View {
    let rewards: [Reward]
    @Binding var selectedReward: Reward?
    var onConfirm: () -> Void
    @State var selectedRewardBool: Bool = false

    var body: some View {
        VStack(spacing: 5) {
            Spacer(minLength: 20)
            
            Text(NSLocalizedString("choose_your_reward", comment: "Prompt to choose a reward"))
                .font(.kreonHeadline)
                .padding()
                .foregroundColor(.yellow)

            HStack(spacing: 15) {
                ForEach(rewards, id: \.name) { reward in
                    RewardBoxView(reward: reward)
                        .background(
                            selectedReward?.name == reward.name ? Color.yellow.opacity(0.3) : Color.clear
                        )
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedReward = reward
                            selectedRewardBool = true
                        }
                        .conditionalEffect(
                            .repeat(
                                .glow(color: .yellow, radius: 50),
                                every: 1.5
                            ),
                            condition: selectedReward?.name == reward.name
                        )

                }
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Button(NSLocalizedString("confirm", comment: "Button to confirm the selected reward"), action: onConfirm)
                .font(.kreonBody)
                .disabled(selectedReward == nil)
                .padding()
                .foregroundColor(.black)
                .cornerRadius(10)
                .padding(.bottom, 20)
                .background(Image("smallBtnBackground").resizable())
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationBarHidden(true)
    }
}

#Preview {
    RewardSelectionView(
        rewards: [
            Reward(type: .heal(percentage: 35), name: "Heal", description: "Heals 35% max HP", iconName: "heart.fill"),
            Reward(type: .shieldBuff(value: 2), name: "Attack Buff", description: "Increase attack by 2", iconName: "flame.fill")
        ],
        selectedReward: .constant(nil), // or you can pass a specific reward for testing selection
        onConfirm: {
            print("Reward Confirmed")
        }
    )
}
