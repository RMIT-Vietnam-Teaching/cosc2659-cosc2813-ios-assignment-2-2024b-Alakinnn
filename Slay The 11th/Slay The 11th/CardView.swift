//
//  CardView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct CardView: View {
    let card: Card
    
    var body: some View {
      ZStack {
        Color("paperColor")
          .frame(width: 250, height: 300)
          .clipShape(.rect(cornerRadius: 12))
        
        VStack(alignment: .center) {
              Image(systemName: card.imageName)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 250, height: 100)
            
                  .padding(.vertical)
                  
              Text(card.name)
                  .font(.headline)
                  .padding(.top, 16)
              
              Text(card.description)
                  .font(.subheadline)
                  .multilineTextAlignment(.center)
                  .padding([.leading, .trailing, .bottom], 8)
                  .lineLimit(3)
              
            Text("Value: \(card.currentValue)")
                  .font(.caption)
                  .padding(.bottom, 8)
          }
          .frame(width: 250, height: 300)
          .background(
            Image("cardBackground")
              .resizable()
          )
          .cornerRadius(10)
          .shadow(radius: 5)
          .overlay(
              RoundedRectangle(cornerRadius: 10)
                  .stroke(Color.gray, lineWidth: 1)
          )
        .padding()
      }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleCard = Card(
            id: UUID(),
            name: "Attack",
            description: "Deal 10 damage to the enemy.",
            cardType: .attack,
            value: 10,
            imageName: "flame.fill" // Pass the image name here
        )
        
        CardView(card: exampleCard)
    }
}
