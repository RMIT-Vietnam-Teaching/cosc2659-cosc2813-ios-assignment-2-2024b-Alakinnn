//
//  Slay_The_11thApp.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 09/08/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Slay_The_11thApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @State private var gameVm = GameViewModel()
  @State private var db = FirebaseManager()

    var body: some Scene {
        WindowGroup {
            MainMenuView()
              .environment(gameVm)
              .environment(db)
        }
    }
}
