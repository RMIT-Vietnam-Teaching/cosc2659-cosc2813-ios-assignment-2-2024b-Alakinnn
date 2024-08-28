//
//  VictoryView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 28/08/2024.
//

import SwiftUI
import Pow

struct VictoryView: View {
    @State private var triggerSpray = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Victory?")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                Text("The Spire is to no escape...")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()

                Button(action: {
                }) {
                    Text("Main Menu")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .changeEffect(
                .spray(origin: UnitPoint(x: 0.5, y: 0.5)) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.largeTitle)
                }, value: triggerSpray
            )
        }
        .onAppear {
            triggerSpray.toggle()
        }
    }
}

#Preview {
    VictoryView()
}
