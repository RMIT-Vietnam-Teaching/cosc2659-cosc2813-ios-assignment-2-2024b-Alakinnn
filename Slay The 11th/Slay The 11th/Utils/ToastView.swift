//
//  ToastView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 29/08/2024.
//

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
