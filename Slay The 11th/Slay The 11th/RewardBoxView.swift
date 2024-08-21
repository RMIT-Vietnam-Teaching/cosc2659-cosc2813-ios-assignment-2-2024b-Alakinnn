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
                .font(.headline)
            Text(reward.description)
                .font(.subheadline)
            Image(systemName: reward.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
        }
      
        .padding()
        .frame(width: 170)
        .background(Color.gray.opacity(0.2))
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 5)
    }
}

#Preview {
  RewardBoxView(reward: Reward(type: .heal(percentage: 35), name: "Heal", description: "Heals 35% max HP", iconName: "heart.fill"))
}

