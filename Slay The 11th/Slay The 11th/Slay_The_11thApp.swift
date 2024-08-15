//
//  Slay_The_11thApp.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 09/08/2024.
//

import SwiftUI

@main
struct Slay_The_11thApp: App {
  @State private var gameVm = GameViewModel()
    var body: some Scene {
        WindowGroup {
            StageView()
              .environment(gameVm)
        }
    }
}
