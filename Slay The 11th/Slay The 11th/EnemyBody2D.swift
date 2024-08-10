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
      VStack {
          Text("Enemy")
      }
      .frame(width: width, height: height)
      .background(Color.red)
      .offset(y: offsetValue)
      .padding(.top, 20) 
  }
}

