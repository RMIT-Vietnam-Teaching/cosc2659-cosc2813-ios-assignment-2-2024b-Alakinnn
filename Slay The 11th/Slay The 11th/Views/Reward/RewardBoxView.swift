//
//  RewardBoxView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 20/08/2024.
//

import SwiftUI

struct RewardBoxView: View {
    let reward: Reward

    var body: some View {
        VStack {
            Text(reward.name)
            .font(.kreonHeadline)
            .foregroundStyle(.red)
          
          Text(reward.description).font(.kreonSubheadline)
            .foregroundStyle(
                reward.type == .heal(percentage: 35) ? .pink :
                  (reward.type == .attackBuff(value: 2) ? .red :
                  (reward.type == .shieldBuff(value: 2) || reward.type == .shieldBuff(value: 3) ? .blue : .yellow))
            )

            Image(systemName: reward.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundStyle(
                    reward.type == .heal(percentage: 35) ? .pink :
                      (reward.type == .attackBuff(value: 2) ? .red :
                      (reward.type == .shieldBuff(value: 2) || reward.type == .shieldBuff(value: 3) ? .blue : .yellow))
                )
            
        }
      
        .padding()
        .frame(width: 170)
        .background(Color.gray.opacity(0.2))
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 5)
    }
}

#Preview {
  RewardBoxView(reward: Reward(type: .heal(percentage: 35), name: "Heal", description: "Heals 35%", iconName: "heart.fill"))
}

