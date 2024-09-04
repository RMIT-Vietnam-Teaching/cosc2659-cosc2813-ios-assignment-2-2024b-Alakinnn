/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 10/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

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
                  .foregroundColor(.black)
                  .padding(.vertical)
                  
              Text(card.name)
                  .font(.custom("Kreon", size: 24))
                  .padding(.top, 16)
                  .foregroundColor(Color(.black))
              Text(card.description)
                  .font(.custom("Kreon", size: 14))
                  .fontWeight(.medium)
                  .foregroundColor(Color(.black))
                  .multilineTextAlignment(.center)
                  .padding([.leading, .trailing, .bottom], 8)
                  .lineLimit(3)
              
            Text("Value: \(card.currentValue)")
                  .font(.custom("Kreon", size: 14))
                  .fontWeight(.light)
                  .padding(.bottom, 8)
                  .foregroundColor(Color(.black))
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
