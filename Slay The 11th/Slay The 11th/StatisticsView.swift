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
            
            AchievementsView(db: db)
                            .tabItem {
                                Label("Achievements", systemImage: "star.fill")
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
              .font(.kreonBody)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding(.leading, 10)
              Text(player.name)
              .font(.kreonCaption)
                  .frame(maxWidth: .infinity, alignment: .leading)
              Spacer()
              Text("\(player.score)")
              .font(.kreonHeadline)
                  .frame(maxWidth: .infinity, alignment: .trailing)
                  .padding(.trailing, 10)
          }
          .padding(.vertical, 8)
          .background(Color.white) // Optional: Background color for each row
          .cornerRadius(8) // Optional: Rounded corners for each row
          .shadow(radius: 2) // Optional: Shadow for each row
      }
  }

  struct AchievementsView: View {
      @State private var achievements: [Achievement] = []
      var db = DatabaseManager.shared

      var body: some View {
          NavigationView {
              List(achievements) { achievement in
                  HStack {
                      Image(achievement.iconName)
                          .resizable()
                          .frame(width: 50, height: 50)
                          .grayscale(achievement.isUnlocked ? 0 : 1) // Grayscale if not unlocked
                      VStack(alignment: .leading) {
                          Text(achievement.isUnlocked ? achievement.name : "???")
                              .font(.headline)
                          Text(achievement.isUnlocked ? achievement.description : "???")
                              .font(.subheadline)
                              .foregroundColor(.gray)
                      }
                  }
                  .padding()
              }
              .navigationTitle("Achievements")
              .onAppear {
                  achievements = db.fetchAchievements()
              }
          }
      }
  }

  struct AchievementCardView: View {
      var achievement: Achievement

      var body: some View {
          HStack {
              Image(achievement.iconName)
                  .resizable()
                  .frame(width: 50, height: 50)
                  .clipShape(Circle())
                  .opacity(achievement.isUnlocked ? 1.0 : 0.3) 

              VStack(alignment: .leading) {
                  Text(achievement.isUnlocked ? achievement.name : "???")
                      .font(.kreonHeadline)
                      .foregroundColor(achievement.isUnlocked ? .black : .gray)
                  Text(achievement.isUnlocked ? achievement.description : "???")
                      .font(.kreonBody)
                      .foregroundColor(achievement.isUnlocked ? .black : .gray)
              }
          }
          .padding()
      }
  }

  struct Achievement: Identifiable, Codable {
      var id: String
      var name: String
      var description: String
      var iconName: String
      var isUnlocked: Bool
  }

  struct PlayerScore: Identifiable, Codable, Hashable {
      var id: String
      var name: String
      var score: Int
  }


  #Preview {
      StatisticsView(db: MockDataManager())
  }
