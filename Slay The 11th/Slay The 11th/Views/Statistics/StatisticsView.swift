  //
  //  StatisticsView.swift
  //  Slay The 11th
  //
  //  Created by Duong Tran Minh Hoang on 29/08/2024.
  //

import SwiftUI
import Pow
import NavigationTransitions

struct StatisticsView: View {
    @State private var selectedTab = 0
    var db: DatabaseManager = DatabaseManager.shared
    
  var body: some View {
    TabView(selection: $selectedTab) {
      LeaderboardView()
        .tabItem {
          Label(NSLocalizedString("leaderboard", comment: "Leaderboard tab label"), systemImage: "list.number")
        }
        .tag(0)
      
      AchievementsView(db: db)
        .tabItem {
          Label(NSLocalizedString("achievements", comment: "Achievements tab label"), systemImage: "star.fill")
        }
        .tag(1)
      
      GameplayStatisticsView(db: db)
        .tabItem {
          Label(NSLocalizedString("analytics", comment: "Analytics tab label"), systemImage: "percent")
        }
        .tag(2)
    }
    .onAppear {
      AudioManager.shared.stopBackgroundMusic()
      AudioManager.shared.playBackgroundMusic("achievement")
    }
    .onDisappear {
      AudioManager.shared.stopBackgroundMusic()
      AudioManager.shared.playBackgroundMusic("mainMenu")
    }
    }
}

struct LeaderboardView: View {
    private let itemsPerPage = 20
    private let db = DatabaseManager.shared
    @State private var players: [PlayerScore] = []
    @State private var currentPage = 1

    var body: some View {
        NavigationView {
            ZStack {
              Color(.systemBackground)
                                  .edgesIgnoringSafeArea(.all)
              
                if players.isEmpty {
                    Text(NSLocalizedString("no_players", comment: "No players to display"))
                        .font(.kreonTitle)
                        .foregroundColor(.gray)
                } else {
                    List(players.indices, id: \.self) { index in
                        let player = players[index]
                        LeaderboardRowView(rank: index + 1, player: player)
                            .onAppear {
                                if index == players.count - 1 {
                                    fetchMorePlayers()
                                }
                            }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color(.systemBackground))
                }
            }
            .onAppear {
                currentPage = 1
                fetchPlayers(limit: itemsPerPage)
            }
            .navigationTitle(NSLocalizedString("leaderboard", comment: "Leaderboard navigation title"))
            .navigationTransition(.slide)
        }
    }

    private func fetchPlayers(limit: Int) {
        players = db.fetchPlayers(limit: limit)
        .sorted(by: { $0.score > $1.score })
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
                .foregroundColor(Color(.label))
            Text(player.name)
                .font(.kreonCaption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(.label))
            Spacer()
            Text("\(player.score)")
                .font(.kreonHeadline)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10)
                .foregroundColor(Color(.label))
        }
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
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
                        .grayscale(achievement.isUnlocked ? 0 : 1)
                    VStack(alignment: .leading) {
                        Text(achievement.isUnlocked ? achievement.name : NSLocalizedString("unknown", comment: "Unknown achievement name"))
                            .font(.headline)
                        Text(achievement.isUnlocked ? achievement.description : NSLocalizedString("unknown", comment: "Unknown achievement description"))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
            .navigationTitle(Text(NSLocalizedString("achievements", comment: "Achievements navigation title")))
            .navigationTransition(.slide)
            .onAppear {
                achievements = db.fetchAchievements()
            }
        }
    }
}

struct AchievementCardView: View {
    var achievement: Achievement
    @State private var isGlowing = false

    var body: some View {
        HStack {
            Image(systemName: achievement.iconName)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .opacity(achievement.isUnlocked ? 1.0 : 0.3)
                .shadow(color: achievement.isUnlocked ? Color.yellow : Color.clear, radius: isGlowing ? 20 : 0)
                .onAppear {
                    if achievement.isUnlocked {
                        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            isGlowing = true
                        }
                    }
                }

            VStack(alignment: .leading) {
                Text(achievement.isUnlocked ? achievement.name : NSLocalizedString("unknown", comment: "Unknown achievement name"))
                    .font(.kreonHeadline)
                    .foregroundColor(achievement.isUnlocked ? .black : .gray)
                Text(achievement.isUnlocked ? achievement.description : NSLocalizedString("unknown", comment: "Unknown achievement description"))
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
    var stagesFinished: Int
  }


  #Preview {
    StatisticsView(db: DatabaseManager.shared)
  }
