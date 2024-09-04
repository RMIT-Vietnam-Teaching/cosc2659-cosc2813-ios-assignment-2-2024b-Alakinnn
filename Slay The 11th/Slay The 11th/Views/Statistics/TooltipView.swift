/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 29/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

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
