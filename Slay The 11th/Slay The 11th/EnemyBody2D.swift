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
    var viewModel: StageViewModel

    var body: some View {
        ZStack {
            
          Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .offset(y: offsetValue)
          
          Rectangle()
              .fill(Color.black.opacity(0.001))
              .frame(width: width * 0.8, height: height * 0.6)
              .border(Color.red, width: 2)
              .offset(y: offsetValue)
              .onTapGesture {
                  viewModel.applyCardToEnemy()
              }
        }
    }
}

#Preview {
    EnemyBody2D(offsetValue: 0, width: 100, height: 200, viewModel: StageViewModel())
}



