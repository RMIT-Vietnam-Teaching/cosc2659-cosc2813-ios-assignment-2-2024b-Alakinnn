//
//  TooltipView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 29/08/2024.
//

import SwiftUI

struct TooltipView: View {
    var score: PlayerScore

    var body: some View {
        VStack {
            Text(score.name)
                .font(.caption)
                .foregroundColor(.white)
            Text("Stage: \(score.stagesFinished)")
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding(5)
        .background(Color.black.opacity(0.7))
        .cornerRadius(5)
    }
}

//
//#Preview {
//    TooltipView(score: 11)
//}
