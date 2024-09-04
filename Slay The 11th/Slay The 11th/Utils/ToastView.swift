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

struct ToastView: View {
    var message: String

    var body: some View {
        VStack {
            Text(message)
                .padding()
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.top, 50)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}


#Preview {
  ToastView(message: "Test toast")
}
