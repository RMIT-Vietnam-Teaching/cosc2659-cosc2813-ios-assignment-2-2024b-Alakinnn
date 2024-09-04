/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 09/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

import SwiftUI

@main
struct Slay_The_11thApp: App {
  @State private var gameVm = GameViewModel()
  @State private var db = DatabaseManager.shared
  @State private var toast = ToastManager.shared
    var body: some Scene {
        WindowGroup {
            MainMenuView(gameVm: $gameVm)
              //.environment(gameVm)
              .environment(db)
              .environment(toast)
        }
    }
}
extension UserDefaults {
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
