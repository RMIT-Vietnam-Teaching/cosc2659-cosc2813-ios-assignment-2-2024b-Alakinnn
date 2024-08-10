//
//  EnemyBody2D.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct EnemyBody2D: View {
  let offsetValue: CGFloat
  let width: CGFloat
  let height: CGFloat
    
  var body: some View {
        ZStack { // Use ZStack to layer the rectangle over the image
            Image(systemName: "person.fill") // Placeholder image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .offset(y: offsetValue)
            
            Rectangle()
                .fill(Color.clear) // Transparent rectangle
                .frame(width: width * 0.8, height: height * 0.6) // Adjust size as needed
                .border(Color.red, width: 2) // Optional: visible border to see the hitbox
                .offset(y: offsetValue)
                .onDrop(of: [.text], isTargeted: nil) { items in
                    // Handle the drop action here
                    print("Item dropped on enemy")
                    return true
                }
        }
    }
}

