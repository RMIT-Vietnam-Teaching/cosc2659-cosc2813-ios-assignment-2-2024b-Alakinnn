//
//  StatisticsView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 29/08/2024.
//

import SwiftUI

struct StatisticsView: View {
    @State private var selectedTab = 0
  var db: DatabaseManager

    var body: some View {
        TabView(selection: $selectedTab) {
            LeaderboardView()
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
    private let itemsPerPage = 20
    private let db = DatabaseManager.shared

    @State private var players: [PlayerScore] = [] // State to store players
    @State private var currentPage = 1 // Track the current page for pagination

    var body: some View {
        NavigationView {
            VStack {
                List(players.indices, id: \.self) { index in
                    let player = players[index]
                    LeaderboardRowView(rank: index + 1, player: player)
                        .onAppear {
                            // Check if the last item in the list is appearing to fetch more data
                            if index == players.count - 1 {
                                fetchMorePlayers()
                            }
                        }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Leaderboard")
            .onAppear {
                currentPage = 1 // Reset page
                fetchPlayers(limit: itemsPerPage)
            }
        }
    }

    private func fetchPlayers(limit: Int) {
        // Reset the players array when fetching anew
        players = db.fetchPlayers(limit: limit)
    }

    private func fetchMorePlayers() {
        currentPage += 1
        let newPlayers = db.fetchPlayers(limit: itemsPerPage * currentPage)
        players = Array(Set(players + newPlayers)).sorted(by: { $0.score > $1.score })
    }
}


struct LeaderboardRowView: View {
    var rank: Int
    var player: PlayerScore

    var body: some View {
        HStack {
            Text("\(rank)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            Text(player.name)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Text("\(player.score)")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10)
        }
        .padding(.vertical, 8)
        .background(Color.white) // Optional: Background color for each row
        .cornerRadius(8) // Optional: Rounded corners for each row
        .shadow(radius: 2) // Optional: Shadow for each row
    }
}



struct WinRatesView: View {
    var body: some View {
        Text("Win Rates") // Placeholder for now
    }
}

struct PlayerScore: Identifiable, Codable, Hashable {
    var id: String 
    var name: String
    var score: Int
}


#Preview {
    StatisticsView(db: MockDataManager())
}
