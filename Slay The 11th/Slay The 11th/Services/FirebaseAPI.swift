//
//  FirebaseAPI.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 29/08/2024.
//

import Firebase

@Observable class DatabaseManager {
static let shared = DatabaseManager()

private let playersKey = "players"

init() {}

  func fetchPlayers(limit: Int = 0) -> [PlayerScore] {
          if let data = UserDefaults.standard.data(forKey: playersKey) {
              do {
                  let decoder = JSONDecoder()
                  var players = try decoder.decode([PlayerScore].self, from: data)
                  players.sort(by: { $0.score > $1.score }) // Sort players by score descending
                  
                  // If a limit is set, return only that number of players
                  if limit > 0 {
                      return Array(players.prefix(limit))
                  } else {
                      return players
                  }
              } catch {
                  print("Failed to decode player data: \(error.localizedDescription)")
              }
          }
          return []
      }

func addNewPlayer(name: String) -> String {
    var players = fetchPlayers()
    let newPlayerID = UUID().uuidString
    let newPlayer = PlayerScore(id: newPlayerID, name: name, score: 0)
    players.append(newPlayer)
    savePlayers(players)
    return newPlayerID
}

func updatePlayerScore(playerId: String, newScore: Int) {
    var players = fetchPlayers()
    if let index = players.firstIndex(where: { $0.id == playerId }) {
        players[index].score = newScore
        savePlayers(players)
    } else {
        print("Player not found")
    }
}

private func savePlayers(_ players: [PlayerScore]) {
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(players)
        UserDefaults.standard.set(data, forKey: playersKey)
    } catch {
        print("Failed to encode player data: \(error.localizedDescription)")
    }
}
}

// Mock DataManager for Previews
class MockDataManager: DatabaseManager {
  override func fetchPlayers(limit: Int = 0) -> [PlayerScore] {
          return [
              PlayerScore(id: "1", name: "Player1", score: 100),
              PlayerScore(id: "2", name: "Player2", score: 200)
          ]
      }
}
