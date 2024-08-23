//
//  StageHeaderView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 23/08/2024.
//

import SwiftUI

struct StageHeaderView: View {
    @Bindable var vm: GameViewModel
    @Binding var isPaused: Bool
    @Binding var showMenuSheet: Bool

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    showMenuSheet.toggle()
                }) {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
                .frame(width: 35, height: 35)

                Spacer()

                Text("Stage \(vm.stageViewModel.currentStage)")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 6)
            .frame(height: 60)
            .background(Color.black.opacity(0.7))

            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $showMenuSheet) {
          MenuSheetView(isPaused: $isPaused, vm: vm, showMenuSheet: $showMenuSheet)
        }
    }
}

struct MenuSheetView: View, Observable {
    @Binding var isPaused: Bool
  var vm: GameViewModel
    @Binding var showMenuSheet: Bool

    var body: some View {
        VStack(spacing: 0) {
            Button("Pause") {
                isPaused = true
                showMenuSheet = false
            }
            .font(.title2)
            .padding()

            Divider()

            Button("Return to Main Menu") {
              vm.isGameStarted = false
                showMenuSheet = false
            }
            .font(.title2)
            .padding()

            Divider()

            Button("Cancel") {
                showMenuSheet = false
            }
            .font(.title2)
            .padding()
        }
        .padding()
        .cornerRadius(16)
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .shadow(radius: 10)
    }
}


#Preview {
  StageHeaderView(vm: GameViewModel(), isPaused: .constant(false), showMenuSheet: .constant(false))
}
