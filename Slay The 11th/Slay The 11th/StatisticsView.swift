//
//  StatisticsView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 29/08/2024.
//

import SwiftUI

struct StatisticsView: View {
    @State private var selectedTab = 0
  var db: FirebaseManager

    var body: some View {
        TabView(selection: $selectedTab) {
            LeaderboardView(db: db)
                .tabItem {
                    Label("Leaderboard", systemImage: "list.number")
                }
                .tag(0)

            WinRatesView()
                .tabItem {
                    Label("Win Rates", systemImage: "chart.pie")
                }
                .tag(1)
        }
    }
}

struct LeaderboardView: View {
    @State private var players = [PlayerScore]()
  var db: FirebaseManager

    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .padding()

          List(db.players) { player in
                HStack {
                    Text(player.name)
                    Spacer()
                    Text("\(player.score)")
                }
            }
            .onAppear(perform: fetchPlayers)
        }
    }

    func fetchPlayers() {
        db.fetchPlayers()
    }
}


struct WinRatesView: View {
    var body: some View {
        Text("Win Rates") // Placeholder for now
    }
}

struct PlayerScore: Identifiable, Codable {
    var id: String 
    var name: String
    var score: Int
}


#Preview {
    StatisticsView(db: FirebaseManager())
}
